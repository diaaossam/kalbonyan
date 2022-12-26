import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kalbonyan/models/message_model.dart';
import 'package:kalbonyan/models/notification_model.dart';
import 'package:kalbonyan/models/user_model.dart';
import 'package:kalbonyan/screens/user/chat/chat_screen.dart';
import 'package:kalbonyan/screens/user/home/home_screen.dart';
import 'package:kalbonyan/screens/user/notification/user_notification.dart';
import 'package:kalbonyan/screens/user/profile/user_profile.dart';
import 'package:kalbonyan/shared/helper/mangers/assets_manger.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../shared/services/loca_notification_service/local_notification_service.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    UserHomeScreen(),
    UserNotification(),
    UserChatScreen(),
    UserProfile(),
  ];

  List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      activeIcon: Image.asset(
        AssetsManger.home,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: ColorsManger.darkPrimary,
      ),
      icon: Image.asset(
        AssetsManger.home,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: ColorsManger.appTextColor,
      ),
      label: ConstantsManger.home,
    ),
    BottomNavigationBarItem(
      activeIcon: Image.asset(
        AssetsManger.notification,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
      ),
      icon: Image.asset(
        AssetsManger.notification,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: ColorsManger.appTextColor,
      ),
      label: ConstantsManger.notification,
    ),
    BottomNavigationBarItem(
      activeIcon: Image.asset(
        AssetsManger.chat,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: ColorsManger.darkPrimary,
      ),
      icon: Image.asset(
        AssetsManger.chat,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: ColorsManger.appTextColor,
      ),
      label: ConstantsManger.chat,
    ),
    BottomNavigationBarItem(
      activeIcon: Image.asset(
        AssetsManger.profile,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: ColorsManger.darkPrimary,
      ),
      icon: Image.asset(
        AssetsManger.profile,
        height: getProportionateScreenHeight(40),
        width: getProportionateScreenHeight(40),
        color: ColorsManger.appTextColor,
      ),
      label: ConstantsManger.profile,
    ),
  ];
  List<String> titles = [
    ConstantsManger.home,
    ConstantsManger.notification,
    ConstantsManger.chat,
    ConstantsManger.profile,
  ];

  int currentIndex = 0;

  void changeBottomNavBar({required int index}) {
    currentIndex = index;
    if (index == 3) {
      getUserInfo();
    }else if(index ==2){
      readMessages();
    }else if(index == 1){
      getallNotification();
    }
    emit(ChangeBottomNavBarIndexState());
  }

  ////////////////// LocationSysyem ////////////////////////////////

  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? locationData;
  StreamSubscription<LocationData>? _locationDatatSub;
  bool? isMocking;

  Future<void> listenLocation() async {
    await setUpPermissions();
    _locationDatatSub = location.onLocationChanged.handleError((error) {
      _locationDatatSub?.cancel();
      _locationDatatSub = null;
    }).listen((loca) async {
      await FirebaseFirestore.instance
          .collection(ConstantsManger.USERS)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"lat": loca.latitude, "lon": loca.longitude});
    });
    Future.delayed(
      Duration(seconds: 60),
      () async {
        await _locationDatatSub!.cancel();
        _locationDatatSub = null;
      },
    );
  }

  void initApp() async {
    emit(InitAppState());
    FirebaseMessaging.instance.subscribeToTopic("diaaTopic");
    await setUpPermissions();

  }

  Future<void> setUpPermissions() async {
    try {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled!) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled!) {
          return;
        }
      }
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }
      locationData = await location.getLocation();
      emit(SetUpLocationState());
      getUserLocation();
    } catch (error) {
      print(error.toString());
    }
  }

  LocationData? currentLocationData;



  ///////////////////////Home /////////////////////////////


  late GoogleMapController controller;
  bool added = false;

  late UserModel userModelAnimated;

  void getUserLocation() {
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(ConstantsManger.ADMIN_ID)
        .snapshots()
        .listen((event) {
      userModelAnimated = UserModel.fromJson(event.data() ?? {});
      if (added) {
        animateCam(latitude: userModelAnimated.lat ?? 0, longitude: userModelAnimated.lon ?? 0);
      }
      emit(GetUserLocationSuccess());
    });
  }

  void onMapCreted({required GoogleMapController mController}) {
    this.controller = mController;
    this.added = true;
    emit(MapControllerSuccess());
  }

  Future<void> animateCam({required double latitude, required double longitude}) async {
    await controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(latitude, longitude), zoom: 60.47)));
  }

  //////////////////////////// Chat Screen///////////////////////////////

  List<NotificationModel> allNotification = [];

  void getallNotification() async {
    emit(GetAllNotificationLoading());
    FirebaseFirestore.instance
        .collection(ConstantsManger.notificationPath)
        .get()
        .then((event) {
      allNotification.clear();
      event.docs.forEach((element) {
        allNotification.add(NotificationModel.fromJson(json: element.data()));
      });
      emit(GetAllNotificationSuccess());
    });
  }

  void changeNotificationState({required String id}) {
    FirebaseFirestore.instance
        .collection(ConstantsManger.notificationPath)
        .doc(id)
        .update({
      "seenList": FieldValue.arrayUnion([getCurrentUserUid()])
    });
  }

  ///////////////////// Notification Screen ///////////////////////////

  void sendMessage({
    required String receiver,
    required String message,
  }) {
    MessageModel messageModel = MessageModel(
        sender: getCurrentUserUid(),
        receiver: receiver,
        time: '${DateFormat.jms().format(DateTime.now())}',
        message: message);

    //send Message
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(getCurrentUserUid())
        .collection(ConstantsManger.CHATS)
        .doc(receiver)
        .collection(ConstantsManger.CHATS)
        .add(messageModel.toMap());

    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(receiver)
        .collection(ConstantsManger.CHATS)
        .doc(getCurrentUserUid())
        .collection(ConstantsManger.CHATS)
        .add(messageModel.toMap());

    DocumentReference doc2 = FirebaseFirestore.instance
        .collection(ConstantsManger.CHATLIST)
        .doc(ConstantsManger.CHATLIST)
        .collection("${receiver}")
        .doc(getCurrentUserUid());
    doc2.get().then((value) {
      if (!value.exists) {
        doc2.set({"id": getCurrentUserUid()});
      }
    });
  }

  String formatTime({required String time}) {
    List list = time.split(':');
    String ma = time.substring(time.length - 2, time.length);
    String messageTime = '${list[0]}:${list[1]} $ma';

    return messageTime;
  }

  List<MessageModel> userMessageList = [];

  void readMessages() {
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(ConstantsManger.CHATS)
        .doc(ConstantsManger.ADMIN_ID)
        .collection(ConstantsManger.CHATS)
        .orderBy('time')
        .snapshots()
        .listen((event) {
      userMessageList.clear();
      event.docs.forEach((element) {
        userMessageList.add(MessageModel.fromJson(element.data()));
      });
      emit(GetMessageSuccessState());
    });
  }

  String? getCurrentUserUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  void serachQuery({required String query}) {
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .where('name',
            isGreaterThanOrEqualTo: query,
            isLessThan: query.substring(0, query.length - 1) +
                String.fromCharCode(query.codeUnitAt(query.length - 1) + 1))
        .get()
        .then((value) {});
  }

  ///////////////////////////////////// Profile ///////////////////////

  UserModel? userModel;

  void getUserInfo() {
    emit(GetMainUserInfoLoading());
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data() ?? {});
      emit(GetMainUserInfoSuccess());
    }).catchError((error) {
      emit(GetMainUserInfoFailure());
    });
  }

  List<String> companiesList = [
    ConstantsManger.company1,
    ConstantsManger.company2,
  ];
  String? companyName;

  void chooseCompanyName({required String value}) {
    this.companyName = value;
    emit(ChooseCompanyMainState());
  }

  Future<void> deleteUserAccount() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection(ConstantsManger.USERS)
          .doc(getCurrentUserUid());
      transaction.delete(documentReference);
    });
    await FirebaseAuth.instance.currentUser!.delete().then((value) {
      emit(DeleteAccountSuccess());
    });
  }

  void updateUserInfo({required UserModel userModel}) {
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(getCurrentUserUid())
        .update(userModel.toMap())
        .then((value) {
      emit(UpdateUserDataSuccess());
    });
  }
}

import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kalbonyan/models/journey_model.dart';
import 'package:kalbonyan/models/markers_model.dart';
import 'package:kalbonyan/models/notification_model.dart';
import 'package:kalbonyan/models/user_model.dart';
import 'package:kalbonyan/screens/admin/home/admin_home.dart';
import 'package:kalbonyan/screens/admin/notification/admin_notification.dart';
import 'package:kalbonyan/screens/admin/profile/admin_profile.dart';
import 'package:kalbonyan/screens/admin/users/all_users_screen.dart';
import 'package:kalbonyan/shared/helper/mangers/assets_manger.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/shared/services/network/dio_helper.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

part 'main_admin_state.dart';

class MainAdminCubit extends Cubit<MainAdminState> {
  MainAdminCubit() : super(MainAdminInitial());

  static MainAdminCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = [
    AdminHome(),
    AdminNotification(),
    AllUsersScreen(),
    AdminProfile(),
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
    if (index == 2) {
      getAllUsers();
    } else if (index == 1) {
      getallNotification();
    }
    emit(ChangeBottomNavBarIndexState());
  }

  ////////////////// LocationSysyem ////////////////////////////////

  var markers = HashSet<Marker>();

  void addMarker({required List<MarkerModel> locationList}) async {
    markers.clear();
    for (int i = 0; i < locationList.length; i++) {
      LatLng latLng =
          LatLng(locationList[i].lat ?? 0.0, locationList[i].lon ?? 0.0);
      markers.add(Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(
              title: locationList[i].title, snippet: locationList[i].title),
          onTap: () => emit(TapMarkerState(title: "${locationList[i].title}")),
          position: LatLng(latLng.latitude, latLng.longitude),
          markerId: MarkerId("${locationList[i].lat}")));
    }
    emit(AddMarkers());
  }

  /////////////////////// Home ////////////////////////////////////

  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? locationData;
  StreamSubscription<LocationData>? _locationDatatSub;
  bool? isMocking;

  List<MarkerModel> markerList = [];

  void getAllLocations() {
    FirebaseFirestore.instance
        .collection(ConstantsManger.adminLocations)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      markerList.clear();
      value.docs.forEach((element) {
        MarkerModel markerModel = MarkerModel.fromJson(element.data());
        markerList.add(markerModel);
      });
      getUserInfo();
    });
  }

  Future<void> listenLocation({bool isFirstTime = false}) async {
    _locationDatatSub = location.onLocationChanged.handleError((error) {
      _locationDatatSub?.cancel();
      _locationDatatSub = null;
    }).listen((loca) async {
      await FirebaseFirestore.instance
          .collection(ConstantsManger.USERS)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({"lat": loca.latitude, "lon": loca.longitude});
    });
  }

  Future<void> setUpPermissions() async {
    emit(InitAppState());
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
      getAllJournies();
    } catch (error) {
      print(error.toString());
    }
  }

  LocationData? currentLocationData;

  List<JourneyModel> journyList = [];

  void getAllJournies() {
    FirebaseFirestore.instance
        .collection("journey")
        .snapshots()
        .listen((event) {
      journyList.clear();
      event.docs.forEach((element) {
        journyList.add(JourneyModel.fromJson(element.data()));
      });
      getAllLocations();
    });
  }

  /////////////////////////////Notification Screen //////////////////////////////

  void sendNotifiation(
      {required String title,
      required String body,
      bool fromHome = false,
      String? journeyId}) {
    final data = {
      "to": ConstantsManger.TOPIC,
      "notification": {
        "body": "${userModel!.name} $body",
        "title": title,
        "sound": "default"
      },
      "android": {
        "priority": "HIGH",
        "notification": {
          "notification_priority": "PRIORITY_HIGH",
          "sound": "default",
          "default_sound": true,
          "default_vibrate_timings": true,
          "default_light_settings": true,
        },
      },
      "data": {
        "id": "87",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
      }
    };
    DioHelper().postData(path: 'fcm/send', data: data).then((value) {
      if (value.statusCode == 200) {
        NotificationModel notificationModel = NotificationModel(
          title: title,
          body: body,
          date: DateFormat.yMMMMd().format(DateTime.now()),
          time: DateFormat.jms().format(DateTime.now()),
        );
        CollectionReference collectionReference = FirebaseFirestore.instance
            .collection(ConstantsManger.notificationPath);
        collectionReference.add(notificationModel.toMap()).then((docRef) {
          collectionReference.doc(docRef.id).update({"id": docRef.id});
        });
      }
      if (fromHome) {
        FirebaseFirestore.instance
            .collection("journey")
            .doc(journeyId)
            .update({"isDone": true});
      }
      emit(SendNotificationSuccess());
    });
  }

  List<NotificationModel> allNotification = [];

  void getallNotification() async {
    emit(GetAllNotificationLoading());
    FirebaseFirestore.instance
        .collection(ConstantsManger.notificationPath)
        .snapshots()
        .listen((event) {
      allNotification.clear();
      event.docs.forEach((element) {
        allNotification.add(NotificationModel.fromJson(json: element.data()));
      });
      emit(GetAllNotificationSuccess());
    });
  }

  ////////////////////////// Users /////////////////////////////

  List<UserModel> allUsersList = [];

  void getAllUsers() {
    emit(GetAllUsersLoading());
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .where("isAdmin", isEqualTo: false)
        .get()
        .then((value) {
      print(value.docs.length);
      allUsersList.clear();
      value.docs.forEach((element) {
        UserModel userModel = UserModel.fromJson(element.data());
        allUsersList.add(userModel);
      });
      emit(GetAllUsersSuccess());
    });
  }

  ///////////////////////////////////// Profile ///////////////////////

  UserModel? userModel;

  void getUserInfo() {
    listenLocation();
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((value) {
      userModel = UserModel.fromJson(value.data() ?? {});
      emit(SetUpHomeState());
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

  String? getCurrentUserUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }
}

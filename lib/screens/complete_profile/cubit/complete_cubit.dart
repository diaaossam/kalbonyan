import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/models/user_model.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';

part 'complete_state.dart';

class CompleteCubit extends Cubit<CompleteState> {
  CompleteCubit() : super(CompleteInitial());

  static CompleteCubit get(context) => BlocProvider.of(context);



  UserModel? userModel;

  void getUserInfo() {
    emit(GetUserInfoLoading());
    FirebaseFirestore.instance
        .collection(ConstantsManger.USERS)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
          print(value.data());
      userModel = UserModel.fromJson(value.data() ?? {});
      print(userModel!.joinNumber);
      emit(GetUserInfoSuccess());
    });
  }


  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? locationData;

  Future<void> setUpPermissions() async {
    print("Diaa");
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
      emit(SuccessRequestPermmsion());
    } catch (error) {
      print(error.toString());
    }
  }

  LocationData? currentLocationData;


}

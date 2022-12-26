import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kalbonyan/models/journey_model.dart';
import 'package:kalbonyan/models/markers_model.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:location/location.dart';
import 'package:meta/meta.dart';
import 'package:geocoding/geocoding.dart' as geo;

part 'picker_state.dart';

class PickerCubit extends Cubit<PickerState> {
  PickerCubit() : super(PickerInitial());

  static PickerCubit get(context) => BlocProvider.of(context);

  Location location = new Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? locationData;

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
      emit(SetUpLocationState());
    } catch (error) {
      print(error.toString());
    }
  }

  LocationData? currentLocationData;

  Future<String> getLocationAddress(
      {required double lat, required double lon}) async {
    List<geo.Placemark> addressList =
        await geo.placemarkFromCoordinates(lat, lon);
    String address =
        '${addressList[0].country} - ${addressList[0].administrativeArea} - ${addressList[0].subAdministrativeArea} - ${addressList[0].street}';
    return address;
  }


  List<MarkerModel> markerList = [];
  void saveLocation({required String title, required lat, required lon}) {
    FirebaseFirestore.instance
        .collection(ConstantsManger.adminLocations)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((dode) {
          if(dode.docs.length >= 3 ){
            emit(AddMarkerFailure());
          }else{
            MarkerModel model = MarkerModel(
                id: ConstantsManger.DEFULT,
                title: title,
                lat: lat,
                lon: lon,
                userId: FirebaseAuth.instance.currentUser!.uid);
            FirebaseFirestore.instance
                .collection(ConstantsManger.adminLocations)
                .add(model.toMap())
                .then((value) {
              FirebaseFirestore.instance
                  .collection(ConstantsManger.adminLocations)
                  .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .get()
                  .then((mo) {
                    if(mo.docs.length >= 3){
                      emit(AddMarkerSuccess(true));
                    }else{
                      emit(AddMarkerSuccess(false));
                    }
              });
            });
          }

    });

  }
}

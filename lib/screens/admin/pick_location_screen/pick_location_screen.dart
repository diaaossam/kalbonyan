import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kalbonyan/main_admin_layout/main_admin_layout.dart';
import 'package:kalbonyan/screens/admin/pick_location_screen/cubit/picker_cubit.dart';
import 'package:kalbonyan/screens/admin/pick_location_screen/widget/custom_pick.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/shared/helper/methods.dart';
import 'package:kalbonyan/widget/custom_button.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

class PickLocationsScreen extends StatefulWidget {
  @override
  State<PickLocationsScreen> createState() => _PickLocationsScreenState();
}

class _PickLocationsScreenState extends State<PickLocationsScreen> {
  late MapLatLng _markerPosition;
  late MapZoomPanBehavior _mapZoomPanBehavior;
  late MapTileLayerController _controller;

  @override
  void initState() {
    _controller = MapTileLayerController();
    _mapZoomPanBehavior = MapZoomPanBehavior(zoomLevel: 4);
    super.initState();
  }

  void updateMarkerChange(Offset position) {
    _markerPosition = _controller.pixelToLatLng(position);
    if (_controller.markersCount > 0) {
      _controller.clearMarkers();
    }
    _controller.insertMarker(0);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PickerCubit()..setUpPermissions(),
      child: BlocConsumer<PickerCubit, PickerState>(
        listener: (context, state) {
          if (state is AddMarkerFailure) {
            showToast(
                msg: "لا يمكن إضافة الخيمة قد تم تخطي 3 خيمات",
                color: Colors.red);
          } else if (state is AddMarkerSuccess) {
            if(state.isDone == true){
              showToast(msg: "تم إضافة الخيمة بنجاح جاري الان تحويلك", color: Colors.green);
               Future.delayed(Duration(seconds: 2),()=>navigateToAndFinish(context,MainAdminLayout()));
            }else{
              showToast(msg: "تم إضافة الخيمة بنجاح", color: Colors.green);
            }
          }
        },
        builder: (context, state) {
          PickerCubit cubit = PickerCubit.get(context);
          return Scaffold(
            key: _scaffoldKey,
            body: state is InitAppState
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SafeArea(
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTapUp: (TapUpDetails details) async {
                            updateMarkerChange(details.localPosition);
                            String address = await cubit.getLocationAddress(
                                lat: _markerPosition.latitude,
                                lon: _markerPosition.longitude);
                            _scaffoldKey.currentState!.showBottomSheet((context) => CustomPickerDesign(
                                    place: address,
                                    lat: _markerPosition.latitude,
                                    lon: _markerPosition.longitude));
                          },
                          child: SfMaps(
                            layers: [
                              MapTileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                zoomPanBehavior: _mapZoomPanBehavior,
                                initialFocalLatLng: MapLatLng(
                                    cubit.locationData!.latitude!,
                                    cubit.locationData!.longitude!),
                                controller: _controller,
                                markerBuilder:
                                    (BuildContext context, int index) {
                                  return MapMarker(
                                    latitude: _markerPosition.latitude,
                                    longitude: _markerPosition.longitude,
                                    child: Icon(Icons.location_on,
                                        color: ColorsManger.darkPrimary),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}

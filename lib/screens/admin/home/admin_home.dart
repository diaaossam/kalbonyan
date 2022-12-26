import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kalbonyan/main_admin_layout/cubit/main_admin_cubit.dart';
import 'package:kalbonyan/models/journey_model.dart';
import 'package:kalbonyan/screens/admin/home/widget/custom_bottom_sheet.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/widget/app_text.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainAdminCubit, MainAdminState>(
      listener: (context, state) {
        if (state is TapMarkerState) {}
      },
      builder: (context, state) {
        MainAdminCubit cubit = MainAdminCubit.get(context);
        return state is InitAppState
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  GoogleMap(
                    mapType: MapType.terrain,
                    onMapCreated: (controller) {
                      cubit.addMarker(locationList: cubit.markerList);
                    },
                    markers: cubit.markers,
                    initialCameraPosition: CameraPosition(
                      // target: LatLng(cubit.locationData!.latitude!, cubit.locationData!.longitude!,),
                      target: LatLng(
                        cubit.markerList[0].lat,
                        cubit.markerList[0].lon,
                      ),
                      zoom: 15,
                    ),
                  ),
                  CustomBottomDesign(
                      cubit.journyList,
                      cubit,
                      state is TapMarkerState
                          ? state.title
                          : cubit.journyList[0].title!),
                ],
              );
      },
    );
  }
}

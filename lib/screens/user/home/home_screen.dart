import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kalbonyan/main_layout/cubit/main_cubit.dart';
import 'package:kalbonyan/widget/custom_button.dart';

import '../../admin/home/widget/custom_bottom_sheet.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        MainCubit cubit = MainCubit.get(context);
        return state is! GetUserLocationSuccess
            ? const Center(
                child: CircularProgressIndicator(),
              )
            :Center() /*GoogleMap(
          mapType: MapType.normal,
          markers: {
            Marker(
                markerId: MarkerId('${cubit.userModelAnimated.userId}'),
                position: LatLng(cubit.userModelAnimated.lat ?? 0, cubit.userModelAnimated.lon ?? 0),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta)),
          },
          onMapCreated: (GoogleMapController controller) {
            cubit.onMapCreted(mController: controller);
          },
          initialCameraPosition: CameraPosition(
              zoom: 14.5,
              target: LatLng(cubit.userModelAnimated.lat ?? 0,
                  cubit.userModelAnimated.lon ?? 0)),
        )*/;
      },
    );
  }
}

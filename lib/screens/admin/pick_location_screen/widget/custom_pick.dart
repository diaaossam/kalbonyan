import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/screens/admin/pick_location_screen/cubit/picker_cubit.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/widget/app_text.dart';

class CustomPickerDesign extends StatelessWidget {
  final String place;
  final double lat;
  final double lon;

  const CustomPickerDesign(
      {super.key, required this.place, required this.lat, required this.lon});


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PickerCubit, PickerState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Container(
          height: SizeConfigManger.bodyHeight * .25,
          width: double.infinity,
          color: ColorsManger.blackTranspart,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: SizeConfigManger.bodyHeight * .04,
                horizontal: SizeConfigManger.bodyHeight * .01),
            child: Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                Container(
                  width: double.infinity,
                  height: SizeConfigManger.bodyHeight * .08,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                          getProportionateScreenHeight(15))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: AppText(
                        text: place,
                        color: ColorsManger.darkPrimary,
                        textSize: 18,
                        align: TextAlign.start,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                  onTap: ()=>PickerCubit.get(context).saveLocation(title: place, lat: lat, lon: lon),
                  child: Container(
                    height: SizeConfigManger.bodyHeight * .08,
                    width: SizeConfigManger.screenWidth * .2,
                    decoration: BoxDecoration(
                        color: ColorsManger.darkPrimary,
                        borderRadius: BorderRadius.circular(
                            getProportionateScreenHeight(15))),
                    child: Center(
                      child: AppText(
                        text: "حفظ",
                        color: Colors.white,
                        textSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

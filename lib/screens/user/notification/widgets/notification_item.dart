import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kalbonyan/main_layout/cubit/main_cubit.dart';
import 'package:kalbonyan/models/notification_model.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/widget/app_text.dart';

class NotificationItem extends StatelessWidget {
  NotificationModel notificationModel;
  MainCubit cubit;

  NotificationItem({required this.notificationModel,required this.cubit});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>cubit.changeNotificationState(id: "${notificationModel.id}"),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfigManger.bodyHeight * .005,
          vertical: SizeConfigManger.bodyHeight * .005,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: SizeConfigManger.bodyHeight * .005,
          vertical: SizeConfigManger.bodyHeight * .005,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 3,
                blurRadius: 3,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            color: setUpColors(),
            borderRadius: BorderRadius.circular(SizeConfigManger.bodyHeight * .02)),
        child: Padding(
          padding: EdgeInsets.all(getProportionateScreenHeight(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  AppText(
                    text: "${notificationModel.title}",
                    fontWeight: FontWeight.w800,
                    textSize: 20,
                    color: ColorsManger.darkPrimary,
                  ),
                  const Spacer(),
                  AppText(
                    text: "${notificationModel.time}",
                    fontWeight: FontWeight.w500,
                    textSize: 16,
                    color: ColorsManger.black,
                  ),
                ],
              ),
              SizedBox(height: SizeConfigManger.bodyHeight * .005),
              AppText(
                text: "${notificationModel.body}",
                fontWeight: FontWeight.w500,
                textSize: 16,
                color: ColorsManger.black,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color setUpColors() {
    if(notificationModel.seenList.contains(FirebaseAuth.instance.currentUser!.uid)){
      return ColorsManger.lightPrimary2;
    }else{
      print("Diaa2");
      return Colors.white;
    }
  }
}

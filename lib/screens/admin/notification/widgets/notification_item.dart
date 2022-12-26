import 'package:flutter/material.dart';
import 'package:kalbonyan/models/notification_model.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/widget/app_text.dart';

class NotificationItem extends StatelessWidget {
  NotificationModel notificationModel;

  NotificationItem({required this.notificationModel});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          color: Colors.white,
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
    );
  }
}

import 'package:flutter/material.dart';

import '../shared/helper/mangers/size_config.dart';
import 'app_text.dart';

class NotificationItemDesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (dir) {},
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(5)),
        decoration: BoxDecoration(
            color: Color(0xffDBFFE1),
            border: Border.all(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
                text: "notification title",
                fontWeight: FontWeight.w500,
                maxLines: 1,
                textSize: 20,
                color: Colors.black),
            SizedBox(height: getProportionateScreenHeight(5)),
            AppText(
                maxLines: 3,
                text: "notification body here",
                textSize: 18,
                color: Colors.black54),
            SizedBox(height: getProportionateScreenHeight(5)),
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: AppText(
                text: "10:00",
                color: Colors.grey[400],
                textSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

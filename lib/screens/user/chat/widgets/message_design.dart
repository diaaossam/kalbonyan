import 'package:flutter/material.dart';

import '../../../../shared/helper/mangers/colors.dart';
import '../../../../shared/helper/mangers/size_config.dart';
import '../../../../widget/app_text.dart';

class MessageDesign extends StatelessWidget {
  bool isMyMessage;
  String message;
  String time;

  MessageDesign({required this.isMyMessage, required this.message,required this.time});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenHeight(15),
          vertical: getProportionateScreenHeight(3)),
      child: Column(
        crossAxisAlignment:
        isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 3,
                  blurRadius: 3,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              color: isMyMessage ? ColorsManger.lightPrimary : Colors.white,
              borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(getProportionateScreenHeight(10)),
                  right: Radius.circular(getProportionateScreenHeight(10))),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                  start: getProportionateScreenHeight(5),
                  top: getProportionateScreenHeight(1),
                  bottom: getProportionateScreenHeight(5),
                  end: getProportionateScreenHeight(5)),
              child: Padding(
                padding: EdgeInsets.all(getProportionateScreenHeight(10.0)),
                child: AppText(text: '${message}', maxLines: 100,
                color: Colors.black,
                ),
              ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(5)),
          time == 0 ? Center():Padding(
            padding: EdgeInsetsDirectional.only(end: getProportionateScreenHeight(isMyMessage ? 15 : 0),start: getProportionateScreenHeight(isMyMessage ? 0 :15)),
            child: AppText(
              text:time,
              color: Color(0xff171717).withOpacity(.5),
              textSize: getProportionateScreenHeight(14.0),
            ),
          )
        ],
      ),
    );
  }
/*
  String formatTime(){
    String myTime = time.split(" ")[1];
    var list = myTime.split(":");
    return "${list[0]}:${list[01]}";
  }
*/
}

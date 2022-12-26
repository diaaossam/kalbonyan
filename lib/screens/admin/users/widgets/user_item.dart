import 'package:flutter/material.dart';
import 'package:kalbonyan/models/user_model.dart';
import 'package:kalbonyan/screens/admin/admin_chat/admin_chat_screen.dart';
import 'package:kalbonyan/shared/helper/mangers/assets_manger.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/shared/helper/methods.dart';
import 'package:kalbonyan/widget/app_text.dart';

class UserItemDesign extends StatelessWidget {
  UserModel userModel;

  UserItemDesign(this.userModel);

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
          borderRadius:
              BorderRadius.circular(SizeConfigManger.bodyHeight * .02)),
      child: Padding(
        padding: EdgeInsets.all(getProportionateScreenHeight(15)),
        child: Row(
          children: [
            AppText(
              text: "Diaa Ossam",
              fontWeight: FontWeight.w600,
              textSize: 18,
              color: ColorsManger.black,
            ),
            Spacer(),
            GestureDetector(
                onTap: () {
                  print("Diaa");
                  navigateTo(
                    context,
                    AdminChatScreen(
                      name: "${userModel.name}",
                      receiverId: "${userModel.userId}",
                    ));
                },
                child: Image.asset(AssetsManger.chat))
          ],
        ),
      ),
    );
  }
}

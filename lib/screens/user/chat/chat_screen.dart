import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/main_layout/cubit/main_cubit.dart';
import 'package:kalbonyan/screens/user/chat/widgets/message_design.dart';
import 'package:kalbonyan/shared/helper/mangers/assets_manger.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:kalbonyan/widget/custom_text_form_field.dart';

import '../../../shared/helper/mangers/size_config.dart';

class UserChatScreen extends StatelessWidget {
  var messageController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainCubit, MainState>(
      listener: (context, state) {},
      builder: (context, state) {
        MainCubit cubit = MainCubit.get(context);
        return Column(
          children: [
            SizedBox(height: SizeConfigManger.bodyHeight * .02),
            Expanded(
                child: ListView.builder(
                    itemCount: cubit.userMessageList.length,
                    reverse: true,
                    itemBuilder: (context, index) => MessageDesign(
                        time:
                            "${cubit.userMessageList[cubit.userMessageList.length - 1 - index].time}",
                        isMyMessage: cubit.userMessageList[cubit.userMessageList.length - 1 - index].sender ==
                            FirebaseAuth.instance.currentUser!.uid ? true:false,
                        message:
                            "${cubit.userMessageList[cubit.userMessageList.length - 1 - index].message}"))),
            Padding(
              padding: EdgeInsetsDirectional.only(
                  start: SizeConfigManger.bodyHeight * .02,
                  end: SizeConfigManger.bodyHeight * .02),
              child: Row(
                children: [
                  InkWell(
                      onTap: () {
                        if (messageController.text.isNotEmpty) {
                          cubit.sendMessage(
                              receiver: ConstantsManger.ADMIN_ID,
                              message: messageController.text);
                          messageController.clear();
                        }
                      },
                      child: Image.asset(
                        AssetsManger.send,
                        width: SizeConfigManger.bodyHeight * .08,
                        height: SizeConfigManger.bodyHeight * .16,
                      )),
                  SizedBox(width: SizeConfigManger.bodyHeight * .01),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              getProportionateScreenHeight(30.0))),
                      child: CustomTextFormField(
                        controller: messageController,
                        hintText: "أكتب رسالتك هنا",
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/models/user_model.dart';
import 'package:kalbonyan/screens/admin/admin_chat/cubit/chat_cubit.dart';
import 'package:kalbonyan/screens/admin/admin_chat/cubit/chat_cubit.dart';
import 'package:kalbonyan/screens/admin/admin_chat/cubit/chat_cubit.dart';
import 'package:kalbonyan/screens/user/chat/widgets/message_design.dart';
import 'package:kalbonyan/shared/helper/mangers/assets_manger.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/widget/app_text.dart';
import 'package:kalbonyan/widget/custom_text_form_field.dart';

class AdminChatScreen extends StatelessWidget {
  var messageController = TextEditingController();

  String receiverId;
  String name;

  AdminChatScreen({required this.receiverId, required this.name});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatCubit()..readMessages(receverId: receiverId),
      child: BlocConsumer<ChatCubit, ChatState>(
        listener: (context, state) {},
        builder: (context, state) {
          ChatCubit cubit = ChatCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: AppText(
                  text: "$name",
                  color: Colors.white,
                  textSize: 25,
                  fontWeight: FontWeight.w700),

            ),

            body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: SizeConfigManger.bodyHeight * .02),
                  Expanded(
                      child: ListView.builder(
                          itemCount: cubit.userMessageList.length,
                          reverse: true,
                          itemBuilder: (context, index) => MessageDesign(
                              time:
                              "${cubit.userMessageList[cubit.userMessageList.length - 1 - index].time}",
                              isMyMessage: cubit
                                  .userMessageList[
                              cubit.userMessageList.length -
                                  1 -
                                  index]
                                  .sender ==
                                  FirebaseAuth.instance.currentUser!.uid
                                  ? true
                                  : false,
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
                                    receiver: receiverId,
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
              ),
            ),
          );
        },
      ),
    );
  }
}

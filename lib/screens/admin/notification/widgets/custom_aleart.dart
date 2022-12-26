import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/main_admin_layout/cubit/main_admin_cubit.dart';
import 'package:kalbonyan/widget/app_text.dart';
import 'package:kalbonyan/widget/custom_button.dart';
import 'package:kalbonyan/widget/custom_text_form_field.dart';

class CustomNotificationDialog extends StatelessWidget {
  var title = TextEditingController();
  var body = TextEditingController();
  var formKey = GlobalKey<FormState>();
  MainAdminCubit cubit;


  CustomNotificationDialog(this.cubit);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: ListBody(
            children: <Widget>[
              const SizedBox(height: 30),
              Center(
                  child: AppText(
                    text: "إرسال إشعار",
                    textSize: 25,
                  )),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: title,
                validate: (String? value) {
                  if (value!.isEmpty) {
                    return "عنوان الرسالة مطلوب";
                  }
                },
                hintText: "عنوان الرسالة",
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: body,
                validate: (String? value) {
                  if (value!.isEmpty) {
                    return "نص الرسالة مطلوب";
                  }
                },
                maxLines: 10,
                hintText: "نص الرسالة",
              ),
              const SizedBox(height: 40),
              CustomButton(
                  text: "إرسال ",
                  press: () {
                    if (formKey.currentState!.validate()) {
                      cubit.sendNotifiation(title: title.text,body: body.text);
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}

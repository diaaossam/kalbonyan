import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/screens/check_screen/cubit/check_cubit.dart';
import 'package:kalbonyan/screens/login_screen/login_screen.dart';
import 'package:kalbonyan/shared/helper/mangers/assets_manger.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/shared/helper/methods.dart';
import 'package:kalbonyan/widget/app_text.dart';
import 'package:kalbonyan/widget/custom_button.dart';
import 'package:kalbonyan/widget/custom_text_form_field.dart';

class CheckScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckCubit(),
      child: BlocConsumer<CheckCubit, CheckState>(
        listener: (context, state) {
          if (state is UserNotExistsState) {
            showCustomDialog(context: context, success: false);
          } else if (state is UserExistsState) {
            showCustomDialog(context: context, success: true);
            Future.delayed(const Duration(seconds: 2), () => navigateTo(context, LoginScreen(phone.text)));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: AppText(
                  text: "تسجيل الدخول",
                  color: Colors.white,
                  textSize: 25,
                  fontWeight: FontWeight.w700),
            ),
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfigManger.bodyHeight * .1,
                      ),
                      Image.asset(
                        AssetsManger.logo,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(
                        height: SizeConfigManger.bodyHeight * .1,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfigManger.bodyHeight * .03),
                        child: Column(
                          children: [
                            Align(
                                alignment: AlignmentDirectional.topStart,
                                child: AppText(
                                  text: 'اهلا بك !',
                                  color: ColorsManger.appTextColor,
                                  fontWeight: FontWeight.w700,
                                )),
                            Align(
                                alignment: AlignmentDirectional.topStart,
                                child: Row(
                                  children: [
                                    AppText(
                                      text:
                                          'أهلا بك قم بملء البيانات التالية لإتمام ',
                                      color: ColorsManger.appTextColor,
                                      fontWeight: FontWeight.w500,
                                      textSize: 16,
                                    ),
                                    AppText(
                                      text: 'تسجيل الدخول',
                                      fontWeight: FontWeight.w500,
                                      textSize: 16,
                                      color: ColorsManger.darkPrimary,
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: SizeConfigManger.bodyHeight * .02,
                            ),
                            CustomTextFormField(
                              controller: phone,
                              prefix: AssetsManger.phone,
                              validate: (String? value) {
                                if (value!.isEmpty) {
                                  return "من فضلك قم بإدخال رقم الهاتف";
                                }
                              },
                            ),
                            SizedBox(
                              height: SizeConfigManger.bodyHeight * .08,
                            ),
                            state is LoadingCheckPhoneState
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : CustomButton(
                                    text: "تسجيل الدخول",
                                    press: () {
                                      if (formKey.currentState!.validate()) {
                                        CheckCubit.get(context)
                                            .checkPhoneInFireStore(
                                                phone: phone.text);
                                      }
                                    },
                                    weight: FontWeight.w800),
                            SizedBox(
                              height: SizeConfigManger.bodyHeight * .02,
                            ),
                            InkWell(
                              onTap: () {
                                //navigateTo(context, LoginScreen());
                              },
                              child: Align(
                                  alignment: AlignmentDirectional.topEnd,
                                  child: AppText(
                                    text: ' عضو جديد ؟',
                                    color: ColorsManger.darkPrimary,
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AwesomeDialog showCustomDialog(
      {required BuildContext context, required bool success}) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: success == true ? DialogType.success : DialogType.error,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: SizeConfigManger.bodyHeight * .1),
            success == true
                ? AppText(
                    text: "تم تسجيل الدخول بنجاح",
                    color: Colors.black,
                    fontWeight: FontWeight.w700)
                : Center(
                    child: AppText(
                        maxLines: 2,
                        align: TextAlign.center,
                        text: "خطأ في رقم الجوال/ المستخدم غير مسجل",
                        color: Colors.black,
                        fontWeight: FontWeight.w700)),
            SizedBox(height: SizeConfigManger.bodyHeight * .1),
          ],
        ),
      ),
    )..show();
  }
}

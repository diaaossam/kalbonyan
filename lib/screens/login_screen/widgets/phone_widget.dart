import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/screens/login_screen/cubit/login_cubit.dart';
import 'package:kalbonyan/screens/login_screen/widgets/radio_button.dart';
import 'package:kalbonyan/shared/helper/mangers/assets_manger.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/shared/helper/methods.dart';
import 'package:kalbonyan/widget/app_text.dart';
import 'package:kalbonyan/widget/custom_button.dart';
import 'package:kalbonyan/widget/custom_text_form_field.dart';

class PhoneWidget extends StatelessWidget {
  String phone;

  var id = TextEditingController();
  var phoneCon = TextEditingController();

  PhoneWidget({required this.phone});

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoadingPhoneState) {
          showCustomProgressIndicator(context);
        } else if (state is PhoneNumberSubmited) {
          Navigator.pop(context);
          LoginCubit.get(context).pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        } else if (state is ErrorOccurred) {
          print(state.errogMsg);
        }else if(state is SuccessIdState){
          LoginCubit.get(context).submitPhoneNumber(phone);
        }else if(state is FailureIdState){
          showCustomDialog(context: context);
        }
      },
      builder: (context, state) {
        LoginCubit cubit = LoginCubit.get(context);
        return SizedBox(
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
                          height: SizeConfigManger.bodyHeight * .01,
                        ),
                        CustomTextFormField(
                          controller: phoneCon..text = phone,
                          hintText: "رقم الجوال",
                          isEnable: false,
                          prefix: AssetsManger.phone,
                        ),
                        SizedBox(
                          height: SizeConfigManger.bodyHeight * .01,
                        ),
                        CustomTextFormField(
                          controller: id,
                          hintText: "رقم الهوية",
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return "رقم الهوية مطلوب";
                            }
                          },
                          prefix: AssetsManger.phone,
                        ),
                /*        SizedBox(
                          height: SizeConfigManger.bodyHeight * .01,
                        ),
                        RadioButtonDesign(),*/
                        SizedBox(
                          height: SizeConfigManger.bodyHeight * .02,
                        ),
                        CustomButton(
                            text: "تسجيل الدخول",
                            press: () {
                              if (formKey.currentState!.validate()) {
                                cubit.checkIsInfoCorrect(
                                    phone: phoneCon.text, id: id.text);
                              }
                            },
                            weight: FontWeight.w800),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  AwesomeDialog showCustomDialog({required BuildContext context}) {
    return AwesomeDialog(
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.error,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: SizeConfigManger.bodyHeight * .1),
           Center(
                child: AppText(
                    maxLines: 2,
                    align: TextAlign.center,
                    text: "خطأ في رقم الهوية",
                    color: Colors.black,
                    fontWeight: FontWeight.w700)),
            SizedBox(height: SizeConfigManger.bodyHeight * .1),
          ],
        ),
      ),
    )..show();
  }
}

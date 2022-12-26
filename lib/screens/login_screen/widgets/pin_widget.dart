import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/screens/complete_profile/complete_profile.dart';
import 'package:kalbonyan/screens/login_screen/cubit/login_cubit.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/shared/helper/methods.dart';
import 'package:kalbonyan/widget/app_text.dart';
import 'package:kalbonyan/widget/custom_button.dart';
import 'package:kalbonyan/widget/custom_timer.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinWidget extends StatelessWidget {
  var code = TextEditingController();
  String phone;


  PinWidget(this.phone);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if(state is SuccessVerfingState){
          navigateToAndFinish(context, CompleteProfile());
        }
      },
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              SizedBox(
                height: SizeConfigManger.bodyHeight * .1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                        color: ColorsManger.darkPrimary,
                      )),
                  AppText(
                      text: phone,
                      fontWeight: FontWeight.w500,
                      textSize: 22),
                ],
              ),
              SizedBox(
                height: SizeConfigManger.bodyHeight * .05,
              ),
              AppText(
                text: 'أدخل رمز التفعيل المرسل إلى رقم الهاتف',
                color: ColorsManger.black,
                textSize: 18,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(
                height: SizeConfigManger.bodyHeight * .05,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfigManger.bodyHeight * .03),
                child: PinCodeTextField(
                  controller: code,
                  appContext: context,
                  autoFocus: true,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.number,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.scale,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    borderWidth: 1,
                    activeColor: ColorsManger.darkPrimary,
                    inactiveColor: ColorsManger.darkPrimary,
                    inactiveFillColor: Colors.white,
                    activeFillColor: Colors.white,
                    selectedColor: ColorsManger.darkPrimary,
                    selectedFillColor: Colors.white,
                  ),
                  animationDuration: Duration(milliseconds: 300),
                  backgroundColor: Colors.white,
                  enableActiveFill: true,
                  onChanged: (String value) {},
                ),
              ),
              SizedBox(
                height: SizeConfigManger.bodyHeight * .08,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfigManger.bodyHeight * .03),
                child: CustomButton(
                    text: "تفعيل", press: () {
                  if (code.text.isNotEmpty) {
                    LoginCubit.get(context).submitOTP(code.text);
                  }
                }, weight: FontWeight.w800),
              ),
              SizedBox(
                height: SizeConfigManger.bodyHeight * .02,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfigManger.bodyHeight * .03),
                child: Row(
                  children: [
                    AppText(
                        text: "يصل الرمز خلال",
                        textSize: 16,
                        color: ColorsManger.darkPrimary,
                        textDecoration: TextDecoration.underline),
                    SizedBox(width: 2),
                    CustomTimer(),
                    Spacer(),
                    AppText(
                        text: "إعادة إرسال الرمز",
                        textSize: 16,
                        color: ColorsManger.darkPrimary),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

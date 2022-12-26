import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kalbonyan/screens/login_screen/cubit/login_cubit.dart';
import 'package:kalbonyan/screens/login_screen/widgets/phone_widget.dart';
import 'package:kalbonyan/screens/login_screen/widgets/pin_widget.dart';
import 'package:kalbonyan/widget/app_text.dart';

class LoginScreen extends StatelessWidget {

  String phone;


  LoginScreen(this.phone);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {

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
          body: PageView(
            controller: LoginCubit.get(context).pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              PhoneWidget(phone: phone),
              PinWidget(phone),
            ],
          ),
        );
      },
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kalbonyan/main_admin_layout/main_admin_layout.dart';
import 'package:kalbonyan/main_layout/main_layout.dart';
import 'package:kalbonyan/models/user_model.dart';
import 'package:kalbonyan/screens/check_screen/check_screen.dart';
import 'package:kalbonyan/screens/complete_profile/complete_profile.dart';
import 'package:kalbonyan/screens/login_screen/login_screen.dart';
import 'package:kalbonyan/shared/helper/mangers/assets_manger.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:kalbonyan/shared/helper/mangers/size_config.dart';
import 'package:kalbonyan/shared/helper/methods.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  PageController? controller;

  @override
  void initState() {
    controller = PageController(initialPage: 0);
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfigManger().init(context);
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetsManger.splash1),
              ),
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetsManger.splash2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void init() async {
    Future.delayed(
      const Duration(seconds: 3),
          () {
        controller!.animateToPage(
          1,
          duration: Duration(microseconds: 300),
          curve: Curves.easeIn,
        );
        Future.delayed(const Duration(seconds: 3), () async {
          bool result = await InternetConnectionChecker().hasConnection;
          if (result) {
            FirebaseAuth.instance.authStateChanges().listen((user) {
              if (user == null) {
                if (mounted) {
                  navigateToAndFinish(context, CheckScreen());
                }
              } else {
                FirebaseFirestore.instance
                    .collection(ConstantsManger.USERS)
                    .doc(user.uid)
                    .get()
                    .then((value) {
                  UserModel userModel = UserModel.fromJson(value.data() ?? {});
                  print(user.uid);
                  if (userModel.isAdmin == true) {
                    if (mounted) {
                      navigateToAndFinish(context, MainAdminLayout());
                    }
                  } else {
                    if (mounted) {
                      navigateToAndFinish(context, MainLayout());
                    }
                  }
                });
              }
            });
          } else {
            showSnackBar(context, "من فضلك تحقق من إتصال الإنترنت");
          }
        });
      },
    );
  }
}

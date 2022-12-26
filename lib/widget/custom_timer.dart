import 'package:flutter/material.dart';
import 'package:kalbonyan/shared/helper/mangers/colors.dart';
import 'package:kalbonyan/widget/app_text.dart';

class CustomTimer extends StatelessWidget {
  const CustomTimer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Duration>(
        duration: Duration(seconds: 60),
        tween: Tween(begin: Duration(seconds: 60), end: Duration.zero),
        onEnd: () {

        },
        builder: (BuildContext context, Duration value, Widget? child) {
          final minutes = value.inMinutes;
          final seconds = value.inSeconds % 60;
          return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: AppText(text: "$minutes:$seconds",textSize: 16,color: ColorsManger.darkPrimary,)
          );
        });
  }
}

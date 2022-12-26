import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widget/app_text.dart';
import 'mangers/colors.dart';
import 'mangers/size_config.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateToAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (Route<dynamic> route) => false,
    );

void showSnackBar(BuildContext context, String errorMsg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(errorMsg),
    backgroundColor: Colors.black,
    duration: Duration(seconds: 5),
  ));
}

void showCustomProgressIndicator(BuildContext context) {
  AlertDialog alertDialog = AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(ColorsManger.darkPrimary),
      ),
    ),
  );

  showDialog(
    barrierColor: Colors.white.withOpacity(0),
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return alertDialog;
    },
  );
}

void showToast({required String msg, Color? color, ToastGravity? gravity}) {
  Fluttertoast.showToast(
      toastLength: Toast.LENGTH_LONG,
      msg: msg,
      backgroundColor: color ?? ColorsManger.darkPrimary,
      gravity: gravity ?? ToastGravity.BOTTOM);
}

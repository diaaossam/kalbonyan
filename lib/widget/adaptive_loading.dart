import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

import '../shared/helper/mangers/colors.dart';

class CustomLoading extends StatelessWidget {
  Color? color;

  CustomLoading({this.color});

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Center(child: CircularProgressIndicator(color: color ??ColorsManger.darkPrimary,))
        : Center(child: CupertinoActivityIndicator());
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import 'package:kalbonyan/shared/helper/mangers/constants.dart';
import '../../shared/helper/mangers/size_config.dart';
import '../shared/helper/mangers/colors.dart';

class CustomTextFormField extends StatelessWidget {
  bool isPassword;
  TextInputType? type;
  dynamic validate;
  dynamic onTap;
  dynamic onChange;
  dynamic onSuffixPressed;
  var controller;
  IconData? suffixIcon;
  String? hintText;
  String? prefix;
  Color? prefixIconColor;
  bool? isEnable;
  int? maxLines;
  double hintSize;
  TextAlign? textAlign;
  double? textSize;

  CustomTextFormField(
      {this.isPassword = false,
      this.type = TextInputType.text,
      this.validate,
      this.onChange,
      this.textSize,
      this.textAlign,
      this.onTap,
      this.hintSize = 22,
      this.maxLines = 1,
      this.suffixIcon,
      this.onSuffixPressed,
      this.controller,
      this.isEnable = true,
      this.prefixIconColor,
      this.hintText,
      this.prefix});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textAlign: textAlign ?? TextAlign.start,
      style: TextStyle(
        color: Colors.black,
        fontSize: textSize ?? getProportionateScreenHeight(25),
        fontFamily: ConstantsManger.appFont,
      ),
      controller: controller,
      obscureText: isPassword == true ? true : false,
      keyboardType: type,
      enabled: isEnable,
      maxLines: maxLines,
      validator: validate,
      textAlignVertical: TextAlignVertical.center,
      onChanged: onChange,
      onTap: onTap,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          disabledBorder:const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ) ,
          hintText: hintText,
          labelStyle: TextStyle(
            color: Colors.grey,
            fontSize: getProportionateScreenHeight(hintSize),
            fontFamily: ConstantsManger.appFont,
          ),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: getProportionateScreenHeight(hintSize),
            fontFamily: ConstantsManger.appFont,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixIcon: IconButton(
            icon: Icon(
              suffixIcon,
              color: ColorsManger.darkPrimary,
            ),
            onPressed: onSuffixPressed,
          ),
          prefixIcon: prefix == null ? null :Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Image(
              image: AssetImage(
                prefix!,
              ),
              height: getProportionateScreenHeight(20),
              width: getProportionateScreenHeight(20),
            ),
          ),
      ),
    );
  }
}

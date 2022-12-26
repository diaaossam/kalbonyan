import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../helper/mangers/colors.dart';

class ThemeManger {
  static ThemeData setLightTheme() {
    return ThemeData(
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: ColorsManger.darkPrimary,
        unselectedItemColor: Colors.grey,
      ),
      primaryColor: ColorsManger.darkPrimary,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: ColorsManger.appBarColor,
        elevation: 5,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 25
        ),
        iconTheme: IconThemeData(color: ColorsManger.darkPrimary),
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: ColorsManger.darkPrimary,
          primary: ColorsManger.darkPrimary),
    );
  }
}

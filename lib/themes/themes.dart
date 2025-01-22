import 'package:flutter/material.dart';
import 'package:groupe03_application/themes/app_color.dart';

class Themes {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColor.appBarColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColor.appBarColor,
      iconTheme: IconThemeData(color: AppColor.textColor),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: AppColor.textColor), // AppBar title style
      bodyLarge: TextStyle(color: AppColor.textColor), // Main large body text
      bodyMedium: TextStyle(color: AppColor.textColor), // Medium body text
      bodySmall: TextStyle(color: AppColor.textColor), // Small body text
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColor.buttonBackgroundColor,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColor.appBarColorDark,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColor.appBarColorDark,
      iconTheme: IconThemeData(color: AppColor.textColorDark),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: AppColor.textColorDark),
      bodyLarge: TextStyle(color: AppColor.textColorDark),
      bodyMedium: TextStyle(color: AppColor.textColorDark),
      bodySmall: TextStyle(color: AppColor.textColorDark),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: AppColor.buttonBackgroundColorDark,
    ),
  );
}

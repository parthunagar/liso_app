import 'package:flutter/material.dart';
import 'package:sharish/utils/colors_util.dart';

class AppStyle {
  static ThemeData theme = ThemeData(
    // brightness: Brightness.light,
    fontFamily: 'Lato',

    primaryColor: AppColor.primaryColor,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColor.primaryColor,
      secondary: AppColor.green,
      secondaryContainer: AppColor.accentColor,
      error: Colors.white,
      surface: Colors.white,
      background: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
    ),
    appBarTheme: ThemeData.light().appBarTheme.copyWith(
          backgroundColor: AppColor.primaryColor,
          elevation: 0,
          centerTitle: false,
        ),
  );
}

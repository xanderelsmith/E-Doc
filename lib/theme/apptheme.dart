import 'package:flutter/material.dart';
import 'package:healthai/theme/appcolors.dart';

class AppTheme {
  static ThemeData lighttheme = ThemeData.light().copyWith(
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.primaryColor)));
  static ThemeData darktheme = ThemeData.dark();
}

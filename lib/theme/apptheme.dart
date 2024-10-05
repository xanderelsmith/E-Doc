import 'package:flutter/material.dart';
import 'package:healthai/theme/appcolors.dart';

class AppTheme {
  static ThemeData lighttheme = ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColorblue,
        surface: AppColors.primaryColorblue,
        onPrimaryContainer: AppColors.primaryColorblue,
      ),
      tabBarTheme: TabBarTheme(labelColor: AppColors.textButtonColor),
      textButtonTheme: TextButtonThemeData(
          style:
              TextButton.styleFrom(foregroundColor: AppColors.textButtonColor)),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.primaryColorblue)));
  static ThemeData darktheme = ThemeData.dark().copyWith();
}

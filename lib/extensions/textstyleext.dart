import 'package:flutter/material.dart';
import 'package:healthai/theme/appcolors.dart';

extension AppTextStyleExtensions on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  TextStyle get white => copyWith(color: Colors.white);
  TextStyle get blue => copyWith(color: AppColors.textButtonColor);
  TextStyle get green => copyWith(color: AppColors.green);
  TextStyle get grey => copyWith(color: AppColors.emailgrey);
  TextStyle get purple => copyWith(color: AppColors.deepPurple);
}

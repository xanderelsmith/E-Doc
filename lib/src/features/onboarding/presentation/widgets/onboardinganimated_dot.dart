import 'package:flutter/material.dart';
import 'package:healthai/theme/appcolors.dart';

AnimatedContainer onBoardingDot(
    {int? index,
    changedValue,
    double? setpositionwidth,
    required Duration kAnimationDotDuration}) {
  return AnimatedContainer(
    margin: const EdgeInsets.all(7),
    duration: kAnimationDotDuration,
    height: 10,
    width: index == changedValue ? setpositionwidth : 10,
    decoration: BoxDecoration(
      color: index == changedValue ? AppColors.primaryColor : AppColors.grey,
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/styles/apptextstyles.dart';
import 'package:healthai/theme/appcolors.dart';

class LogoText extends StatelessWidget {
  const LogoText({
    this.fontSize = 21,
    super.key,
  });
  final double? fontSize;
  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'e-',
            style: Apptextstyles.mediumtextStyle21.copyWith(
                fontSize: fontSize, color: AppColors.primaryColorblue),
          ),
          TextSpan(
              text: 'Doc',
              style: Apptextstyles.mediumtextStyle21
                  .copyWith(
                    fontSize: fontSize,
                    color: const Color(0xff886cfe),
                  )
                  .bold),
        ],
      ),
    );
  }
}

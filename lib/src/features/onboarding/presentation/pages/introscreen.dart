import 'package:flutter/material.dart';
import 'package:healthai/commonwidgets/logotext.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/home/presentation/pages/homepage.dart';
import 'package:healthai/src/features/onboarding/presentation/pages/onboardingscreen.dart';

import '../../../../../constant/appstrings.dart';
import '../../../../../styles/apptextstyles.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getScreenSize(context).height,
      width: getScreenSize(context).width,
      child: Stack(
        children: [
          Image.asset(
            'images/base.png',
            width: getScreenSize(context).width,
            fit: BoxFit.cover,
          ),
          Align(
            alignment: const Alignment(0, 0.9),
            child: SizedBox(
              height: getScreenSize(context).height / 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const LogoText(
                    fontSize: 31,
                  ),
                  Text(
                    Appstrings.descriptioon,
                    textAlign: TextAlign.center,
                    style: Apptextstyles.mediumtextStyle21.white,
                  ),
                  Text(
                    Appstrings.subdescription,
                    textAlign: TextAlign.center,
                    style: Apptextstyles.smalltextStyle13.white,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

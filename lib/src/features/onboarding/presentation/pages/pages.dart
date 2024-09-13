import 'package:flutter/material.dart';
import 'package:healthai/constant/appstrings.dart';
import 'package:healthai/theme/appcolors.dart';

import '../../../../../styles/apptextstyles.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
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
                    Text(
                      Appstrings.appName,
                      textAlign: TextAlign.center,
                      style: Apptextstyles.mediumBoldtextStyle.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      Appstrings.descriptioon,
                      textAlign: TextAlign.center,
                      style: Apptextstyles.mediumBoldtextStyle,
                    ),
                    Text(
                      Appstrings.subdescription,
                      textAlign: TextAlign.center,
                      style: Apptextstyles.smalltextStyle,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Size getScreenSize(context) => MediaQuery.of(context).size;

import 'package:flutter/material.dart';
import 'package:healthai/src/features/onboarding/presentation/pages/introscreen.dart';

import '../../domain/entities/onboardingdataview.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: PageView(children: const [
            IntroScreen(),
            OnBoardingInfoPages(),
          ]),
        )
      ]),
    );
  }
}

Size getScreenSize(context) => MediaQuery.of(context).size;

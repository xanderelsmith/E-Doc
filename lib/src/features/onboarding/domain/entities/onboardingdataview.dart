import 'package:flutter/material.dart';
import 'package:healthai/src/features/onboarding/data/models/onboarding.dart';
import 'package:healthai/src/features/onboarding/presentation/pages/onboardingscreen.dart';
import 'package:healthai/styles/apptextstyles.dart';

import '../../presentation/widgets/onboardinganimated_dot.dart';

class OnBoardingInfoPages extends StatefulWidget {
  const OnBoardingInfoPages({
    super.key,
  });

  @override
  State<OnBoardingInfoPages> createState() => _OnBoardingInfoPagesState();
}

class _OnBoardingInfoPagesState extends State<OnBoardingInfoPages> {
  int changedValue = 0;
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) => SizedBox(
          height: getScreenSize(context).height / 2.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                onboardinglist[changedValue].title,
                style: Apptextstyles.mediumBoldtextStyle
                    .copyWith(color: Colors.black),
              ),
              Text(onboardinglist[changedValue].message),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  onboardinglist.length,
                  (index) => onBoardingDot(
                      changedValue: changedValue,
                      index: index,
                      setpositionwidth: 10,
                      kAnimationDotDuration: const Duration(milliseconds: 500)),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeIn,
                    );
                  },
                  child: const Text('Next')),
              SizedBox(
                  height: 50,
                  child: (changedValue != onboardinglist.length - 1)
                      ? TextButton(onPressed: () {}, child: const Text('Skip'))
                      : null)
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                controller: pageController,
                onPageChanged: (value) {
                  setState(() {
                    changedValue = value;
                  });
                },
                itemCount: onboardinglist.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    onboardinglist[index].imagesrc,
                    alignment: Alignment.topCenter,
                  );
                }),
          ),
        ],
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/commonwidgets/expandedbuttons.dart';
import 'package:healthai/commonwidgets/logotext.dart';
import 'package:healthai/commonwidgets/specialtextfield.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/route/routes.dart';
import 'package:healthai/src/features/onboarding/presentation/pages/onboardingscreen.dart';
import 'package:healthai/styles/apptextstyles.dart';
import 'package:healthai/theme/appcolors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 100,
        width: getScreenSize(context).width - 50,
        child: Column(
          children: [
            Center(
                child:
                    ExpandedStyledButton(onTap: () {}, title: 'Save details')),
            TextButton(
                onPressed: () {
                  log(context.namedLocation(OnboardingPage.id));
                  context.pushReplacementNamed(OnboardingPage.id);
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.red),
                child: const Text('Log Out'))
          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Color(0xFF757575)),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: getScreenSize(context).width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    alignment: Alignment.center,
                    height: 143,
                    decoration: BoxDecoration(
                        color: AppColors.lightgrey,
                        borderRadius: BorderRadius.circular(
                          10,
                        )),
                    child: Text(
                      'Upload Photo',
                      style: Apptextstyles.normaltextStyle15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Bio Data',
                    style: Apptextstyles.smalltextStyle14
                        .copyWith(color: AppColors.textButtonColor)
                        .bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    textfieldname: 'First Name',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    textfieldname: 'First Name',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    textfieldname: 'First Name',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    textfieldname: 'First Name',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    textfieldname: 'First Name',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    'Medical Records',
                    style: Apptextstyles.smalltextStyle14
                        .copyWith(color: AppColors.textButtonColor)
                        .bold,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    textfieldname: 'First Name',
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    textfieldname: 'First Name',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

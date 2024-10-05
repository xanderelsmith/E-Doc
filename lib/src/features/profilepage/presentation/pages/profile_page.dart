import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/src/features/authentication/data/models/user.dart';

import '../../../../../theme/appcolors.dart';
import '../../../onboarding/presentation/pages/onboardingscreen.dart';
import '../widgets/patient/patientprofile_body.dart';
import '../widgets/patient/specialistprofilebody.dart';

class ProfilePage extends StatelessWidget {
  static String id = 'ProfilePage';
  const ProfilePage({super.key, required this.baseUser});
  final CustomUserData baseUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: TextButton(
          onPressed: () {
            context.goNamed(OnboardingPage.id);
          },
          style: TextButton.styleFrom(
            foregroundColor: AppColors.red,
          ),
          child: const Text('Log Out')),
      appBar: AppBar(
        bottom: const PreferredSize(
          preferredSize: Size(double.maxFinite, 1),
          child: Divider(),
        ),
        title: const Text('My Profile'),
        centerTitle: true,
      ),
      body: baseUser.isSpecialist
          ? const SpecialistProfileBody()
          : const PatientProfileBody(),
    );
  }
}

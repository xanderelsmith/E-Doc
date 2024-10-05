import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/commonwidgets/logotext.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/onboarding/presentation/pages/onboardingscreen.dart';
import 'package:healthai/styles/apptextstyles.dart';

import '../../../../../theme/appcolors.dart';
import '../../../appointmentbooking/presentation/widgets/iconoptionwidget.dart';
import '../../../profilepage/presentation/pages/profile_page.dart';

class PatientOptionBottomSheet extends StatelessWidget {
  const PatientOptionBottomSheet({
    super.key,
    required this.patient,
  });
  final Patient patient;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.close)),
          ),
          GestureDetector(
            onTap: () {
              context.pushNamed(ProfilePage.id, extra: patient);
            },
            child: Card(
              margin: const EdgeInsets.only(left: 8, top: 8),
              color: AppColors.casualPink,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: AppColors.white)),
              child: SizedBox(
                width: getScreenSize(context).width,
                height: 48,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatar(
                        backgroundColor: AppColors.white,
                        radius: 18,
                        child: CachedNetworkImage(
                          imageUrl: patient.profileImageUrl,
                          imageBuilder: (context, imageProvider) => ClipOval(
                              child: Image(
                            image: imageProvider,
                            fit: BoxFit.cover,
                            height: 32,
                          )),
                          errorWidget: (context, url, error) =>
                              const SizedBox(),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Text(
                      'My Profile',
                      style: Apptextstyles.normaltextStyle17.w500,
                    ))
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          const Iconoptionwidget(
            text: 'Appointment History',
            icon: Icon(Icons.calendar_today_outlined),
          ),
          const Iconoptionwidget(
            text: 'Messages',
            icon: Icon(Icons.messenger_outline_outlined),
          ),
          const Iconoptionwidget(
            text: 'Setting',
            icon: Icon(Icons.settings_outlined),
          ),
          const Divider(),
          const Iconoptionwidget(
            text: 'Support',
            icon: Icon(Icons.contact_support_outlined),
          ),
          Iconoptionwidget(
            onPressed: () {
              context.goNamed(OnboardingPage.id);
            },
            text: 'Log -out',
            icon: const Icon(Icons.logout_outlined),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:healthai/extensions/datetimeexts.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/onboarding/presentation/pages/onboardingscreen.dart';

import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';

class DoctorBioCard extends StatelessWidget {
  const DoctorBioCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: getScreenSize(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.listTileColor.withOpacity(0.1),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: Column(
        children: [
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: EdgeInsets.only(
                  right: 5,
                ),
                color: Colors.red,
                elevation: 0,
                child: SizedBox(
                  height: 47,
                  width: 47,
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dr. Phillipa Grey '),
                      Text('Cardiologist'),
                    ],
                  ),
                ),
              ),
              Icon(Icons.more_horiz)
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 15,
                      ),
                      Text(
                        DateTime(2024, 9, 23).toTomorrowFormat(),
                        style: Apptextstyles.smalltextStyle10,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.alarm,
                        size: 15,
                      ),
                      Text(
                        '4:30pm',
                        style: Apptextstyles.smalltextStyle10,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.alarm,
                        size: 15,
                      ),
                      Card(
                        elevation: 0,
                        color: AppColors.black,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 3,
                          ),
                          child: Text(
                            'Pending',
                            style: Apptextstyles.smalltextStyle10.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

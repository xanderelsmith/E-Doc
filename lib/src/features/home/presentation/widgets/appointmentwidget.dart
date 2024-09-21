import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:healthai/extensions/datetimeexts.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/home/presentation/pages/appointmentsdetailsscreen.dart';
import 'package:healthai/src/features/onboarding/presentation/pages/onboardingscreen.dart';

import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';
import '../../../appointmentbooking/presentation/pages/bookingsubmissionscreen.dart';

class AppointmentWidget extends StatelessWidget {
  const AppointmentWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AppointmentDetailsScreen(),
            ));
      },
      child: Container(
        width: 335,
        height: 115,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.listTileColor.withOpacity(0.1),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Card(
              margin: EdgeInsets.only(
                right: 5,
              ),
              color: Colors.red,
              elevation: 0,
              child: SizedBox(
                height: 87,
                width: 87,
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 87,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Dr. Phillipa Grey '),
                          Text('Cardiologist'),
                        ],
                      ),
                    ),
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
                    )
                  ],
                ),
              ),
            ),
            const Icon(Icons.more_horiz)
          ],
        ),
      ),
    );
  }
}

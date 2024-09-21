import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/appointmentbooking/presentation/pages/bookingsubmissionscreen.dart';

import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';
import '../../../onboarding/presentation/pages/onboardingscreen.dart';
import '../widgets/appointmentwidget.dart';
import '../widgets/doctorbiocard.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(
              style: OutlinedButton.styleFrom(
                fixedSize: Size(getScreenSize(context).width / 2.2, 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel booking')),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(getScreenSize(context).width / 2.2, 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BookingSubmissionScreen()));
              },
              child: const Text('Make payment'))
        ],
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Booking',
          style: Apptextstyles.smalltextStyle14.w500,
        ),
      ),
      body: Column(
        children: [
          const DoctorBioCard(),
          Card(
            elevation: 0,
            color: AppColors.casualPink,
            child: SizedBox(
              height: 72,
              width: getScreenSize(context).width - 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'You need to make payment within 24hours to confirm\n your appointment. you can select another available date\n from the calendar before you make payment.',
                  style: Apptextstyles.smalltextStyle12,
                ),
              ),
            ),
          ),
          Expanded(
              child: Card(
            color: AppColors.white,
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                        calendarType: CalendarDatePicker2Type.range,
                        selectedDayHighlightColor: AppColors.primaryColorblue),
                    onDisplayedMonthChanged: (value) {},
                    value: [
                      DateTime.now().copyWith(day: 18),
                      DateTime.now().copyWith(day: 19),
                      DateTime.now().copyWith(day: 20)
                    ],
                    displayedMonthDate: DateTime.now().copyWith(day: 20),
                    onValueChanged: (dates) {
                      // _dates = dates;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 28.0,
                    bottom: 10,
                  ),
                  child: Text('Time'),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}

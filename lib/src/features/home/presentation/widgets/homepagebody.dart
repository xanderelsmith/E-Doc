import 'package:flutter/material.dart';
import 'package:healthai/extensions/datetimeexts.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/home/presentation/widgets/appointmentwidget.dart';

import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';
import '../../../appointmentbooking/presentation/pages/pages.dart';

class HomePageBody extends StatelessWidget {
  const HomePageBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How do you feel today',
                style: Apptextstyles.mediumtextStyle21.bold,
              ),
              const Text('Easily book an appointment with a simple click'),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BookAppointmentScreen(),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(double.maxFinite, 12)),
                  child: const Text('Book Appointment'),
                ),
              )
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 8.0),
          child: Divider(),
        ),
        Text(
          'Upcoming Appointment',
          style: Apptextstyles.smalltextStyle13
              .copyWith(fontWeight: FontWeight.bold)
              .blue,
        ),
        Expanded(
            flex: 4,
            child: ListView.builder(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                addAutomaticKeepAlives: true,
                itemCount: 5,
                itemBuilder: (context, index) => AppointmentWidget())),
        Text(
          'Recent Appointment',
          style: Apptextstyles.smalltextStyle13
              .copyWith(fontWeight: FontWeight.bold)
              .blue,
        ),
        Expanded(
            flex: 1,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) => Card(
                elevation: 0,
                margin: const EdgeInsets.only(
                  right: 10,
                ),
                color: AppColors.grey.withOpacity(0.2),
                child: SizedBox(
                  height: 65,
                  width: 191,
                  child: Row(
                    children: [
                      const Card(
                        elevation: 0,
                        color: Colors.red,
                        child: SizedBox(
                          height: 50,
                          width: 50,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dr. Lilly blue ',
                              style: Apptextstyles.normaltextStyle16.w400,
                            ),
                            Text(
                              'Gynaecologist',
                              style: Apptextstyles.smalltextStyle12,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ))
      ]),
    );
  }
}

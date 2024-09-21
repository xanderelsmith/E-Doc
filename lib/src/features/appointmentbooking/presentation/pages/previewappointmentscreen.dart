import 'package:flutter/material.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/appointmentbooking/presentation/pages/bookingsubmissionscreen.dart';
import 'package:healthai/styles/apptextstyles.dart';
import 'package:healthai/theme/appcolors.dart';

import '../../../../../commonwidgets/expandedbuttons.dart';

class PreviewAppointmentReport extends StatelessWidget {
  const PreviewAppointmentReport({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                    ),
                    child: Text(
                      'Recommendation',
                      style: Apptextstyles.normaltextStyle15.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    margin: const EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.grey,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Pulmonologist'),
                        Text(
                          'Change',
                          style: Apptextstyles.smalltextStyle12
                              .copyWith(fontWeight: FontWeight.bold)
                              .blue,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
              ),
              child: ExpandedStyledButton(
                  onTap: () {
                    showDialog(
                      barrierColor: AppColors.barriercolor.withOpacity(0.9),
                      context: context,
                      builder: (context) => AlertDialog(
                        contentPadding: const EdgeInsets.all(15),
                        alignment: const Alignment(0, -0.5),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        actionsAlignment: MainAxisAlignment.center,
                        actionsOverflowAlignment: OverflowBarAlignment.center,
                        actionsOverflowDirection: VerticalDirection.up,
                        actions: [
                          OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Close')),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const BookingSubmissionScreen()));
                              },
                              child: const Text('Preview'))
                        ],
                        title: Text(
                          'Submission Successful',
                          style: Apptextstyles.normaltextStyle17.green,
                          textAlign: TextAlign.center,
                        ),
                        content: Text(
                          'You will be notified to confirm your booking with the next available doctor.',
                          style: Apptextstyles.smalltextStyle14,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                  title: 'Proceed'),
            )
          ],
        ),
      ),
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

String data = '''
Dear Jay,

Thank you for using our AI-powered health consultation platform. Based on the information you provided, it seems that you may be experiencing persistent cough, shortness of breath, and chest tightness. Your reported allergies to dust mites and pollen and current temperature of 99.6°F also suggest that asthma or allergic bronchitis could be contributing factors.

We recommend consulting with a pulmonologist for further evaluation and diagnosis. They will be able to conduct a more comprehensive examination and prescribe appropriate treatment.''';

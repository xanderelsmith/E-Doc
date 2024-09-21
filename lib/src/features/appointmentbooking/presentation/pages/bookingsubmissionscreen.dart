import 'package:flutter/material.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/styles/apptextstyles.dart';

class BookingSubmissionScreen extends StatelessWidget {
  const BookingSubmissionScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Booking Submission',
          style: Apptextstyles.smalltextStyle14.w500,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name',
              style: Apptextstyles.smalltextStyle14,
            ),
            Text(
              'James Jay',
              style: Apptextstyles.smalltextStyle14,
            ),
            Text(
              'Temperature',
              style: Apptextstyles.smalltextStyle14,
            ),
            Text(
              '99.6°F',
              style: Apptextstyles.smalltextStyle14,
            ),
            Text(
              'Symptoms',
              style: Apptextstyles.smalltextStyle14,
            ),
            Text(
              'Persistent cough',
              style: Apptextstyles.smalltextStyle14,
            ),
            Text(
              'Allergies',
              style: Apptextstyles.smalltextStyle14,
            ),
            Text(
              'Contributing Factors',
              style: Apptextstyles.smalltextStyle14,
            ),
            Text(
              'Recommendation',
              style: Apptextstyles.smalltextStyle14,
            ),
            const Expanded(child: SizedBox()),
            const Divider(),
            Text(
              'Booking Status',
              style: Apptextstyles.smalltextStyle14,
            ),
            Chip(
              label: Text('Pending'),
              backgroundColor: Color(0xffFFE1D0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Color(0xffFFE1D0)),
                  borderRadius: BorderRadius.circular(20)),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

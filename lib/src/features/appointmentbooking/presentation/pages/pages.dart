import 'package:flutter/material.dart';
import 'package:healthai/commonwidgets/expandedbuttons.dart';
import 'package:healthai/src/features/appointmentbooking/presentation/pages/previewappointmentscreen.dart';

import '../../../../../commonwidgets/specialtextfield.dart';

class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tell us how you are feeling'),
                  Text('Fill-in accurate details only'),
                  Text('Temperature (Leave blank if you are not sure)'),
                  SpecialTextfield(),
                  Text(' Symptoms (Explain in details how you feel)'),
                  SpecialTextfield(
                    maxlines: 5,
                    contentPadding: EdgeInsets.all(
                      5,
                    ),
                  ),
                  Text('Existing Allergies  (from your profile)')
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
              ),
              child: ExpandedStyledButton(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const PreviewAppointmentReport(),
                        ));
                  },
                  title: 'Proceed'),
            )
          ],
        ),
      ),
    );
  }
}

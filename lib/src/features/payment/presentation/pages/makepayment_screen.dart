import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/appointmentbooking/data/models/appointments.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/styles/apptextstyles.dart';
import 'package:healthai/theme/appcolors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../appointmentbooking/presentation/pages/patient_bookinginfoscreen.dart';
import '../../../onboarding/presentation/pages/onboardingscreen.dart';

class MakePaymentScreen extends ConsumerWidget {
  const MakePaymentScreen({super.key, required this.appointmentData});
  static String id = 'MakePaymentScreen';
  final Map appointmentData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var specialist = (appointmentData['specialist'] as Specialist);
    var appointment = (appointmentData['appointment'] as Appointment);
    return Scaffold(
      appBar: AppBar(
        bottom: const PreferredSize(
            preferredSize: Size(
              double.maxFinite,
              1,
            ),
            child: Divider()),
        title: const Text('Summary'),
        centerTitle: true,
      ),
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
                            backgroundColor: AppColors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            context.pop();
                          },
                          child: const Text('Cancel booking'))
                    ],
                    title: Text(
                      'Cancel Booking',
                      style: Apptextstyles.normaltextStyle17.bold,
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      'Are you sure you want to cancel this booking? it will take more time if you start over',
                      style: Apptextstyles.smalltextStyle14,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
              child: const Text('Cancel booking')),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(getScreenSize(context).width / 2.2, 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () async {
                var patient = ref.watch(userDetailsProvider)!;
                await createAppointment(appointment).then(
                  (value) {
                    if (context.mounted) {
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
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryColorblue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                ),
                                onPressed: () {
                                  context.pushNamed(BookingInfoScreen.id,
                                      extra: appointmentData);
                                },
                                child: const Text('Okay'))
                          ],
                          title: Text(
                            'Payment Successful',
                            style: Apptextstyles.normaltextStyle17.bold
                                .copyWith(color: AppColors.green),
                            textAlign: TextAlign.center,
                          ),
                          content: Text(
                            'Your booking is now confirmed, and you will be able to call or chat your doctor when the time reaches',
                            style: Apptextstyles.smalltextStyle14,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
              child: const Text('Pay Fee'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              minLeadingWidth: 0,
              contentPadding: EdgeInsets.zero,
              leading: CachedNetworkImage(
                imageUrl: specialist.profileImageUrl,
                imageBuilder: (context, imageProvider) => Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover)),
                ),
                errorWidget: (context, url, error) => Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    )),
                fit: BoxFit.cover,
                height: 50,
                width: 50,
              ),
              title: Text(appointmentData['specialist'].name),
              subtitle: Text(appointmentData['specialist'].specialty),
            ),
            const Divider(),
            Text(
              'Date',
              style: Apptextstyles.normaltextStyle17,
            ),
            Column(
                children: List.generate(
              appointment.dates.length,
              (index) => Padding(
                padding: const EdgeInsets.only(
                  right: 25.0,
                  bottom: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('MMMM dd yyyy')
                          .format(appointment.dates[index].toDate()),
                      style: Apptextstyles.mediumtextStyle20.bold,
                    ),
                  ],
                ),
              ),
            )),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      'Time',
                      style: Apptextstyles.normaltextStyle17,
                    ),
                  ),
                  Text(
                    DateFormat('hh:mm a')
                        .format(appointment.dates.first.toDate()),
                    style: Apptextstyles.mediumtextStyle20.bold,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text(
                      'Consultation Fee',
                      style: Apptextstyles.normaltextStyle17,
                    ),
                  ),
                  Text.rich(
                    TextSpan(text: 'Free\t\t', children: [
                      TextSpan(
                        text: 'N15000',
                        style: Apptextstyles.mediumtextStyle20.bold.copyWith(
                            textBaseline: TextBaseline.alphabetic,
                            color: AppColors.black,
                            decoration: TextDecoration.lineThrough),
                      )
                    ]),
                    style: Apptextstyles.mediumtextStyle24.bold,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> createAppointment(
  Appointment appointment,
) async {
  final appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments').doc();

  // Get the current date and time in UTC+1 timezone
  // DateTime.now().toUtc().add(Duration(hours: 1));

  final appointmentData = appointment.toMap();
  appointmentData['hasPaid'] = true;
  try {
    await appointmentsCollection.set(appointmentData);
    print('Appointment created successfully!');
  } catch (e) {
    print('Error creating appointment: $e');
  }
}

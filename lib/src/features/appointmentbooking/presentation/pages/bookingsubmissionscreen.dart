import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/home/presentation/widgets/specialistdataappointmentwidget.dart';
import 'package:healthai/styles/apptextstyles.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../commonwidgets/expandedbuttons.dart';
import '../../../home/presentation/pages/appointmentsdetailsscreen.dart';
import '../../../home/presentation/pages/setdatetimescreen.dart';
import '../../data/models/appointments.dart';

class BookingSubmissionScreen extends ConsumerWidget {
  const BookingSubmissionScreen({
    super.key,
    required this.data,
  });
  final Map data;
  static String id = 'BookingSubmissionScreen';
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<String> symptoms = data['symptoms'] ?? [];
    Specialist specialist = data['specialist'];
    var customUserData = ref.watch(userDetailsProvider)!;
    var temperature = data['temperature'];
    var allergies = data['allergies'];
    var complaint = data['complaint'];
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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name',
                    style: Apptextstyles.smalltextStyle14,
                  ),
                  Text(
                    customUserData.username,
                    style: Apptextstyles.normaltextStyle17.bold,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Temperature',
                      style: Apptextstyles.smalltextStyle14,
                    ),
                  ),
                  Text(
                    temperature.name,
                    style: Apptextstyles.normaltextStyle17.bold,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Symptoms',
                      style: Apptextstyles.smalltextStyle14,
                    ),
                  ),
                  Text(
                    symptoms.join(', '),
                    style: Apptextstyles.normaltextStyle17.bold,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Allergies',
                      style: Apptextstyles.smalltextStyle14,
                    ),
                  ),
                  Text(
                    allergies.join(', '),
                    style: Apptextstyles.normaltextStyle17.bold,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Brief Complaint',
                      style: Apptextstyles.smalltextStyle14,
                    ),
                  ),
                  Text(
                    complaint,
                    style: Apptextstyles.normaltextStyle17.bold,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Specialist',
                      style: Apptextstyles.smalltextStyle14,
                    ),
                  ),
                  ListTile(
                    minLeadingWidth: 0,
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 16,
                      child: CachedNetworkImage(
                        imageUrl: specialist.profileImageUrl,
                        imageBuilder: (context, imageProvider) => ClipOval(
                            child: Image(
                          image: imageProvider,
                          width: 32,
                          fit: BoxFit.cover,
                        )),
                        errorWidget: (context, url, error) => const SizedBox(),
                      ),
                    ),
                    title: Text(specialist.username),
                    subtitle: Text(specialist.specialty),
                  ),
                  const Expanded(child: SizedBox()),
                  const Divider(),
                  Text(
                    'Booking Status',
                    style: Apptextstyles.smalltextStyle14,
                  ),
                  Chip(
                    label: const Text('Pending'),
                    backgroundColor: const Color(0xffFFE1D0),
                    shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Color(0xffFFE1D0)),
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
              ),
              child: ExpandedStyledButton(
                  onTap: () {
                    DocumentReference patientreference = FirebaseFirestore
                        .instance
                        .doc('users/${customUserData.email}');
                    DocumentReference specialistReference = FirebaseFirestore
                        .instance
                        .doc('users/${specialist.email}');
                    var appointment = Appointment(
                        createdAt: Timestamp.fromDate(DateTime.now()),
                        id: '',
                        hasPaid: false,
                        temperature: data['temperature'].name,
                        isCalling: false,
                        allergies: allergies,
                        symptoms: symptoms,
                        token: '',
                        complaint: complaint,
                        dates: [Timestamp.fromDate(DateTime.now())],
                        nameOfAppointment: 'Medical Consultation',
                        patient: patientreference,
                        specialist: specialistReference);

                    // Create a document reference

                    context.pushNamed(SetDateTimeBookingScreen.id, extra: {
                      'appointment': appointment,
                      'me': customUserData,
                      'otherUser': specialist,
                    });
                  },
                  title: const Text('Select Dates/Time')),
            )
          ],
        ),
      ),
    );
  }
}

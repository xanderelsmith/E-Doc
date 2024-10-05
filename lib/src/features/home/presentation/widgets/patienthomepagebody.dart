import 'dart:async';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/fetchappointmentlist.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/home/presentation/widgets/specialistdataappointmentwidget.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';
import '../../../appointmentbooking/data/models/appointments.dart';
import '../../../appointmentbooking/presentation/pages/bookappointmentscreen.dart';
import '../../domain/repositories/specialist_repository.dart';

class PatientHomePageBody extends ConsumerStatefulWidget {
  const PatientHomePageBody(this.patient, {super.key});
  final Patient patient;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PatientHomePageBodyState();
}

class _PatientHomePageBodyState extends ConsumerState<PatientHomePageBody> {
  late StreamController streamController;

  @override
  void initState() {
    streamController = StreamController()
      ..addStream(getmyAppointmentList(widget.patient));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var patient = ref.watch(userDetailsProvider);
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
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
                    context.pushNamed(BookAppointmentScreen.id, extra: patient);
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
            child: (patient == null)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : StreamBuilder(
                    stream: streamController.stream,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child:
                                CircularProgressIndicator()); // Display a loading indicator when waiting for data.
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text('Error, Please restart App'),
                        ); // Display an error message if an error occurs.
                      } else if (!snapshot.hasData ||
                          snapshot.data == null ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text(
                          'You have No active Appointment',
                          style: Apptextstyles.normaltextStyle17,
                        ));
                      } else {
                        log(snapshot.data!.docs.length.toString());
                        return ListView.builder(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            addAutomaticKeepAlives: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) =>
                                AppointmentSpecialistDataWidget(
                                  appointment: Appointment.fromQuerySnapshot(
                                      ((snapshot.data!.docs)[index])),
                                ));
                      }
                    })),
        Text(
          'Specialists',
          style: Apptextstyles.smalltextStyle13
              .copyWith(fontWeight: FontWeight.bold)
              .blue,
        ),
        Expanded(
            flex: 1,
            child: StreamBuilder(
                stream: FetchSpecialistRepository().getSpecialists(),
                builder: (context, asyncSnapshot) {
                  if (!asyncSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: asyncSnapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var specialist = Specialist.fromMap(
                            asyncSnapshot.data!.docs[index].data());
                        return GestureDetector(
                          onTap: () {
                            context.pushNamed(SpecialDetailsPage.id);
                          },
                          child: Card(
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
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: CachedNetworkImage(
                                        imageUrl: specialist.profileImageUrl,
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover)),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.grey,
                                                )),
                                        fit: BoxFit.cover,
                                        width: 60,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          specialist.name,
                                          style: Apptextstyles
                                              .normaltextStyle16.w400,
                                        ),
                                        Text(
                                          specialist.specialty,
                                          style: Apptextstyles.smalltextStyle12,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                }))
      ]),
    );
  }
}

class SpecialDetailsPage extends StatelessWidget {
  const SpecialDetailsPage({super.key});
  static String id = 'SpecialDetailsPage';
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}

Stream<QuerySnapshot<Object?>> getmyPatientsBookedList(Specialist specialist) {
  try {
    // Get a reference to the Firestore collection where appointments are stored
    final CollectionReference appointmentsCollection =
        FirebaseFirestore.instance.collection('appointments');
    DocumentReference userRef =
        FirebaseFirestore.instance.collection('users').doc(specialist.email);
    // Query the collection based on the patient's email
    return appointmentsCollection
        .where('specialist', isEqualTo: userRef)
        .snapshots();
  } catch (e) {
    print('Error fetching appointments: $e');
    throw e; // Re-throw the error for further handling
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/extensions/datetimeexts.dart';
import 'package:healthai/route/routes.dart';
import 'package:healthai/src/features/appointmentbooking/presentation/pages/patient_bookinginfoscreen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';
import '../../../appointmentbooking/data/models/appointments.dart';
import '../../../appointmentbooking/domain/repositories/userrepository.dart';
import '../../../appointmentbooking/presentation/pages/specialist_viewbookinginfo.dart';
import '../../../authentication/data/models/patient.dart';
import '../../../authentication/data/models/user.dart';
import '../pages/appointmentsdetailsscreen.dart';

class AppointmentPatientDataWidget extends ConsumerWidget {
  const AppointmentPatientDataWidget({
    super.key,
    required this.appointment,
  });
  final Appointment appointment;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
        stream: appointment.patient.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                    CircularProgressIndicator()); // Display a loading indicator when waiting for data.
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error, Please restart App'),
            ); // Display an error message if an error occurs.
          } else {
            Patient specialist =
                Patient.fromMap(snapshot.data!.data() as Map<String, dynamic>);
            return GestureDetector(
              onTap: () {
                context.pushNamed(SpecialistViewbookinginfo.id, extra: {
                  'appointment': appointment,
                  'me': ref.watch(userDetailsProvider),
                  'patient': Patient.fromMap(
                      snapshot.data!.data() as Map<String, dynamic>),
                });
              },
              child: Container(
                width: 335,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.deepPurple.withOpacity(0.1),
                ),
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: CachedNetworkImage(
                        imageUrl: specialist.profileImageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover)),
                        ),
                        errorWidget: (context, url, error) => Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            )),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 4.0,
                        ),
                        child: SizedBox(
                          height: 87,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: Text(specialist.name.toString())),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    size: 15,
                                  ),
                                  Text(
                                    appointment.dates[0]
                                        .toDate()
                                        .toTomorrowFormat(),
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
                                    DateFormat('hh:mm a')
                                        .format(appointment.dates[0].toDate()),
                                    style: Apptextstyles.smalltextStyle10,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}

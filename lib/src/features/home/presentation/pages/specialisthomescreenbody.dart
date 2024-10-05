import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/home/presentation/widgets/patienthomepagebody.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';
import '../../../appointmentbooking/data/models/appointments.dart';
import '../../../appointmentbooking/domain/repositories/userrepository.dart';
import '../../../onboarding/presentation/pages/onboardingscreen.dart';
import '../../domain/repositories/specialist_repository.dart';
import '../widgets/patient_data_appointmentwidget.dart';

class SpecialistHomeBody extends ConsumerWidget {
  const SpecialistHomeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: getScreenSize(context).width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getScreenSize(context).width / 1.45,
                    child: Card(
                      child: CalendarDatePicker2(
                        config: CalendarDatePicker2Config(
                            calendarViewMode: CalendarDatePicker2Mode.day,
                            controlsHeight: 50,
                            calendarType: CalendarDatePicker2Type.multi),
                        value: const [],
                      ),
                    ),
                  ),
                  Text(
                    'Upcoming Appointment',
                    style: Apptextstyles.smalltextStyle13
                        .copyWith(fontWeight: FontWeight.bold)
                        .blue,
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: getmyPatientsBookedList(
                            ref.watch(userDetailsProvider) as Specialist),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
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
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'You have No active Appointment',
                                style: Apptextstyles.normaltextStyle17,
                              ),
                            ));
                          } else {
                            log(snapshot.data!.docs.length.toString());
                            return ListView.builder(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                addAutomaticKeepAlives: true,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) =>
                                    AppointmentPatientDataWidget(
                                      appointment:
                                          Appointment.fromQuerySnapshot(
                                              (snapshot.data!.docs[index])),
                                    ));
                          }
                        }),
                  )
                ],
              ),
            ),
            Text(
              'Specialists',
              style: Apptextstyles.smalltextStyle13
                  .copyWith(fontWeight: FontWeight.bold)
                  .blue,
            ),
            SizedBox(
              height: 70,
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
                                      padding:
                                          const EdgeInsets.only(right: 4.0),
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
                                                        BorderRadius.circular(
                                                            10),
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
                                            style:
                                                Apptextstyles.smalltextStyle12,
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
                  }),
            )
          ],
        ),
      ),
    );
  }
}

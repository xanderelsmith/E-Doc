import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/extensions/datetimeexts.dart';
import 'package:healthai/src/features/appointmentbooking/data/models/appointments.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/authentication/data/models/user.dart';
import 'package:healthai/src/features/home/presentation/pages/appointmentsdetailsscreen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';

class AppointmentSpecialistDataWidget extends ConsumerStatefulWidget {
  const AppointmentSpecialistDataWidget({required this.appointment, super.key});

  final Appointment appointment;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppointState();
}

class _AppointState extends ConsumerState<AppointmentSpecialistDataWidget> {
  late StreamController streamController;
  @override
  void initState() {
    streamController = StreamController()
      ..addStream(widget.appointment.specialist.snapshots());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
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
          } else {
            Specialist specialist =
                Specialist.fromMap(snapshot.data!.data() as Map);
            return SpecialistTile(
              specialist: specialist,
              appointment: widget.appointment,
              currentUser: ref.watch(userDetailsProvider) as CustomUserData,
            );
          }
        });
  }
}

class SpecialistTile extends StatelessWidget {
  const SpecialistTile(
      {super.key,
      required this.appointment,
      required this.currentUser,
      required this.specialist});
  final Appointment appointment;
  final CustomUserData currentUser;
  final Specialist specialist;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(AppointmentDetailsScreen.id, extra: {
          'appointment': appointment,
          'me': currentUser,
          'otherUser': specialist,
        });
      },
      child: Container(
        width: 335,
        height: 115,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.listTileColor.withOpacity(0.1),
        ),
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              margin: const EdgeInsets.only(
                right: 5,
              ),
              elevation: 0,
              child: SizedBox(
                height: 87,
                width: 87,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: specialist.profileImageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 87,
                        width: 87,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      ),
                      errorWidget: (context, url, error) => Container(
                          height: 87,
                          width: 87,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey,
                          )),
                      fit: BoxFit.cover,
                      height: 87,
                      width: 87,
                    ),
                    if (appointment.isCalling)
                      Align(
                        alignment: const Alignment(0.8, 0.8),
                        child: AvatarGlow(
                            glowColor: Colors.red,
                            glowRadiusFactor: 1.5,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue[900],
                              radius: 5,
                            )),
                      )
                  ],
                ),
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 87,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StreamBuilder(
                        stream: appointment.specialist.snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(); // Display a loading indicator when waiting for data.
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text('Error, Please restart App'),
                            ); // Display an error message if an error occurs.
                          } else {
                            Specialist specialist = Specialist.fromMap(
                                snapshot.data!.data() as Map);
                            return Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(specialist.name.toString()),
                                  Text(specialist.specialty),
                                ],
                              ),
                            );
                          }
                        }),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 15,
                        ),
                        Text(
                          appointment.dates[0].toDate().toTomorrowFormat(),
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
          ],
        ),
      ),
    );
  }
}

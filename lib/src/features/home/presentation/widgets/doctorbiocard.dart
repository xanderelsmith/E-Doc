import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthai/extensions/datetimeexts.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/appointmentbooking/data/models/appointments.dart';
import 'package:healthai/src/features/onboarding/presentation/pages/onboardingscreen.dart';
import 'package:intl/intl.dart';

import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';
import '../../../authentication/data/models/specialist.dart';

class DoctorBioCard extends StatefulWidget {
  const DoctorBioCard({
    super.key,
    required this.appointment,
  });
  final Appointment appointment;

  @override
  State<DoctorBioCard> createState() => _DoctorBioCardState();
}

class _DoctorBioCardState extends State<DoctorBioCard> {
  late StreamController streamController;
  @override
  void initState() {
    streamController = StreamController()
      ..addStream(widget.appointment.specialist.snapshots());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      width: getScreenSize(context).width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.listTileColor.withOpacity(0.1),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 10,
      ),
      child: StreamBuilder(
          stream: streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(); // Display a loading indicator when waiting for data.
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Error, Please restart App'),
              ); // Display an error message if an error occurs.
            } else {
              Specialist specialist =
                  Specialist.fromMap(snapshot.data!.data() as Map);
              return Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          margin: const EdgeInsets.only(
                            right: 5,
                          ),
                          elevation: 0,
                          child: SizedBox(
                            height: 47,
                            width: 47,
                            child: CachedNetworkImage(
                              imageUrl: specialist.profileImageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover)),
                              ),
                              errorWidget: (context, url, error) => Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey,
                                  )),
                              fit: BoxFit.cover,
                              width: 60,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(specialist.name.toString()),
                              Text(specialist.specialty),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ListView(
                                scrollDirection: Axis.horizontal,
                                children: List.generate(
                                  widget.appointment.dates.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(right: 25.0),
                                    child: DateTimePreviewIcon(
                                        date: widget.appointment.dates[index]),
                                  ),
                                )),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.alarm,
                                size: 15,
                              ),
                              Card(
                                elevation: 0,
                                color: AppColors.black,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 3,
                                  ),
                                  child: Text(
                                    widget.appointment.hasPaid
                                        ? 'Approved'
                                        : 'Pending',
                                    style: Apptextstyles.smalltextStyle10.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}

class DateTimePreviewIcon extends StatelessWidget {
  const DateTimePreviewIcon({
    super.key,
    required this.date,
  });

  final Timestamp date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.calendar_today_outlined,
          size: 15,
        ),
        Text(
          date.toDate().toTomorrowFormat(),
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
          DateFormat('hh:mm a').format(date.toDate()),
          style: Apptextstyles.smalltextStyle10,
        )
      ],
    );
  }
}

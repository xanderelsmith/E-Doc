import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/home/presentation/widgets/patient_data_appointmentwidget.dart';
import 'package:healthai/src/features/home/presentation/widgets/patienthomepagebody.dart';

import '../../../../../../../styles/apptextstyles.dart';
import '../../../../../appointmentbooking/data/models/appointments.dart';

class SpecialistCurrentAppointment extends StatefulWidget {
  const SpecialistCurrentAppointment({
    super.key,
    required this.specialist,
  });
  final Specialist? specialist;

  @override
  State<SpecialistCurrentAppointment> createState() =>
      _PatientCurrentAppointmentState();
}

class _PatientCurrentAppointmentState
    extends State<SpecialistCurrentAppointment> {
  late StreamController streamController;
  List<Appointment> appointments = [];
  @override
  void initState() {
    streamController = StreamController()
      ..addStream(getmyPatientsBookedList(widget.specialist!)
        ..listen((event) {
          log(event.toString());
          setState(() {
            appointments = event.docs
                .map((e) => Appointment.fromQuerySnapshot(e))
                .toList();
            log('sucess');
          });
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(appointments.length.toString());
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        top: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'All Appointments',
              style: Apptextstyles.smalltextStyle13
                  .copyWith(fontWeight: FontWeight.bold)
                  .blue,
            ),
          ),
          Expanded(
            child: (widget.specialist == null)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : appointments.isEmpty
                    ? Center(
                        child: Text(
                        'You have No active Appointment',
                        style: Apptextstyles.normaltextStyle17,
                      ))
                    : ListView.builder(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        addAutomaticKeepAlives: true,
                        itemCount: appointments.length,
                        itemBuilder: (context, index) =>
                            AppointmentPatientDataWidget(
                                appointment: appointments[index])),
          )
        ],
      ),
    );
  }
}

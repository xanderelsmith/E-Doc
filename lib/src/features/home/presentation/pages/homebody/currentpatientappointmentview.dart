import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthai/extensions/textstyleext.dart';

import '../../../../../../styles/apptextstyles.dart';
import '../../../../appointmentbooking/data/models/appointments.dart';
import '../../../../appointmentbooking/domain/repositories/fetchappointmentlist.dart';
import '../../../../authentication/data/models/patient.dart';
import '../../widgets/specialistdataappointmentwidget.dart';

class PatientCurrentAppointment extends StatefulWidget {
  const PatientCurrentAppointment({
    super.key,
    required this.patient,
  });
  final Patient? patient;

  @override
  State<PatientCurrentAppointment> createState() =>
      _PatientCurrentAppointmentState();
}

class _PatientCurrentAppointmentState extends State<PatientCurrentAppointment> {
  late StreamController streamController;
  List<Appointment> appointments = [];
  @override
  void initState() {
    streamController = StreamController()
      ..addStream(getmyAppointmentList(widget.patient as Patient)
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
          Text(
            'All Appointments',
            style: Apptextstyles.smalltextStyle13
                .copyWith(fontWeight: FontWeight.bold)
                .blue,
          ),
          Expanded(
            child: (widget.patient == null)
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
                            AppointmentSpecialistDataWidget(
                                appointment: appointments[index])),
          )
        ],
      ),
    );
  }
}

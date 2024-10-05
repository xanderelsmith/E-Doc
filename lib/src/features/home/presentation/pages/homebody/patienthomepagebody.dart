import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/authentication/data/models/user.dart';
import 'package:healthai/src/features/home/presentation/pages/homebody/currentpatientappointmentview.dart';

import '../../../../../../styles/apptextstyles.dart';
import '../../../../appointmentbooking/data/models/appointments.dart';
import '../../../../appointmentbooking/domain/repositories/fetchappointmentlist.dart';
import '../../../../authentication/data/models/patient.dart';
import '../../widgets/patienthomepagebody.dart';
import '../../widgets/specialistdataappointmentwidget.dart';

class GetPatientHomeScreenBody extends StatefulWidget {
  const GetPatientHomeScreenBody(
      {super.key, required this.index, required this.patient});
  final int index;
  final Patient patient;

  @override
  State<GetPatientHomeScreenBody> createState() =>
      _GetPatientHomeScreenBodyState();
}

class _GetPatientHomeScreenBodyState extends State<GetPatientHomeScreenBody> {
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.index,
      children: [
        PatientHomePageBody(widget.patient),
        PatientCurrentAppointment(
          patient: widget.patient,
        ),
        const SizedBox(),
      ],
    );
  }
}

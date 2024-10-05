// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:developer';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/appointmentbooking/data/models/appointments.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/callfeature/presentation/pages/callscreen.dart';

import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';
import '../../../onboarding/presentation/pages/onboardingscreen.dart';
import '../../../payment/presentation/pages/makepayment_screen.dart';
import '../widgets/doctorbiocard.dart';

class SetDateTimeBookingScreen extends StatefulWidget {
  static String id = 'SetDateTimeBookingScreen';
  const SetDateTimeBookingScreen({
    super.key,
    required this.appointmentData,
  });
  final Map appointmentData;

  @override
  State<SetDateTimeBookingScreen> createState() =>
      _SetDateTimeBookingScreenState();
}

class _SetDateTimeBookingScreenState extends State<SetDateTimeBookingScreen> {
  late Appointment appointment;
  List<DateTime> list = [];
  TimeOfDay timeOfDay = const TimeOfDay(hour: 9, minute: 41);
  String switchvalue = 'AM';

  late Specialist specialist;
  @override
  void initState() {
    appointment = widget.appointmentData['appointment'];
    specialist = widget.appointmentData['otherUser'];
    list = appointment.dates
        .map(
          (e) => e.toDate(),
        )
        .toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log(appointment.isCalling.toString());
    return Scaffold(
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
              onPressed: () {
                context.pushNamed(MakePaymentScreen.id, extra: {
                  'time': timeOfDay,
                  'appointment': appointment,
                  'specialist': widget.appointmentData['otherUser'],
                });
              },
              child: const Text('Make payment'))
        ],
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Booking',
          style: Apptextstyles.smalltextStyle14.w500,
        ),
      ),
      body: Column(
        children: [
          DoctorBioCard(
            appointment: appointment,
          ),
          if (!appointment.hasPaid)
            Card(
              elevation: 0,
              color: AppColors.casualPink,
              child: SizedBox(
                height: 72,
                width: getScreenSize(context).width - 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'You need to make payment within 24hours to confirm\n your appointment. you can select another available date\n from the calendar before you make payment.',
                    style: Apptextstyles.smalltextStyle12,
                  ),
                ),
              ),
            ),
          Expanded(
              child: Card(
            color: AppColors.white,
            margin: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CalendarDatePicker2(
                    config: CalendarDatePicker2Config(
                        calendarType: CalendarDatePicker2Type.multi,
                        animateToDisplayedMonthDate: true,
                        disableModePicker: true,
                        selectedDayHighlightColor: AppColors.primaryColorblue),
                    onDisplayedMonthChanged: (value) {},
                    value: list,
                    displayedMonthDate: widget
                        .appointmentData['appointment'].dates.first
                        .toDate(),
                    onValueChanged: (dates) {
                      list = dates;
                      setState(() {
                        appointment = appointment.copyWith(
                            dates: List.generate(
                                list.length,
                                (index) =>
                                    Timestamp.fromDate(list[index].copyWith(
                                      hour: timeOfDay.hour,
                                      minute: timeOfDay.minute,
                                    ))).toList());
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 28.0,
                    bottom: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Time',
                        style: Apptextstyles.normaltextStyle17.bold,
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              TimeOfDay? data = await showTimePicker(
                                  context: context, initialTime: timeOfDay);
                              if (data != null) {
                                setState(() {
                                  timeOfDay = data;
                                  switchvalue = data.period.name.toUpperCase();
                                });
                              }
                            },
                            child: Card(
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  timeOfDay.format(context),
                                  style: Apptextstyles.normaltextStyle17.bold,
                                ),
                              ),
                            ),
                          ),
                          AnimatedToggleSwitch<String>.size(
                            textDirection: TextDirection.rtl,
                            current: switchvalue,
                            animationDuration:
                                const Duration(milliseconds: 300),
                            values: const ['PM', 'AM'],
                            height: 40,
                            inactiveOpacity: 0.4,
                            indicatorSize: const Size.fromWidth(50),
                            borderWidth: 4.0,
                            iconAnimationType: AnimationType.onHover,
                            style: ToggleStyle(
                              backgroundColor: AppColors.bottomNavbtnCol,
                              indicatorColor: AppColors.white,
                              borderColor: AppColors.bottomNavbtnCol,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [],
                            ),
                            iconBuilder: (value) => Text(
                              value.toString(),
                              style: Apptextstyles.smalltextStyle14.bold,
                            ),
                            onChanged: (i) {
                              setState(() => switchvalue = i);
                              if (switchvalue == 'PM' && timeOfDay.hour < 12) {
                                timeOfDay = timeOfDay.replacing(
                                    hour: timeOfDay.hour + 12);
                              } else {
                                timeOfDay = timeOfDay.replacing(
                                    hour: timeOfDay.hour - 12);
                              }

                              log(switchvalue.toString());
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}

Future<void> setAppointmentToCalling(
    Appointment appointment, String token) async {
  DocumentReference appointmentRef =
      FirebaseFirestore.instance.collection('appointments').doc(appointment.id);
  log('sent token');
  await appointmentRef.update(appointment.toMap()
    ..['isCalling'] = true
    ..['token'] = token);
}

Future<void> endCall(Appointment appointment, String token) async {
  DocumentReference appointmentRef =
      FirebaseFirestore.instance.collection('appointments').doc(appointment.id);
  log('sent token ${appointment.id}');
  await appointmentRef.update(appointment.toMap()
    ..['isCalling'] = false
    ..['token'] = '');
}

Stream watchliveAppointmentUpdate(Appointment appointment) {
  var collection = FirebaseFirestore.instance.collection('appointments')
    ..orderBy('createdAt', descending: true);
  return collection.doc(appointment.id).snapshots();
}

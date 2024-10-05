import 'dart:async';
import 'dart:developer';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/appointmentbooking/data/models/appointments.dart';
import 'package:healthai/src/features/appointmentbooking/presentation/widgets/bulletpointwidget.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/home/presentation/pages/appointmentsdetailsscreen.dart';
import 'package:healthai/src/features/home/presentation/pages/homepage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/notificationservice.dart';
import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';
import '../../../callfeature/presentation/pages/callscreen.dart';
import '../../../onboarding/presentation/pages/onboardingscreen.dart';

class SpecialistViewbookinginfo extends ConsumerStatefulWidget {
  const SpecialistViewbookinginfo({super.key, required this.appointmentData});
  static String id = 'SpecialistViewbookinginfo';
  final Map appointmentData;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SpecialistViewbookinginfoState();
}

class _SpecialistViewbookinginfoState
    extends ConsumerState<SpecialistViewbookinginfo> {
  late Patient patient;
  late Appointment appointment;

  late StreamController streamController;
  bool iAmCaller = true;
  @override
  void initState() {
    appointment = widget.appointmentData['appointment'];
    patient = widget.appointmentData['patient'];

    streamController = StreamController()
      ..addStream(watchliveAppointmentUpdate(appointment)
        ..listen(
          (event) {
            setState(() {
              appointment = Appointment.fromQuerySnapshot(event);
            });

            if (appointment.isCalling && iAmCaller == false) {
              log('current $iAmCaller');
              LocalNotificationService().showNotification(RemoteMessage(
                messageId: '1',
                notification: RemoteNotification(
                    title: 'Incoming Call',
                    body: '${patient.name} is calling you '),
              ));
            }
          },
        ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DateTime date = appointment.dates.first.toDate();
    patient = widget.appointmentData['patient'];

    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
              statesController: WidgetStatesController(),
              icon: const Icon(Icons.chat_outlined),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(getScreenSize(context).width / 2.2, 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: null,
              label: const Text('Chat Patient')),
          ElevatedButton.icon(
              icon: appointment.isCalling
                  ? AvatarGlow(child: const Icon(Icons.call))
                  : const Icon(Icons.phone_outlined),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                fixedSize: Size(getScreenSize(context).width / 2.2, 30),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
              ),
              onPressed: () {
                if (appointment.token == '') {
                  setState(() {
                    iAmCaller = true;
                  });
                } else {
                  setState(() {
                    iAmCaller = false;
                  });
                }
                log(iAmCaller.toString());
                context.pushNamed(
                  CallScreen.id,
                  extra: {
                    'otherUser': patient,
                    'endCall': (token) {
                      log('done');
                      setState(() {
                        iAmCaller = false;
                      });
                      endCall(appointment, token);
                    },
                    'sendMessage': (token) {
                      setAppointmentToCalling(appointment, token);
                    },
                    'callId': appointment.token == '' ? null : appointment.token
                  },
                );
              },
              label: Text(appointment.isCalling ? 'Join Call' : 'Call Patient'))
        ],
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.goNamed(HomePage.id);
            },
            icon: const Icon(Icons.arrow_back)),
        bottom: const PreferredSize(
            preferredSize: Size(
              double.maxFinite,
              1,
            ),
            child: Divider()),
        title: const Text('Booking'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: getScreenSize(context).width,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  width: getScreenSize(context).width,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.deepPurple,
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Appointment',
                        style: Apptextstyles.normaltextStyle17.purple,
                      ),
                      Text(
                        '${date.hour}hr : ${date.minute}min : ${date.second}sec',
                        style: Apptextstyles.normaltextStyle17,
                      ),
                    ],
                  ),
                ),
                ListTile(
                  trailing: Card(
                    elevation: 0,
                    color: AppColors.lightgreen,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Paid'),
                    ),
                  ),
                  minLeadingWidth: 0,
                  contentPadding: EdgeInsets.zero,
                  leading: CachedNetworkImage(
                    imageUrl: patient.profileImageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover)),
                    ),
                    errorWidget: (context, url, error) => Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                        )),
                    fit: BoxFit.cover,
                    height: 50,
                    width: 50,
                  ),
                  title: Text(patient.name),
                  subtitle: Text(patient.specialty),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Temperature',
                    style: Apptextstyles.smalltextStyle14,
                  ),
                ),
                Text(
                  appointment.temperature,
                  style: Apptextstyles.smalltextStyle14.bold,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Symptoms',
                    style: Apptextstyles.smalltextStyle14,
                  ),
                ),
                ...appointment.symptoms.map(
                  (e) => BulletPointTextWidget(
                    text: e,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Allergies',
                    style: Apptextstyles.smalltextStyle14,
                  ),
                ),
                ...appointment.allergies.map(
                  (e) => BulletPointTextWidget(
                    text: e,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Brief Complaint',
                    style: Apptextstyles.smalltextStyle14,
                  ),
                ),
                Text(
                  appointment.complaint,
                  style: Apptextstyles.smalltextStyle14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

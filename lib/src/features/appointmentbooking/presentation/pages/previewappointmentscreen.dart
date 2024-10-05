import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/appointmentbooking/presentation/pages/bookingsubmissionscreen.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/authentication/data/models/user.dart';
import 'package:healthai/src/features/profilepage/data/sources/enums/temperature.dart';
import 'package:healthai/styles/apptextstyles.dart';
import 'package:healthai/theme/appcolors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../commonwidgets/expandedbuttons.dart';
import '../../../../../utils/geminihelper.dart';
import '../../../home/domain/repositories/specialist_repository.dart';

class PreviewAppointmentReport extends StatefulWidget {
  const PreviewAppointmentReport({
    super.key,
    required this.complaintData,
  });
  final ({
    Patient user,
    String complaint,
    Temperature temp,
    List<String> allergies,
  }) complaintData;
  static String id = 'PreviewAppointmentReport';
  @override
  State<PreviewAppointmentReport> createState() =>
      _PreviewAppointmentReportState();
}

class _PreviewAppointmentReportState extends State<PreviewAppointmentReport> {
  Specialist? selectedProfessional;
  List<Specialist>? specialists;
  Specialist? specialist;
  late GenerativeModel _model;
  late ChatSession _chat;
  var fetchSpecialistRepository = FetchSpecialistRepository();
  String? profession;
  bool isLoading = true;
  ({String specialist, String message, List<String> symptoms})? outputMessage;
  @override
  void initState() {
    _model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: Geminihelper.apiKey,
    );

    _chat = _model.startChat();
    context;
    fetchSpecialistRepository.getGroupedSpecialist().then((value) {
      do {
        getSpecialistData();
      } while (isLoading == false);
    });

    super.initState();
  }

  void getSpecialistData() async {
    await _chat
        .sendMessage(
      Content.text(Geminihelper.prompt(
          user: widget.complaintData.user,
          complaint: widget.complaintData.complaint,
          temperature: widget.complaintData.temp,
          specialists: fetchSpecialistRepository.sortedSpecialists
              .map(
                (e) => e.key,
              )
              .toList(),
          alergies: widget.complaintData.allergies)),
    )
        .then(
      (geminivalue) {
        Map? decode;
        try {
          decode = jsonDecode((geminivalue.text ?? ""));
          outputMessage = (
            message: decode!['message'],
            specialist: decode['specialist'],
            symptoms: List.from(decode['symptoms'] ?? [])
          );
          log(decode.toString());
        } on Exception catch (e) {
          log(e.toString());
          // log(value.text.toString());
          log(decode.toString());
          decode = jsonDecode(cleanJsonString((geminivalue.text ?? "")));
          outputMessage = (
            message: decode!['message'],
            specialist: decode['specialist'],
            symptoms: List.from(decode['symptoms'] ?? [])
          );
        }

        if (outputMessage != null) {
          profession = outputMessage!.specialist;
          log(profession.toString());
          setState(() {
            isLoading = false;
          });
          log(specialists.toString());
          try {
            specialists = fetchSpecialistRepository.sortedSpecialists
                .where((element) => element.key == profession!.trim())
                .first
                .value;
            specialist = specialists!.first;
          } on Exception catch (e) {
            log(e.toString());
          }

          log(specialist.toString());
        }
      },
    ).onError(
      (error, stackTrace) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Consumer(builder: (context, ref, child) {
                return Column(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MarkdownBody(
                            data: outputMessage!.message,
                            shrinkWrap: true,
                            styleSheet: MarkdownStyleSheet(
                              // p:,
                              strong: TextStyle(
                                color: AppColors.primaryColorblue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20.0,
                            ),
                            child: Text(
                              'Recommendation',
                              style: Apptextstyles.normaltextStyle15.bold,
                            ),
                          ),
                          Container(
                              height: 45,
                              padding: const EdgeInsets.all(5),
                              margin: const EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: AppColors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(5)),
                              child: DropdownButton<String>(
                                hint: const Text('Specialist'),
                                value: profession,
                                items:
                                    fetchSpecialistRepository.sortedSpecialists
                                        .map(
                                          (e) => DropdownMenuItem(
                                              onTap: () {
                                                specialists = e.value;
                                                specialist = e.value.first;
                                              },
                                              value: e.key,
                                              child: Text(e.key)),
                                        )
                                        .toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    profession = value;
                                  });
                                },
                                underline: const SizedBox(),
                                isExpanded: true,
                                icon: Text(
                                  'Change',
                                  style: Apptextstyles.smalltextStyle12
                                      .copyWith(fontWeight: FontWeight.bold)
                                      .blue,
                                ),
                              )),
                          Container(
                            height: 45,
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.grey,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: DropdownButton<Specialist>(
                              hint: const Text('Specialist'),
                              value: specialist,
                              items: specialists
                                  ?.map(
                                    (e) => DropdownMenuItem(
                                        value: e,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: CircleAvatar(
                                                radius: 16,
                                                child: CachedNetworkImage(
                                                  imageUrl: e.profileImageUrl,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      ClipOval(
                                                          child: Image(
                                                    image: imageProvider,
                                                    width: 32,
                                                    fit: BoxFit.cover,
                                                  )),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const SizedBox(),
                                                ),
                                              ),
                                            ),
                                            Text(e.name),
                                          ],
                                        )),
                                  )
                                  .toList(),
                              onChanged: (Specialist? value) {
                                setState(() {
                                  specialist = value;
                                });
                              },
                              underline: const SizedBox(),
                              isExpanded: true,
                              icon: Text(
                                'Change',
                                style: Apptextstyles.smalltextStyle12
                                    .copyWith(fontWeight: FontWeight.bold)
                                    .blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        bottom: 8.0,
                      ),
                      child: ExpandedStyledButton(
                          onTap: () {
                            showDialog(
                              barrierColor:
                                  AppColors.barriercolor.withOpacity(0.9),
                              context: context,
                              builder: (context) => AlertDialog(
                                contentPadding: const EdgeInsets.all(15),
                                alignment: const Alignment(0, -0.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                actionsAlignment: MainAxisAlignment.center,
                                actionsOverflowAlignment:
                                    OverflowBarAlignment.center,
                                actionsOverflowDirection: VerticalDirection.up,
                                actions: [
                                  OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Close')),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                      ),
                                      onPressed: () {
                                        context.pushNamed(
                                            BookingSubmissionScreen.id,
                                            extra: {
                                              'specialist': specialist,
                                              'complaint': widget
                                                  .complaintData.complaint,
                                              'temperature':
                                                  widget.complaintData.temp,
                                              'symptoms':
                                                  outputMessage!.symptoms,
                                              'allergies': widget
                                                  .complaintData.allergies,
                                            });
                                      },
                                      child: const Text('Preview'))
                                ],
                                title: Text(
                                  'Submission Successful',
                                  style: Apptextstyles.normaltextStyle17.green,
                                  textAlign: TextAlign.center,
                                ),
                                content: Text(
                                  'You will be notified to confirm your booking with the next available doctor.',
                                  style: Apptextstyles.smalltextStyle14,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            );
                          },
                          title: Text('Schedule Appointment')),
                    )
                  ],
                );
              }),
            ),
    );
  }
}

Future createAppointment(CustomUserData user) {
  return FirebaseFirestore.instance.collection('appointment').get();
}

String cleanJsonString(String jsonString) {
  final pattern = RegExp(r'^```json\s*(.*?)\s*```$', dotAll: true);
  final cleanedString = jsonString.replaceAll(pattern, r'\1');
  return cleanedString.trim();
}

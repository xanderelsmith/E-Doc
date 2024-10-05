import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:healthai/commonwidgets/expandedbuttons.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/appointmentbooking/presentation/pages/previewappointmentscreen.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/profilepage/data/sources/enums/temperature.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../commonwidgets/specialtextfield.dart';
import '../../../../../commonwidgets/tag_chip.dart';
import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';
// ignore: unused_import
import '../../../../../utils/geminihelper.dart';

class BookAppointmentScreen extends ConsumerStatefulWidget {
  const BookAppointmentScreen({
    super.key,
    required this.patient,
  });
  final Patient patient;
  static String id = 'BookAppointmentScreen';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends ConsumerState<BookAppointmentScreen> {
  late Temperature temperature;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController complaints;

  List allergies = [];
  @override
  void initState() {
    temperature = Temperature.warm;
    complaints = TextEditingController();

    allergies = widget.patient.allergies;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userDetailsProvider)!;

    (user is Patient) ? user.allergies : [];

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tell us how you are feeling'),
                      const Text('Fill-in accurate details only'),
                      const Divider(),
                      const Text('Temperature'),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.black,
                                )),
                            child: DropdownButton(
                              isExpanded: true,
                              hint: const Text('Temperature'),
                              underline: const SizedBox(),
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined),
                              value: temperature,
                              items: Temperature.values
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e.name,
                                          style:
                                              Apptextstyles.smalltextStyle14),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  temperature = value ?? Temperature.warm;
                                });
                              },
                            ),
                          )),
                      const Text(' Symptoms (Explain in details how you feel)'),
                      SpecialTextfield(
                        controller: complaints,
                        maxlines: 5,
                        innerHint: 'I have been having a bad headache, ...',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a brief description of how you feel';
                          }
                          if (value.trim().split(' ').length > 4 != true) {
                            return 'Please enter more characters (atleast 5 words) ';
                          }
                          return null;
                        },
                        contentPadding: const EdgeInsets.all(
                          15,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text('Existing Allergies  (from your profile)'),
                      ),
                      Wrap(
                        spacing: 8,
                        children: allergies
                            .map((allergy) => TagChip(
                                onTap: () {},
                                disableIcon: true,
                                color: AppColors.white,
                                backgroundcolor: const Color(0xff1C1717),
                                label: allergy.trim()))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8.0,
              ),
              child: ExpandedStyledButton(
                  onTap: () async {
                    var data = (
                      user: user,
                      temp: temperature,
                      complaint: complaints.text,
                      allergies: allergies,
                    );
                    context.pushNamed(PreviewAppointmentReport.id, extra: data);

                    // showDialog(
                    //   context: context,
                    //   builder: (context) => const Center(
                    //     child: CircularProgressIndicator(),
                    //   ),
                    // );

                    // await _chat
                    //     .sendMessage(
                    //   Content.text(Geminihelper.prompt(complaints.text, specialists)),
                    // )
                    //     .then(
                    //   (value) {
                    //     final text = value;
                    //     if (_formKey.currentState!.validate()) {
                    //       if (context.mounted) {
                    //         Navigator.pop(context);
                    //         context
                    //             .pushNamed(PreviewAppointmentReport.id, extra: {
                    //           'temp': temperature?.name,
                    //           "complaint": complaints.text,
                    //           'allergies': allergies,
                    //           'airesponse': text
                    //         });
                    //       }
                    //     }
                    //     return value;
                    //   },
                    // );
                  },
                  title: Text('Proceed')),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> sendChatMessage(String message, chat) async {
  final response = await chat
      .sendMessage(
    Content.text(message),
  )
      .then(
    (value) {
      return value;
    },
  );

  final text = response.text;
}

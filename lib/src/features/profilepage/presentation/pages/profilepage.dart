import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/commonwidgets/expandedbuttons.dart';
import 'package:healthai/commonwidgets/logotext.dart';
import 'package:healthai/commonwidgets/specialtextfield.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/route/routes.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/authentication/data/models/user.dart';
import 'package:healthai/src/features/onboarding/presentation/pages/onboardingscreen.dart';
import 'package:healthai/src/features/profilepage/data/sources/enums/bloodgroup.dart';
import 'package:healthai/src/features/profilepage/data/sources/enums/gender.dart';
import 'package:healthai/src/features/profilepage/data/sources/enums/genotype.dart';
import 'package:healthai/styles/apptextstyles.dart';
import 'package:healthai/theme/appcolors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../commonwidgets/tag_chip.dart';
import '../../../../../constant/states.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  late TextEditingController firstName;
  late TextEditingController lastname;
  CustomUserData? baseUser;
  Gender? gender;
  var state = TextEditingController();
  DateTime? date;
  TextEditingController dateinput = TextEditingController();
  late TextEditingController specialtytextEditingController;

  var disabilities = TextEditingController();
  var homeAddressController = TextEditingController();
  BloodGroup? bloodgroup;
  Genotype? genotype;
  late TextEditingController allergiesController;
  String? selectedState;
  Set<String> allergies = {};
  @override
  void didChangeDependencies() {
    allergiesController =
        TextEditingController(text: allergies.toList().join(','))
          ..addListener(
            () {},
          );
    dateinput = TextEditingController(
        text: date == null ? '' : DateFormat('yyyy-MM-dd').format(date!));
    baseUser = ref.watch(userDetailsProvider);
    firstName = TextEditingController(text: (baseUser!).username.split(' ')[0]);
    lastname = TextEditingController(text: (baseUser!).username.split(' ')[1]);
    if (baseUser is Patient) {
      var user = baseUser! as Patient;
    } else {
      specialtytextEditingController =
          TextEditingController(text: (baseUser! as Specialist).specialty);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 100,
        width: getScreenSize(context).width - 50,
        child: Column(
          children: [
            Center(
                child: ExpandedStyledButton(
                    onTap: () {
                      // FirebaseAuth.instance.currentUser.updateProfile();
                    },
                    title: 'Save details')),
            TextButton(
                onPressed: () {
                  context.pushReplacementNamed(OnboardingPage.id);
                },
                style: TextButton.styleFrom(foregroundColor: AppColors.red),
                child: const Text('Log Out'))
          ],
        ),
      ),
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Color(0xFF757575)),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        width: getScreenSize(context).width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    alignment: Alignment.center,
                    height: 143,
                    decoration: BoxDecoration(
                        color: AppColors.lightgrey,
                        borderRadius: BorderRadius.circular(
                          10,
                        )),
                    child: Text(
                      'Upload Photo',
                      style: Apptextstyles.normaltextStyle15,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Bio Data',
                    style: Apptextstyles.smalltextStyle14
                        .copyWith(color: AppColors.textButtonColor)
                        .bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    controller: firstName,
                    textfieldname: 'First Name',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    controller: lastname,
                    textfieldname: 'Last Name',
                  ),
                ),
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
                        hint: const Text('Gender'),
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        value: gender,
                        items: Gender.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name,
                                    style: Apptextstyles.smalltextStyle14),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            gender = value;
                          });
                        },
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    readonly: true,
                    controller: dateinput,
                    innerHint: "Enter Date of birth",

                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      date = await showDatePicker(
                          helpText: 'Input your date of birth',
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(
                              1500), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(DateTime.now().year + 20));

                      if (date != null) {
                        if (kDebugMode) {
                          print(date);
                        }
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(date!);
                        setState(() {
                          dateinput.text = formattedDate;
                        });
                      } else {}
                    },

                    textfieldname: 'Date Of Birth',
                    suffixwidget: const Icon(Icons.calendar_month),
                  ),
                ),
                if (ref.watch(userDetailsProvider)!.isSpecialist)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SpecialTextfield(
                      textfieldname: 'Specialty/Job Title',
                      controller: specialtytextEditingController,
                      textInputtype: TextInputType.emailAddress,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    textfieldname: 'Country',
                    enabled: false,
                    controller: TextEditingController(text: 'Nigeria'),
                    readonly: true,
                  ),
                ),
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
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('State'),
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        value: selectedState,
                        items: statesOfNigeria
                            .map(
                              (e) => DropdownMenuItem(
                                value: e.name,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(e.name,
                                          style:
                                              Apptextstyles.smalltextStyle14),
                                    ),
                                    Text(e.abbreviation)
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedState = value;
                          });
                        },
                      ),
                    )),
                if (!ref.watch(userDetailsProvider)!.isSpecialist)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: SpecialTextfield(
                      controller: homeAddressController,
                      textfieldname: 'Home Address',
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    'Medical Records',
                    style: Apptextstyles.smalltextStyle14
                        .copyWith(color: AppColors.textButtonColor)
                        .bold,
                  ),
                ),
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
                        hint: const Text('BloodGroup'),
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        value: bloodgroup,
                        items: BloodGroup.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name,
                                    style: Apptextstyles.smalltextStyle14),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            bloodgroup = value;
                          });
                        },
                      ),
                    )),
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
                        hint: const Text('Gender'),
                        underline: const SizedBox(),
                        icon: const Icon(Icons.keyboard_arrow_down_outlined),
                        value: genotype,
                        items: Genotype.values
                            .map(
                              (e) => DropdownMenuItem(
                                value: e,
                                child: Text(e.name,
                                    style: Apptextstyles.smalltextStyle14),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            genotype = value;
                          });
                        },
                      ),
                    )),
                Wrap(
                  spacing: 8,
                  children: allergies
                      .map((allergy) => PostTag(
                          onTap: () => setState(() {
                                allergies.remove(allergy);
                              }),
                          label: allergy.trim()))
                      .toList(),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    controller: allergiesController,
                    onChanged: (value) {
                      List<String> split = value.trim().split(",");
                      setState(() {
                        allergies = split.toSet();
                      });
                    },
                    textfieldname: 'Allergies(e.g drowsiness, fever)',
                    innerHint: 'Seperate using comma',
                    contentPadding: const EdgeInsets.only(
                      top: 20,
                      left: 10,
                    ),
                    maxlines: 6,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    controller: disabilities,
                    textfieldname: 'Any form of disability?',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

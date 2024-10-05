import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/commonwidgets/expandedbuttons.dart';
import 'package:healthai/commonwidgets/specialtextfield.dart';
import 'package:healthai/extensions/textstyleext.dart';
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
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../../commonwidgets/tag_chip.dart';
import '../../../../../../constant/states.dart';

class EditSpecialistProfilePage extends ConsumerStatefulWidget {
  const EditSpecialistProfilePage({
    super.key,
    required this.baseUser,
  });
  final Specialist? baseUser;
  static String id = 'EditSpecialistProfilePage';
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<EditSpecialistProfilePage> {
  late TextEditingController firstName;
  late TextEditingController lastname;

  Gender? gender;
  var state = TextEditingController();
  DateTime? date;
  TextEditingController dateinput = TextEditingController();
  late TextEditingController specialtytextEditingController;

  var disabilities = TextEditingController();
  late TextEditingController homeAddressController;
  BloodGroup? bloodgroup;
  Genotype? genotype;
  late TextEditingController allergiesController;
  String? selectedState;
  Set<String> allergies = {};
  XFile? profileImgFile;
  List<String> languages = [];
  @override
  void initState() {
    super.initState();

    allergiesController =
        TextEditingController(text: allergies.toList().join(','))
          ..addListener(
            () {},
          );
    log(widget.baseUser!.toMap().toString());
    languages = widget.baseUser!.languages ?? [];
    specialtytextEditingController =
        TextEditingController(text: widget.baseUser!.specialty);
    if (widget.baseUser!.dateOfBirth != null) {
      date = DateTime.tryParse(widget.baseUser!.dateOfBirth ?? "");
    }
    dateinput = TextEditingController(
        text: date == null ? '' : DateFormat('yyyy-MM-dd').format(date!));

    homeAddressController = TextEditingController();
    selectedState = widget.baseUser!.state;
    gender = widget.baseUser!.gender;
    firstName =
        TextEditingController(text: (widget.baseUser!).username.split(' ')[0]);
    lastname =
        TextEditingController(text: (widget.baseUser!).username.split(' ')[1]);
    if (widget.baseUser is Patient) {}
  }

  @override
  Widget build(BuildContext context) {
    var textEditingController =
        TextEditingController(text: widget.baseUser!.email);
    return Scaffold(
      bottomNavigationBar: SizedBox(
        height: 100,
        width: getScreenSize(context).width - 50,
        child: Column(
          children: [
            Center(
                child: ExpandedStyledButton(
                    onTap: () async {
                      String? downloadURL;
                      showDialog(
                        context: context,
                        builder: (context) =>
                            const Center(child: CircularProgressIndicator()),
                      );

                      Specialist user = (widget.baseUser as Specialist);
                      if (profileImgFile != null) {
                        downloadURL = await uploadImage(
                            File(profileImgFile!.path), user.name);
                      }
                      log(languages.toString());
                      user = user.copyWith(
                          address: homeAddressController.text,
                          languages: languages,
                          state: selectedState,
                          dateOfBirth: dateinput.text,
                          specialty: specialtytextEditingController.text,
                          bloodGroup:
                              bloodgroup != null ? bloodgroup!.name : '',
                          genotype: genotype != null ? genotype!.name : '',
                          name: '${firstName.text} ${lastname.text}',
                          profileImageUrl: downloadURL,
                          allergies: allergies.toList(),
                          gender: gender);
                      await updateUserToFirestore(user).then(
                        (value) {
                          ref
                              .watch(userDetailsProvider.notifier)
                              .assignUser(user);
                          if (!context.mounted) return;
                          Navigator.pop(context);
                          context.pop();
                          context.pop();
                        },
                      );
                    },
                    title: const Text('Save details'))),
            TextButton(
                onPressed: () {
                  context.goNamed(OnboardingPage.id);
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
                  child: GestureDetector(
                    onTap: () async {
                      var newfile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);

                      if (newfile != null) {
                        setState(() {
                          profileImgFile = newfile;
                        });
                      }

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Added Image Successfully ')));
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        bottom: 20,
                      ),
                      alignment: Alignment.center,
                      height: 143,
                      width: getScreenSize(context).width,
                      child: profileImgFile != null
                          ? Stack(
                              children: [
                                Image.file(
                                  File(profileImgFile!.path),
                                  fit: BoxFit.cover,
                                  height: 143,
                                  width: getScreenSize(context).width,
                                ),
                              ],
                            )
                          : Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      widget.baseUser?.profileImageUrl ?? "",
                                  fit: BoxFit.cover,
                                  height: 143,
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: AppColors.deepPurple,
                                    child: const Center(
                                      child: const Text('Tap to Upload Photo'),
                                    ),
                                  ),
                                  width: getScreenSize(context).width,
                                ),
                                Center(
                                  child: Text(
                                    'Tap to Replace Photo',
                                    style: Apptextstyles.normaltextStyle15.white
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: SpecialTextfield(
                    controller: textEditingController,
                    textfieldname: 'Email Address',
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
                const Text('Spoken Language '),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: SizedBox(
                    width: getScreenSize(context).width,
                    child: Wrap(
                      children: List.generate(
                        SpokenLanguages.values.length,
                        (index) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                                onChanged: (val) {
                                  setState(() {
                                    if (languages.contains(
                                      SpokenLanguages.values[index].name,
                                    )) {
                                      languages.remove(
                                          SpokenLanguages.values[index].name);
                                    } else {
                                      languages.add(
                                          SpokenLanguages.values[index].name);
                                    }
                                  });
                                },
                                value: languages.contains(
                                  SpokenLanguages.values[index].name,
                                )),
                            Text(SpokenLanguages.values[index].name)
                          ],
                        ),
                      ),
                    ),
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

Future<String> uploadImage(File image, username) async {
  var split = image.path.split('.');
  final fileName = '$username.${split.last}';
  final ref = FirebaseStorage.instance.ref().child('user_images/$fileName');

  try {
    // Attempt upload, if it fails due to already existing file, catch and delete
    await ref.putFile(image);
    return await ref.getDownloadURL();
  } on FirebaseException catch (e) {
    if (e.code == 'storage/object-already-exists') {
      // File already exists, delete and then upload
      await ref.delete();
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } else {
      // Re-throw other exceptions
      rethrow;
    }
  }
}

Future<void> updateUserToFirestore(CustomUserData patient) async {
  DocumentReference userRef =
      FirebaseFirestore.instance.collection('users').doc(patient.email);
  await userRef.update(patient.toMap());
}

enum SpokenLanguages {
  igbo,
  english,
  yoruba,
  pidgin,
  hausa,
  french,
}

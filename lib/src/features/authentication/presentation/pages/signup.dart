import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/extensions/userextension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:healthai/commonwidgets/logotext.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/authentication/data/models/user.dart';
import 'package:healthai/src/features/authentication/presentation/pages/loginscreen.dart';
import 'package:healthai/styles/apptextstyles.dart';
import 'package:healthai/theme/appcolors.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../commonwidgets/expandedbuttons.dart';
import '../../../../../commonwidgets/specialtextfield.dart';
import '../../../appointmentbooking/domain/repositories/userrepository.dart';
import '../../../home/presentation/pages/homepage.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = 'SignUpScreen';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  var passwordtextEditingController = TextEditingController();
  var fullnameTextEditingControler = TextEditingController();
  var emailtextEditingController = TextEditingController();
  TextEditingController specialtytextEditingController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  TextEditingController verifytextEditingController = TextEditingController();
  late TabController tabController;
  bool isLoggedIn = false;
  bool ishidden = true;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this)
      ..addListener(
        () {
          setState(() {});
        },
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const LogoText(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Sign Up',
                style: Apptextstyles.largetextStyle31.bold,
              ),
              Text(
                'Welcome, please fill in your details to create new account',
                style: Apptextstyles.smalltextStyle13,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Text(
                  'Account type',
                  style: Apptextstyles.smalltextStyle13,
                ),
              ),
              Container(
                height: 54,
                decoration: BoxDecoration(
                    color: AppColors.lightgrey,
                    borderRadius: BorderRadius.circular(4)),
                child: TabBar(
                  indicatorSize: TabBarIndicatorSize.tab,
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  controller: tabController,
                  dividerColor: Colors.transparent,
                  tabs: const [
                    Text('Patient'),
                    Text('Specialist'),
                  ],
                  indicator: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(4)),
                ),
              ),
              Form(
                key: _formKey,
                onChanged: () {
                  setState(() {});
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SpecialTextfield(
                        textfieldname: 'Full Name',
                        controller: fullnameTextEditingControler,
                        textInputtype: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Full Name';
                          }
                          if (value.trim().split(' ').length > 1 != true) {
                            return 'Please enter a valid Full Name (2 names or more)';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SpecialTextfield(
                        textfieldname: 'Email',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$")
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                        controller: emailtextEditingController,
                        textInputtype: TextInputType.emailAddress,
                      ),
                    ),
                    if (tabController.index == 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SpecialTextfield(
                          textfieldname: 'Specialty/Job Title',
                          controller: specialtytextEditingController,
                          textInputtype: TextInputType.emailAddress,
                        ),
                      ),
                    SpecialTextfield(
                      ishidden: ishidden,
                      isMultiline: false,
                      suffixwidget: IconButton(
                          onPressed: () {
                            setState(() {
                              ishidden = !ishidden;
                            });
                          },
                          icon: ishidden
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                      textfieldname: 'Password',
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (!PasswordValidator.isValid(value)) {
                          return 'Password must be 8 or more characters';
                        }
                        return null;
                      },
                      controller: passwordtextEditingController,
                      textInputtype: TextInputType.visiblePassword,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SpecialTextfield(
                        suffixwidget: IconButton(
                            onPressed: () {
                              setState(() {
                                ishidden = !ishidden;
                              });
                            },
                            icon: ishidden
                                ? const Icon(Icons.visibility)
                                : const Icon(Icons.visibility_off)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != passwordtextEditingController.text) {
                            return 'Passwords  do not match';
                          }
                          return null;
                        },
                        ishidden: ishidden,
                        textfieldname: 'Verify Password',
                        controller: verifytextEditingController,
                        textInputtype: TextInputType.visiblePassword,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        style: Apptextstyles.smalltextStyle13,
                        children: [
                          const TextSpan(
                            text: 'By continuing, you agree to our',
                          ),
                          TextSpan(
                              text: '\tTerms of Service',
                              style: TextStyle(
                                color: AppColors.primaryColorblue,
                              ).bold),
                          const TextSpan(
                            text: '\tand\t',
                          ),
                          TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.primaryColorblue,
                              ).bold),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Consumer(builder: (context, ref, child) {
                        return ExpandedStyledButton(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                final userCredential = await FirebaseAuth
                                    .instance
                                    .createUserWithEmailAndPassword(
                                  email: emailtextEditingController.text,
                                  password: passwordtextEditingController.text,
                                );

                                final userRef = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userCredential.user!.email);

                                CustomUserData user = tabController.index == 0
                                    ? Patient(
                                        username:
                                            fullnameTextEditingControler.text,
                                        allergies: [],
                                        specialty:
                                            specialtytextEditingController.text,
                                        name: fullnameTextEditingControler.text,
                                        phoneNumber: '0',
                                        profileImageUrl: '',
                                        email: userCredential.user!.email ?? "")
                                    : Specialist(
                                        allergies: [],
                                        specialty:
                                            specialtytextEditingController.text,
                                        name: fullnameTextEditingControler.text,
                                        phoneNumber: "0",
                                        profileImageUrl: '',
                                        email:
                                            userCredential.user!.email ?? "");
                                var profiledata = user.toMap();
                                {
                                  await userRef.set(profiledata);

                                  // Successful registration
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('User created successfully'),
                                      ),
                                    );
                                  }

                                  ref
                                      .watch(userDetailsProvider.notifier)
                                      .assignUser(tabController.index == 0
                                          ? Patient.fromMap(profiledata)
                                          : Specialist.fromMap(profiledata));

                                  context.pushReplacementNamed(HomePage.id);
                                }
                              } catch (e) {
                                // Handle registration errors
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Registration failed: ${e.toString()}'),
                                  ),
                                );
                              }
                            }
                          },
                          title: const Text('Create Account'),
                        );
                      }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 18.0),
                      child: Text.rich(
                        TextSpan(
                          style: Apptextstyles.smalltextStyle13,
                          children: [
                            const TextSpan(
                              text: 'Already have an account?',
                            ),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context
                                        .pushReplacementNamed(LoginScreen.id);
                                  },
                                text: '\t Log In',
                                style: TextStyle(
                                  color: AppColors.primaryColorblue,
                                ).bold),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordValidator {
  static bool isValid(String password) {
    // Implement your desired password validation rules
    // Here are some examples:
    return password.length >= 8;

    // password.contains(RegExp(r'[A-Z]')) &&
    // password.contains(RegExp(r'[a-z]')) &&
    // password.contains(RegExp(r'[0-9]')) &&
    // password.contains(RegExp(r'[!@#\$%^&*()_+{}\[\]:;<>,.?/~]'));
  }
}

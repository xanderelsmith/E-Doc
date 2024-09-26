import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:healthai/commonwidgets/specialtextfield.dart';
import 'package:healthai/extensions/textstyleext.dart';
import 'package:healthai/extensions/userextension.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/authentication/presentation/pages/signup.dart';
import 'package:healthai/src/features/home/presentation/pages/homepage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../commonwidgets/expandedbuttons.dart';
import '../../../../../commonwidgets/logotext.dart';
import '../../../../../styles/apptextstyles.dart';
import '../../../../../theme/appcolors.dart';
import '../../../onboarding/presentation/pages/onboardingscreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'LoginScreen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
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
        title: LogoText(),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Log In',
              style: Apptextstyles.largetextStyle31.bold,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 28.0),
              child: Text(
                'Welcome back, log in to access your account.',
                style: Apptextstyles.smalltextStyle13,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: SpecialTextfield(
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
                      ),
                      Text.rich(
                        TextSpan(
                          style: Apptextstyles.smalltextStyle13,
                          children: [
                            TextSpan(
                                text: 'Forget Password?',
                                style: TextStyle(
                                  color: AppColors.primaryColorblue,
                                ).bold),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Consumer(builder: (context, ref, child) {
                    return ExpandedStyledButton(
                        title: 'Log In',
                        onTap: () async {
                          // var password =
                          //     passwordtextEditingController.text.trim();
                          // var verifypassword =
                          //     passwordtextEditingController.text.trim();

                          // if (_formKey.currentState!.validate()) {
                          //   FirebaseAuth.instance
                          //       .createUserWithEmailAndPassword(
                          //           email: emailtextEditingController.text,
                          //           password:
                          //               passwordtextEditingController.text)
                          //       .then(
                          //     (value) {
                          //
                          // },
                          // );

                          if (_formKey.currentState!.validate()) {
                            await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailtextEditingController.text,
                                    password:
                                        passwordtextEditingController.text)
                                .then(
                              (userCredential) async {
                                final user = userCredential.user!;
                                final userRef = await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.email)
                                    .get();
                                log(userRef.data().toString());
                                ref
                                    .watch(userDetailsProvider.notifier)
                                    .assignUser(userRef.toCustomUSer());
                                if (!mounted) return;
                                context.pushReplacementNamed(HomePage.id);
                              },
                            ).onError(
                              (e, stackTrace) {
                                // Navigate to login screen or other appropriate page

                                // Handle registration errors
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Registration failed: ${e.toString()}'),
                                  ),
                                );
                              },
                            );
                          }
                        });
                  })),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18.0),
                    child: Text.rich(
                      TextSpan(
                        style: Apptextstyles.smalltextStyle13,
                        children: [
                          const TextSpan(
                            text: 'Don’t have an account?',
                          ),
                          TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.pushReplacementNamed(SignUpScreen.id);
                                },
                              text: '\t Sign Up',
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
    );
  }
}

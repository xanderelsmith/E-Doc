// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:healthai/firebase_options.dart';
import 'package:healthai/route/routes.dart';
import 'package:healthai/theme/apptheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    FirebaseAuth.instance.authStateChanges();
  } on Exception catch (e) {
    log(e.toString());
  }
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {}

  runApp(ProviderScope(
      child: MaterialApp.router(
    title: 'Flutter Demo',
    theme: AppTheme.lighttheme,
    routerConfig: router(user != null),
  )));
}

Future<Map<String, dynamic>?> loadUserData(email, WidgetRef ref) async {
  try {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    if (userDoc.exists) {
      var data = userDoc.data();
      log(data.toString());
      final userData = userDoc;
      if (data != null) {
        ref.watch(userDetailsProvider.notifier).assignUser(
            userData['isSpecialist']
                ? Specialist.fromMap(data)
                : Patient.fromMap(data));
      }
      print('yeahh');
      return data;
    } else {
      return null;
    }
  } catch (e) {
    // Handle errors
  }
  return null;
}

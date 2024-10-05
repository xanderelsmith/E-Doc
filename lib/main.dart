import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:healthai/service/notificationservice.dart';
import 'package:healthai/src/features/appointmentbooking/domain/repositories/userrepository.dart';
import 'package:healthai/src/features/authentication/data/models/patient.dart';
import 'package:healthai/src/features/authentication/data/models/specialist.dart';
import 'package:healthai/src/features/home/presentation/pages/homepage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:healthai/firebase_options.dart';
import 'package:healthai/route/routes.dart';
import 'package:healthai/theme/apptheme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalNotificationService().requestPermission();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  try {
    FirebaseAuth.instance.authStateChanges();
  } on Exception catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {}
  await LocalNotificationService().init();
  runApp(ProviderScope(
      child: MaterialApp.router(
    title: 'Flutter Demo',
    theme: AppTheme.lighttheme,
    routerConfig: router(user != null),
  )));
}

Future<Map<String, dynamic>?> loadUserData(
    email, WidgetRef ref, context) async {
  try {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(email).get();
    if (userDoc.exists) {
      var data = userDoc.data();
      log(data.toString());
      final userData = userDoc;
      if (data != null) {
        var userRepo = ref.watch(userDetailsProvider.notifier);
        userRepo.assignUser(userData['isSpecialist']
            ? Specialist.fromMap(data)
            : Patient.fromMap(data));
      }

      return data;
    } else {
      if (context.mounted) {
        context.goNamed(HomePage.id);
      }
    }
  } catch (e) {
    // Handle errors
  }
  return null;
}

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class LocalNotificationService {
  Future<void> uploadFCMToken(String email) async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(email);
    try {
      FirebaseMessaging.instance.getToken().then(
        (token) async {
          await userRef.update({
            'notificationToken': token,
          });
        },
      );

      FirebaseMessaging.instance.onTokenRefresh.listen(
        (token) async {
          log('onTokenRefresh::$token');
          await FirebaseFirestore.instance.collection('users').doc().set({
            'notificationToken': token,
          });
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> requestPermission() async {
    PermissionStatus status = await Permission.notification.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Permision Not granted');
    }
  }

  void notificationHandler() {
    // FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    FirebaseMessaging.onMessage.listen(
      (event) {
        print(event.notification!.title);
        LocalNotificationService().showNotification(event);

        // Log a custom event named "notification_received"
        // analytics.logEvent(
        //   parameters: {
        //     'title': event.notification!.title ?? '',
        //     'body': event.notification!.body ?? '',
        //   },
        //   name: 'done',
        // );
      },
    );
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin =
      FlutterLocalNotificationsPlugin();
  init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationPlugin.initialize(initializationSettings);
  }

  showNotification(RemoteMessage message) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails('channel_id', 'Channel Name',
            channelDescription: 'Channel Description',
            ticker: 'ticker',
            priority: Priority.high,
            importance: Importance.max);
    int notificationId = 1;
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationPlugin.show(
        notificationId,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: 'Not present');
  }
}

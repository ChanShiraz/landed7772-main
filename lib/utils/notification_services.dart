import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

import 'package:http/http.dart';

class NotificationServices {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  
  void initLocalNotification() async {

    var androidInitilizationSetting =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitilization = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
        android: androidInitilizationSetting, iOS: iosInitilization);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void notificationInit()async {
    try {
    await FirebaseMessaging.instance.subscribeToTopic("Listings");
      
    } catch (e) {
      print(e);
    }
    initLocalNotification();
    FirebaseMessaging.onMessage.listen((message) {
      //showNotification(message);
    });
  }

  Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel notificationChannel =
        const AndroidNotificationChannel('Listings', 'new',
            importance: Importance.max);

    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        notificationChannel.id, notificationChannel.name,
        importance: Importance.high, priority: Priority.high, ticker: 'ticker');

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails, iOS: darwinNotificationDetails);
    Future.delayed(
      Duration.zero,
      () {
        flutterLocalNotificationsPlugin.show(
            0,
            message.notification!.title.toString(),
            message.notification!.body.toString(),
            notificationDetails);
      },
    );
  }

  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user give permissions');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user gives provisional permissions');
    } else {
      print('user denied permissions');
    }
  }
  Future foregroundMessage()async{
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true
  );
  }
}

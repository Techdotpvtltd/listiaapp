// ignore: dangling_library_doc_comments
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Project: 	   wasteapp
/// File:    	   local_notification_services
/// Path:    	   lib/services/local_notification_services.dart
/// Author:       Ali Akbar
/// Date:        19-03-24 16:15:09 -- Tuesday
/// Description:

class LocalNotificationServices {
  // scheduleAlertAlarmNotification
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> scheduleAlertAlarmNotification(DateTime atTime) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'alarm_channel',
      "Alarm Notification",
      importance: Importance.max,
      priority: Priority.high,
    );

    final DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'alarm_sound.aiff',
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    final AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: androidInitializationSettings,
            iOS: darwinInitializationSettings);

    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
    );
    _flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Alart!',
      "Time to pick trash.",
      tz.TZDateTime.from(atTime, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exact,
    );
  }

  static Future<void> showNotification(RemoteMessage payload) async {
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initiallizationSettingsIOS = DarwinInitializationSettings();
    var initialSetting = InitializationSettings(
        android: android, iOS: initiallizationSettingsIOS);
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(
      initialSetting,
      onDidReceiveBackgroundNotificationResponse: (details) {},
    );

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_notification_channel_id',
      'Notification',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      icon: "@mipmap/ic_launcher",
      playSound: true,
    );
    const iOSDetails = DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await flutterLocalNotificationsPlugin.show(0, payload.notification!.title,
        payload.notification!.body, platformChannelSpecifics);
  }
}

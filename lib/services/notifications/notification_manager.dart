import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../local_storage_services.dart';
import 'push_notification_services.dart';

class NotificationManager {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  bool enabledNotifications = true;
  bool enabledInAppNotifications = true;
  final LocalStorageServices _localStorageServices = LocalStorageServices();
  StreamSubscription<RemoteMessage>? _firebaseMessagingForgroundListener;

  /// make sure all notifications are subscribed
  bool isAllSubscribed = false;

  Future<void> ensureInitialized() async {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return;
    }

    enabledNotifications =
        await _localStorageServices.getAllNotificationSetting();
    enabledInAppNotifications =
        await _localStorageServices.getInAppNotificationSetting();
    isAllSubscribed =
        await _localStorageServices.getEnsureNotificationEnabled();

    if (enabledNotifications) {
      await PushNotificationServices().ensureInitialized();
      await _subscribeToAllNotifications();
    }

    if (enabledInAppNotifications) {
      _firebaseMessagingForgroundHandler();
    }
  }

  Future<void> _subscribeToAllNotifications() async {
    if (isAllSubscribed) {
      return;
    }

    if (enabledNotifications) {
      await PushNotificationServices().subscribe(
          forTopic: "user-${FirebaseAuth.instance.currentUser?.uid}");
    }

    await _localStorageServices.saveEnsureNotificationEnabled(true);
  }

  Future<void> unscribeServices() async {
    await PushNotificationServices().unsubscribe(
        forTopic: "user-${FirebaseAuth.instance.currentUser?.uid}");
    await _localStorageServices.clearAll();
    _firebaseMessagingForgroundListener?.cancel();
    _firebaseMessagingForgroundListener = null;
    isAllSubscribed = false;
  }

  Future<void> setInAppSetting(bool value) async {
    await _localStorageServices.saveInAppNotificationSetting(value);
    enabledInAppNotifications = value;
    if (value) {
      _firebaseMessagingForgroundHandler();
    } else {
      _firebaseMessagingForgroundListener?.cancel();
    }
  }

  void _firebaseMessagingForgroundHandler() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    _firebaseMessagingForgroundListener =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final data = message.data['notification'];

      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');

        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }

      FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) {
          final String type = message.data['type'];
          if (type == 'message') {}

          if (kDebugMode) {
            print('Handling a foreground message: ${message.messageId}');
            print('Message data: ${message.data}');
            print('Message notification: ${message.notification?.title}');
            print('Message notification: ${message.notification?.body}');
          }
        },
      );

      debugPrint("Notification Data: $data");
      // LocalNotificationServices.showNotification(message);
      // CustomSnack.notification(message.notification?.title ?? "Notification",
      //     message.notification?.body ?? "",
      //     position: FlushbarPosition.TOP, durationnInSeconds: 3);
    });
  }

  // Pass background message
  void onClick(void Function(RemoteMessage) func) async {
    final message = await PushNotificationServices().getInitialMessage();
    if (message != null) {
      func(message);
    }
  }
}

// Global instance
final NotificationManager notificationManager = NotificationManager();

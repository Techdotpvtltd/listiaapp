import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Project: 	   burns_construction_admin
/// File:    	   push_notification
/// Path:    	   lib/services/push_notifications/push_notification.dart
/// Author:       Ali Akbar
/// Date:        15-02-24 16:51:20 -- Thursday
/// Description:
class FireNotification {
  static void fire({
    required String title,
    required String description,
    required String topic,
    required String type,
    Map<String, dynamic>? additionalData,
  }) async {
    const String fcmUrl =
        'https://c9trp80947.execute-api.eu-north-1.amazonaws.com/default';

    // Payload for the notification
    final Map<String, dynamic> notification = {
      "message": {
        "topic": topic,
        'notification': {
          'title': title,
          'body': description,
        },
        'data': {
          'type': type,
          "additionalData": jsonEncode(additionalData),
        }
      },
    };

    debugPrint(notification.toString());
    // Send the HTTP POST request to FCM endpoint
    final http.Response response = await http
        .post(Uri.parse(fcmUrl), body: jsonEncode(notification), headers: {
      'Content-Type': 'application/json',
    });

    final responseBoday = jsonDecode(response.body) as Map<String, dynamic>;
    // Check the response
    if (responseBoday['status'] == "success") {
      debugPrint('Notification sent for topic; $topic');
      debugPrint(responseBoday.toString());
    } else {
      log('Failed to send notification to topic: $topic\nError: $responseBoday');
    }
  }
}

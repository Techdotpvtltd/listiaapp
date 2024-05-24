import 'package:flutter/material.dart';

import '../../main.dart';

// Project: 	   listi_shop
// File:    	   navigation_service
// Path:    	   lib/utils/extensions/navigation_service.dart
// Author:       Ali Akbar
// Date:        03-05-24 13:52:08 -- Friday
// Description: 

class NavigationService {
  static Future<dynamic> go(Widget child) async {
    return await Navigator.push(
        navKey.currentContext!, MaterialPageRoute(builder: (context) => child));
  }

  static void off(Widget child) {
    Navigator.pushReplacement(
        navKey.currentContext!, MaterialPageRoute(builder: (context) => child));
  }

  static void offAll(Widget child) {
    Navigator.pushAndRemoveUntil(navKey.currentContext!,
        MaterialPageRoute(builder: (context) => child), (route) => false);
  }

  static void back() {
    Navigator.pop(navKey.currentContext!);
  }
}

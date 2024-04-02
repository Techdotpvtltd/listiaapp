import 'package:flutter/material.dart';

import '../../main.dart';

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

import 'package:flutter/material.dart';

import '../../main.dart';
import '../../utils/constants/constants.dart';

class CustomSnackBar {
  void _show(
    String message,
    Color? backgroundColor,
    Color? textColor,
  ) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      margin: EdgeInsets.only(bottom: SCREEN_HEIGHT / 2.5),
      duration: const Duration(milliseconds: 750),
      elevation: 0,
      content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.black,
            boxShadow: const [
              // BoxShadow(
              //   color: Color(0x19000000),
              //   spreadRadius: 2.0,
              //   blurRadius: 8.0,
              //   offset: Offset(2, 4),
              // )
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  message,
                  style: TextStyle(
                    color: textColor ?? Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          )),
    );
    ScaffoldMessenger.of(navKey.currentContext!).showSnackBar(snackBar);
  }

  void success(String message) {
    _show(message, const Color.fromARGB(255, 113, 205, 116), Colors.black);
  }

  void error(String message) {
    _show(message, Colors.red, Colors.white);
  }

  void alert(String message) {
    _show(message, Colors.yellow, Colors.black);
  }
}

import 'package:flutter/material.dart';

import '../../main.dart';

class CustomSnackBar {
  void _show(
    String message,
    Color? backgroundColor,
    Color? textColor,
  ) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
          padding: const EdgeInsets.all(8),
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
            borderRadius: BorderRadius.circular(12),
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
    _show(message, Colors.green, Colors.white);
  }

  void error(String message) {
    _show(message, Colors.red, Colors.white);
  }

  void alert(String message) {
    _show(message, Colors.yellow, Colors.black);
  }
}

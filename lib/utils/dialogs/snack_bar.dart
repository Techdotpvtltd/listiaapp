// Project: 	   RenewFitness
// File:    	   snack_bar
// Path:    	   lib/utils/dialogs/snack_bar.dart
// Author:       Ali Akbar
// Date:        05-09-24 17:08:40 -- Thursday
// Description:

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../constants/app_theme.dart';

class CustomSnack {
  static void _drawSnack(
    String title,
    String message, {
    FlushbarPosition? position,
    int? durationnInSeconds,
    Color? titleColor,
    Color? messageColor,
    Color? iconColor,
    required IconData iconData,
    Function(Flushbar<dynamic>)? onTap,
  }) {
    Flushbar(
      margin: const EdgeInsets.all(10),
      title: title,
      message: message,
      flushbarPosition: position ?? FlushbarPosition.BOTTOM,
      duration: Duration(seconds: durationnInSeconds ?? 3),
      backgroundColor: Colors.white,
      titleColor: titleColor ?? Colors.black,
      messageColor: messageColor ?? Colors.black,
      flushbarStyle: FlushbarStyle.FLOATING,
      animationDuration: const Duration(milliseconds: 500),
      onTap: onTap,
      boxShadows: [
        BoxShadow(
          color: Colors.grey.withValues(alpha: 0.3),
          spreadRadius: 3,
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ],
      icon: Icon(iconData, color: iconColor),
    ).show(navKey.currentContext!);
  }

  static void error(
    String? title,
    String message, {
    FlushbarPosition? position,
    int? durationnInSeconds,
    Function(Flushbar<dynamic>)? onTap,
  }) =>
      _drawSnack(
        title ?? "Error",
        message,
        iconData: Icons.bug_report_rounded,
        durationnInSeconds: durationnInSeconds,
        position: position,
        iconColor: Colors.red,
        titleColor: Colors.red,
        onTap: onTap,
      );

  static void warning(
    String? title,
    String message, {
    FlushbarPosition? position,
    int? durationnInSeconds,
    Function(Flushbar<dynamic>)? onTap,
  }) =>
      _drawSnack(
        title ?? "Warning",
        message,
        iconData: Icons.warning_outlined,
        position: position,
        durationnInSeconds: durationnInSeconds,
        iconColor: const Color.fromARGB(255, 191, 172, 6),
        titleColor: const Color.fromARGB(255, 191, 172, 6),
        onTap: onTap,
      );

  static void success(
    String? title,
    String message, {
    FlushbarPosition? position,
    int? durationnInSeconds,
    Function(Flushbar<dynamic>)? onTap,
  }) =>
      _drawSnack(
        title ?? "Success",
        message,
        iconData: Icons.done,
        durationnInSeconds: durationnInSeconds,
        position: position,
        iconColor: Colors.green,
        titleColor: Colors.green,
        onTap: onTap,
      );

  static void notification(
    String? title,
    String message, {
    FlushbarPosition? position,
    int? durationnInSeconds,
    Function(Flushbar<dynamic>)? onTap,
  }) =>
      _drawSnack(
        title ?? "Notification",
        message,
        iconData: Icons.notifications,
        durationnInSeconds: durationnInSeconds,
        iconColor: AppTheme.primaryColor1,
        titleColor: AppTheme.primaryColor1,
        onTap: onTap,
        position: position,
      );
}

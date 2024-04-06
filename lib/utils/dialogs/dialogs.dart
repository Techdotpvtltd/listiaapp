import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';

import '../../main.dart';
import '../constants/constants.dart';
import 'rounded_button.dart';

class CustomDilaogs {
  void _genericDilaog({
    required IconData icon,
    required String title,
    required String message,
    required Widget bottomWidget,
    bool barrierDismissible = true,
    Color iconColor = AppTheme.primaryColor2,
    Color titleColor = AppTheme.primaryColor2,
  }) {
    showDialog(
      context: navKey.currentContext!,
      barrierDismissible: barrierDismissible,
      builder: (context) => AlertDialog(
        surfaceTintColor: Colors.transparent,
        content: Container(
          height: SCREEN_HEIGHT * 0.40,
          width: SCREEN_WIDTH,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 85,
                  height: 85,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF6F8FE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 40,
                    color: iconColor,
                  ),
                ),
                gapH16,
                Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans().copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                gapH6,
                Text(
                  message,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF868686),
                  ),
                ),
                gapH16,
                bottomWidget,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void errorBox({String? message}) {
    _genericDilaog(
      icon: Icons.close,
      title: "Error",
      titleColor: Colors.red,
      message: message ?? "Error",
      iconColor: Colors.red,
      bottomWidget: RoundedButton(
        title: "Close",
        height: 50,
        onPressed: () {
          Navigator.of(navKey.currentContext!).pop();
        },
      ),
    );
  }

  void alertBox({
    String? message,
    String? title,
    String? negativeTitle,
    String? positiveTitle,
    VoidCallback? onNegativePressed,
    VoidCallback? onPositivePressed,
    IconData? icon,
    bool showNegative = true,
  }) {
    _genericDilaog(
      icon: icon ?? Icons.warning,
      title: title ?? "Alert!",
      message: message ?? "Alet",
      bottomWidget: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RoundedButton(
            title: positiveTitle ?? "Done",
            height: 44,
            textSize: 12,
            onPressed: () {
              Navigator.of(navKey.currentContext!).pop();
              if (onPositivePressed != null) {
                onPositivePressed();
              }
            },
          ),
          if (showNegative) gapH6,
          if (showNegative)
            RoundedButton(
              title: negativeTitle ?? "Cancel",
              withBorderOnly: true,
              height: 44,
              textSize: 12,
              onPressed: onNegativePressed ??
                  () {
                    Navigator.of(navKey.currentContext!).pop();
                  },
            ),
        ],
      ),
    );
  }

  void deleteBox(
      {required String title,
      required String message,
      required VoidCallback onPositivePressed}) {
    alertBox(
      title: title,
      message: message,
      onPositivePressed: onPositivePressed,
      positiveTitle: "Delete",
      icon: Icons.delete,
    );
  }

  void successBox({
    String? title,
    required String message,
    VoidCallback? onPositivePressed,
    String? positiveTitle,
    bool barrierDismissible = true,
  }) {
    _genericDilaog(
      icon: Icons.check,
      title: title ?? "Success",
      barrierDismissible: barrierDismissible,
      message: message,
      bottomWidget: RoundedButton(
        title: positiveTitle ?? "Done",
        height: 50,
        onPressed: () {
          Navigator.of(navKey.currentContext!).pop();
          if (onPositivePressed != null) {
            onPositivePressed();
          }
        },
      ),
    );
  }
}

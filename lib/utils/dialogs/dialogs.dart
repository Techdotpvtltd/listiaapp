import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';

import '../../main.dart';
import '../../screens/components/custom_button.dart';
import '../../screens/components/custom_title_textfiled.dart';
import '../../screens/components/paddings.dart';
import '../constants/constants.dart';
import '../extensions/navigation_service.dart';
import 'rounded_button.dart';

class CustomDialogs {
  void _genericDialog({
    Widget? child,
  }) {
    showDialog(
      context: navKey.currentContext!,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: child,
      ),
    );
  }

  void _genericAlertDilaog({
    required IconData icon,
    required String title,
    required String message,
    required Widget bottomWidget,
    bool barrierDismissible = true,
    int maxSubLines = 3,
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
                  maxLines: maxSubLines,
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
    _genericAlertDilaog(
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
    _genericAlertDilaog(
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
    VoidCallback? onNegativePressed,
    String? positiveTitle,
    String? negativeTitle,
    bool barrierDismissible = true,
  }) {
    _genericAlertDilaog(
      icon: Icons.check,
      title: title ?? "Success",
      barrierDismissible: barrierDismissible,
      message: message,
      maxSubLines: 6,
      bottomWidget: Column(
        children: [
          Column(
            children: [
              RoundedButton(
                title: positiveTitle ?? "Done",
                height: 50,
                onPressed: () {
                  Navigator.of(navKey.currentContext!).pop();
                  if (onPositivePressed != null) {
                    onPositivePressed();
                  }
                },
              ),
              if (negativeTitle != null) gapH6,
              if (negativeTitle != null)
                RoundedButton(
                  title: negativeTitle,
                  height: 50,
                  onPressed: () {
                    Navigator.of(navKey.currentContext!).pop();
                    if (onNegativePressed != null) {
                      onNegativePressed();
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }

  void showTextField({
    required String title,
    required String tfHint,
    required Function(String) onDone,
    required String buttonTitle,
  }) {
    final TextEditingController controller = TextEditingController();
    final FocusNode focusNode = FocusNode(canRequestFocus: true);
    focusNode.requestFocus();
    _genericDialog(
      child: Container(
        height: SCREEN_HEIGHT * 0.4,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: HVPadding(
          verticle: 0,
          horizontal: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              gapH20,
              CustomTextFiled(
                controller: controller,
                hintText: tfHint,
                focusNode: focusNode,
                onSubmitted: (value) {
                  onDone(value);
                  focusNode.requestFocus();
                },
              ),
              gapH20,
              CustomButton(
                title: buttonTitle,
                onPressed: () {
                  onDone(controller.text);
                  controller.clear();
                  focusNode.requestFocus();
                },
              ),
              gapH10,
              CustomButton(
                title: "Close",
                onPressed: () {
                  NavigationService.back();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_theme.dart';
import '../constants/constants.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    this.width,
    this.height,
    required this.title,
    required this.onPressed,
    this.textSize,
    this.withBorderOnly = false,
    this.isLoading = false,
    this.loadingText,
    this.buttonColor,
  });

  final double? width;
  final double? height;
  final String title;
  final Function() onPressed;
  final double? textSize;
  final bool withBorderOnly;
  final bool isLoading;
  final String? loadingText;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(
          Size(
            width ?? double.infinity,
            height ?? 60,
          ),
        ),
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        side: WidgetStatePropertyAll(BorderSide(
            color: withBorderOnly
                ? buttonColor ?? AppTheme.primaryColor2
                : Colors.transparent)),
        backgroundColor: WidgetStatePropertyAll(
          withBorderOnly
              ? Colors.transparent
              : buttonColor ?? AppTheme.primaryColor2,
        ),
      ),
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
                gapW10,
                Text(
                  loadingText ?? "",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w700,
                    fontSize: textSize ?? 16,
                    color: withBorderOnly
                        ? buttonColor ?? AppTheme.primaryColor2
                        : Colors.white,
                  ),
                )
              ],
            )
          : Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: textSize ?? 16,
                color: withBorderOnly
                    ? buttonColor ?? AppTheme.primaryColor2
                    : Colors.white,
              ),
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/utils/constants/constants.dart';

import '../../utils/constants/app_theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width,
    this.height,
    this.isEnabled = true,
    this.isLoading = false,
    this.onlyBorder = false,
    this.textColor,
    this.backgroundColor,
  });
  final String title;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool isEnabled;
  final bool isLoading;
  final bool onlyBorder;
  final Color? textColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? SCREEN_WIDTH,
      height: height ?? 48,
      decoration: BoxDecoration(
        gradient: onlyBorder || !isEnabled || backgroundColor != null
            ? null
            : AppTheme.primaryLinearGradient,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        color: !isEnabled ? Colors.grey[400] : backgroundColor,
        border: Border.all(
            color: onlyBorder && isEnabled
                ? AppTheme.primaryColor1
                : Colors.transparent),
      ),
      child: ElevatedButton(
        onPressed: !isLoading && isEnabled ? onPressed : null,
        style: const ButtonStyle(
          surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
          shadowColor: WidgetStatePropertyAll(Colors.transparent),
          backgroundColor: WidgetStatePropertyAll(Colors.transparent),
        ),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: (onlyBorder || !isEnabled)
                      ? AppTheme.primaryColor2
                      : Colors.white,
                ),
              )
            : Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  color: !isEnabled
                      ? Colors.black
                      : onlyBorder
                          ? AppTheme.primaryColor2
                          : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';

import '../../utils/constants/constants.dart';

class CustomTextFiled extends StatefulWidget {
  const CustomTextFiled({
    super.key,
    this.titleText,
    required this.hintText,
    this.controller,
    this.suffixWidget,
    this.onTFTap,
    this.errorText,
    this.isReadyOnly = false,
    this.keyboardType,
    this.prefixWidget,
    this.maxLines = 1,
    this.minLines,
    this.fieldId,
    this.errorCode,
    this.onSubmitted,
  });
  final String? titleText;
  final String hintText;
  final TextEditingController? controller;
  final Widget? suffixWidget;
  final Widget? prefixWidget;
  final VoidCallback? onTFTap;
  final String? errorText;
  final bool isReadyOnly;
  final TextInputType? keyboardType;
  final int maxLines;
  final int? minLines;
  final int? fieldId;
  final int? errorCode;
  final Function(String)? onSubmitted;

  @override
  State<CustomTextFiled> createState() => _CustomTextFiledState();
}

class _CustomTextFiledState extends State<CustomTextFiled> {
  late bool _isReadOnly;
  bool isFocused = false;
  final FocusNode textFieldFocus = FocusNode();
  bool isShowPassword = true;

  IconData? getTextFiledPrefixIcon() {
    switch (widget.keyboardType) {
      case TextInputType.emailAddress:
        return Icons.email_outlined;
      case TextInputType.visiblePassword:
        return Icons.lock_open_outlined;
      case TextInputType.phone:
        return Icons.phone_outlined;
      case TextInputType.name:
        return Icons.person_outline;
      default:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _isReadOnly = widget.isReadyOnly;

    textFieldFocus.addListener(() {
      setState(() {
        isFocused = textFieldFocus.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    textFieldFocus.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.titleText != null,
          child: Text(
            widget.titleText ?? "",
            style: GoogleFonts.plusJakartaSans(
              color: AppTheme.titleColor1,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (widget.titleText != null) gapH10,
        TextField(
          focusNode: textFieldFocus,
          controller: widget.controller,
          obscureText: widget.keyboardType == TextInputType.visiblePassword &&
              isShowPassword,
          onSubmitted: (value) {
            if (widget.onSubmitted != null) {
              widget.onSubmitted!(value);
            }
          },
          onTap: () {
            if (widget.onTFTap != null) {
              widget.onTFTap!();
            }
          },
          keyboardType: widget.keyboardType,
          readOnly: _isReadOnly,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          style: GoogleFonts.plusJakartaSans(
            color: AppTheme.titleColor1,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 23, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  (widget.maxLines > 1) ? 12 : 124,
                ),
              ),
              borderSide: const BorderSide(color: Colors.transparent, width: 0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  (widget.maxLines > 1) ? 12 : 124,
                ),
              ),
              borderSide:
                  const BorderSide(color: AppTheme.primaryColor2, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  (widget.maxLines > 1) ? 12 : 124,
                ),
              ),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  (widget.maxLines > 1) ? 12 : 124,
                ),
              ),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            filled: true,
            fillColor: const Color(0xFFF2F2F2),
            hintText: widget.hintText,
            hintStyle: GoogleFonts.plusJakartaSans(
              color:
                  isFocused ? AppTheme.primaryColor2 : const Color(0xFF838383),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
            errorText:
                (widget.fieldId == widget.errorCode && widget.errorText != null)
                    ? widget.errorText
                    : null,
            errorStyle: GoogleFonts.plusJakartaSans(
              color: Colors.red,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            suffixIcon: widget.keyboardType == TextInputType.visiblePassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isShowPassword = !isShowPassword;
                      });
                    },
                    icon: Icon(
                      isShowPassword ? Icons.visibility : Icons.visibility_off,
                      color: isFocused
                          ? AppTheme.primaryColor2
                          : const Color(0xFF838383),
                    ),
                  )
                : widget.suffixWidget,
            prefixIcon: widget.prefixWidget ??
                Icon(
                  getTextFiledPrefixIcon(),
                  color: isFocused
                      ? AppTheme.primaryColor2
                      : const Color(0xFF838383),
                ),
          ),
        ),
      ],
    );
  }
}

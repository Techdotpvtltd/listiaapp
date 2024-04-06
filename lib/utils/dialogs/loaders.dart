import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import '../constants/app_theme.dart';

class Loader {
  static final Loader _intsance = Loader._internal();
  Loader._internal();
  factory Loader() {
    return _intsance;
  }

  final List<GlobalKey> _alertKeys = [];

  void show(
      {String? withText,
      bool barrierDismissible = false,
      GlobalKey? alertKey}) {
    hide(); // Remove If any existed
    final key = alertKey ?? GlobalKey();
    _alertKeys.add(key);

    showDialog(
      context: navKey.currentContext!,
      barrierDismissible: barrierDismissible,
      builder: (alertContext) {
        return AlertDialog(
          key: key,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 100),
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          content: Container(
            height: 160,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const CircularProgressIndicator(
                  color: AppTheme.primaryColor2,
                ),
                Text(
                  withText == "" || withText == null ? "Loading.." : withText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void hide() {
    for (GlobalKey key in _alertKeys) {
      if (key.currentContext != null) {
        Navigator.pop(key.currentContext!);
      }
    }
  }
}

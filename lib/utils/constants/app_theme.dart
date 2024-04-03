import 'package:flutter/material.dart';

class AppTheme {
  /// Primary Color 1
  static const Color primaryColor1 = Color(0xFF30A94A);

  /// Primary Color 2
  static const Color primaryColor2 = Color(0xFF238832);

  static const LinearGradient primaryLinearGradient = LinearGradient(
    begin: Alignment(0.99, -0.10),
    end: Alignment(-0.99, 0.1),
    colors: [Color(0xFF228832), Color(0xFF30A94A)],
  );
}

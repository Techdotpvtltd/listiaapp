// Project: 	   listi_shop
// File:    	   round_button
// Path:    	   lib/screens/main/components/round_button.dart
// Author:       Ali Akbar
// Date:        04-04-24 13:19:00 -- Thursday
// Description:

import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {super.key,
      required this.onTap,
      required this.icon,
      this.backgroundColor});
  final VoidCallback onTap;
  final Widget icon;
  final Color? backgroundColor;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      style: ButtonStyle(
        shadowColor: const WidgetStatePropertyAll(Colors.transparent),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        fixedSize: const WidgetStatePropertyAll(Size(49, 49)),
        backgroundColor: WidgetStatePropertyAll(
          backgroundColor ?? Colors.white.withOpacity(0.07),
        ),
      ),
      icon: icon,
    );
  }
}

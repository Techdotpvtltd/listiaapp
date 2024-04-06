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
        shadowColor: const MaterialStatePropertyAll(Colors.transparent),
        surfaceTintColor: const MaterialStatePropertyAll(Colors.transparent),
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        fixedSize: const MaterialStatePropertyAll(Size(49, 49)),
        backgroundColor: MaterialStatePropertyAll(
          backgroundColor ?? Colors.white.withOpacity(0.07),
        ),
      ),
      icon: icon,
    );
  }
}

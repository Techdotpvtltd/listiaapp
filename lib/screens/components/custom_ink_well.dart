// Project: 	   listi_shop
// File:    	   custom_ink_well
// Path:    	   lib/screens/components/custom_ink_well.dart
// Author:       Ali Akbar
// Date:        04-04-24 20:03:33 -- Thursday
// Description:

import 'package:flutter/material.dart';

class CustomInkWell extends StatelessWidget {
  const CustomInkWell({super.key, required this.child, required this.onTap});
  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
      hoverColor: Colors.transparent,
      child: child,
    );
  }
}

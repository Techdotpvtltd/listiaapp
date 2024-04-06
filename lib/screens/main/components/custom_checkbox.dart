// Project: 	   listi_shop
// File:    	   custom_checkbox
// Path:    	   lib/screens/main/components/custom_checkbox.dart
// Author:       Ali Akbar
// Date:        04-04-24 21:05:04 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({super.key, this.isChecked = false});
  final bool isChecked;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(
          color: isChecked ? AppTheme.primaryColor2 : const Color(0xFFDEDEDE),
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check,
        size: 10,
        color: isChecked ? AppTheme.primaryColor2 : Colors.transparent,
      ),
    );
  }
}

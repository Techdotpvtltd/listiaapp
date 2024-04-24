// Project: 	   listi_shop
// File:    	   string_extension
// Path:    	   lib/utils/extensions/string_extension.dart
// Author:       Ali Akbar
// Date:        24-04-24 13:51:56 -- Wednesday
// Description:

extension CustomStr on String {
  bool isValidString() {
    RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
    return regex.hasMatch(this);
  }
}

// Project: 	   listi_shop
// File:    	   string_extension
// Path:    	   lib/utils/extensions/string_extension.dart
// Author:       Ali Akbar
// Date:        24-04-24 13:51:56 -- Wednesday
// Description:

extension CustomStr on String {
  bool isValidString() {
    RegExp regex = RegExp(r'^\s*[a-zA-Z0-9]+\s*(?: [a-zA-Z0-9]+)*\s*$');
    return regex.hasMatch(this);
  }

  bool isNumeric() {
    try {
      final _ = double.parse(this);
    } on FormatException {
      return false;
    }
    return true;
  }

  String capitalizeFirstCharacter() {
    List<String> words = split(" "); // Split the string into words
    List<String> capitalizedWords = [];

    for (String word in words) {
      if (word.isNotEmpty) {
        String capitalizedWord =
            word[0].toUpperCase() + word.substring(1).toLowerCase();
        capitalizedWords.add(capitalizedWord);
      }
    }

    return capitalizedWords
        .join(" "); // Join the words back into a single string
  }

  bool isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }
}

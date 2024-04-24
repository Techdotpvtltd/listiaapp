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
}

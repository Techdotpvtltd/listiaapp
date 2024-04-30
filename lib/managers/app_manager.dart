// Project: 	   listi_shop
// File:    	   app_manager
// Path:    	   lib/managers/app_manager.dart
// Author:       Ali Akbar
// Date:        30-04-24 19:26:07 -- Tuesday
// Description:

class AppManager {
  static final AppManager _instance = AppManager._internal();
  AppManager._internal();
  factory AppManager() => _instance;

  bool isActiveSubscription = false;
}

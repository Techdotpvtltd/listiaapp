// Project: 	   muutsch
// File:    	   local_storage_services
// Path:    	   lib/services/local_storage_services/local_storage_services.dart
// Author:       Ali Akbar
// Date:        09-06-24 11:54:38 -- Sunday
// Description:

import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageServices {
  Future<void> saveFirstLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("FIRST_TIME_LOGIN", true);
  }

  Future<bool> getFirstLogin() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("FIRST_TIME_LOGIN") ?? false;
  }

  /// Notification Settings
  Future<void> saveEnsureNotificationEnabled(bool value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("ensureNotificationEnabled", value);
  }

  Future<bool> getEnsureNotificationEnabled() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("ensureNotificationEnabled") ?? false;
  }

  Future<void> saveAllNotificationSetting(bool value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("allNotification", value);
  }

  Future<bool> getAllNotificationSetting() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("allNotification") ?? true;
  }

  Future<void> saveInAppNotificationSetting(bool value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool("inAppNotification", value);
  }

  Future<bool> getInAppNotificationSetting() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool("inAppNotification") ?? true;
  }

  /// Clear Alls
  Future<void> clearAll() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

// Project: 	   listi_shop
// File:    	   notification_states
// Path:    	   lib/blocs/notification/notification_states.dart
// Author:       Ali Akbar
// Date:        13-03-25 17:47:14 -- Thursday
// Description:

import 'package:listi_shop/exceptions/app_exceptions.dart';

abstract class NotificationStates {
  final bool isLoading;
  final List notifications;
  final AppException? error;
  NotificationStates(
      {this.isLoading = false, required this.notifications, this.error});
}

class NotificationStatesInitial extends NotificationStates {
  NotificationStatesInitial({required super.notifications});
}

class NotificationStatesFetch extends NotificationStates {
  NotificationStatesFetch(
      {super.isLoading, required super.notifications, super.error});
}

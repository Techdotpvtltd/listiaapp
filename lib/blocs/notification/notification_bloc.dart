// Project: 	   listi_shop
// File:    	   notification_bloc
// Path:    	   lib/blocs/notification/notification_bloc.dart
// Author:       Ali Akbar
// Date:        13-03-25 17:51:11 -- Thursday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listi_shop/blocs/notification/notification_event.dart';
import 'package:listi_shop/blocs/notification/notification_states.dart';
import 'package:listi_shop/exceptions/app_exceptions.dart';
import 'package:listi_shop/repos/share_repo.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationStates> {
  NotificationBloc() : super(NotificationStatesInitial(notifications: [])) {
    on<NotificationEventFetch>(
      (event, emit) async {
        try {
          emit(NotificationStatesFetch(isLoading: true, notifications: []));
          final requests = await ShareRepo().fetchRequestsFor();
          emit(NotificationStatesFetch(
              isLoading: false, notifications: requests));
          emit(NotificationStatesFetch(
              isLoading: false, notifications: requests));
        } on AppException catch (e) {
          emit(NotificationStatesFetch(
              isLoading: false, notifications: [], error: e));
        }
      },
    );
  }

  void fetch() {
    add(NotificationEventFetch());
  }
}

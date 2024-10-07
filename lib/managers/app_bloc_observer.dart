// Project: 	   balanced_workout
// File:    	   app_bloc_observer
// Path:    	   lib/app/app_bloc_observer.dart
// Author:       Ali Akbar
// Date:        08-08-24 15:04:28 -- Thursday
// Description:

import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // log("[${bloc.runtimeType}]",
    //     name: change.nextState.runtimeType.toString(), time: DateTime.now());
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    log(
      time: DateTime.now(),
      'OnError: ',
      name: bloc.runtimeType.toString(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    log(time: DateTime.now(), 'Closed', name: bloc.runtimeType.toString());
  }

  @override
  void onCreate(BlocBase bloc) {
    log(time: DateTime.now(), 'Created', name: bloc.runtimeType.toString());
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    log(time: DateTime.now(), '', name: event.runtimeType.toString());
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    log("[${transition.event.runtimeType}] [${bloc.runtimeType}]",
        name: transition.nextState.runtimeType.toString(),
        time: DateTime.now());
  }
}

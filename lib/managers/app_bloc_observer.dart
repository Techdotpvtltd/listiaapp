import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // debugPrint(
    // 'PreviousState: ${change.currentState.runtimeType} CurrentState: ${change.nextState.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    debugPrint('onError Occured: ${bloc.runtimeType} => $error $stackTrace');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    debugPrint('${bloc.runtimeType} closed');
  }

  @override
  void onCreate(BlocBase bloc) {
    debugPrint('${bloc.runtimeType} created');
    super.onCreate(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // debugPrint('${event.runtimeType} from ${bloc.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    debugPrint(
        "\n================= ${bloc.runtimeType}  =======================");
    debugPrint(
        'Event: ${transition.event.runtimeType}\nCurrent State: ${transition.currentState.runtimeType} ---- Next State: ${transition.nextState.runtimeType}');
    debugPrint("================= End =====================\n");
  }
}

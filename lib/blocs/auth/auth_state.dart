// Project: 	   listi_shop
// File:    	   auth_state
// Path:    	   lib/blocs/auth/auth_state.dart
// Author:       Ali Akbar
// Date:        02-04-24 20:26:13 -- Tuesday
// Description:

abstract class AuthState {
  final bool isLoading;
  final String loadingText;

  AuthState({this.isLoading = false, this.loadingText = "Processing"});
}

/// Initial State
class AuthStateInitial extends AuthState {}

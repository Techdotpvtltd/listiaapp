// Project: 	   listi_shop
// File:    	   auth_bloc
// Path:    	   lib/blocs/auth/auth_bloc.dart
// Author:       Ali Akbar
// Date:        02-04-24 20:27:42 -- Tuesday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listi_shop/blocs/auth/auth_event.dart';
import 'package:listi_shop/blocs/auth/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateInitial());
}

// Project: 	   listi_shop
// File:    	   main
// Path:    	   lib/main.dart
// Author:       Ali Akbar
// Date:        02-04-24 20:20:54 -- Tuesday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listi_shop/blocs/auth/auth_bloc.dart';
import 'package:listi_shop/screens/onboarding/splash_screen.dart';

void main() {
  runApp(const _WasteApp());
}

class _WasteApp extends StatelessWidget {
  const _WasteApp();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: const _WasteMaterialApp(),
    );
  }
}

class _WasteMaterialApp extends StatelessWidget {
  const _WasteMaterialApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navKey,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

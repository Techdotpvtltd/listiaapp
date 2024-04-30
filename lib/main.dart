// Project: 	   listi_shop
// File:    	   main
// Path:    	   lib/main.dart
// Author:       Ali Akbar
// Date:        02-04-24 20:20:54 -- Tuesday
// Description:

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listi_shop/blocs/auth/auth_bloc.dart';
import 'package:listi_shop/blocs/drawer_cubit/drawer_cubit.dart';
import 'package:listi_shop/blocs/user/user_bloc.dart';
import 'package:listi_shop/managers/app_bloc_observer.dart';
import 'package:listi_shop/screens/onboarding/splash_screen.dart';

import 'blocs/category/category_bloc.dart';
import 'blocs/item/item_bloc.dart';
import 'blocs/list/list_bloc.dart';
import 'blocs/share_user/share_user_bloc.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = AppBlocObserver();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //  1 - Ensure firebase app is initialized if starting from background/terminated state
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Bloc.observer = AppBlocObserver();
  runApp(const _WasteApp());
}

class _WasteApp extends StatelessWidget {
  const _WasteApp();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => DrawerCubit()),
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => ListBloc()),
        BlocProvider(create: (context) => ItemBloc()),
        BlocProvider(create: (context) => CategoryBloc()),
        BlocProvider(create: (context) => ShareUserBloc()),
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

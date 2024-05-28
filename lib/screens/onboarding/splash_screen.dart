// Project: 	   listi_shop
// File:    	   splash_screen
// Path:    	   lib/screens/onboarding/splash_screen.dart
// Author:       Ali Akbar
// Date:        02-04-24 20:22:54 -- Tuesday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listi_shop/blocs/auth/auth_bloc.dart';
import 'package:listi_shop/blocs/auth/auth_state.dart';
import 'package:listi_shop/screens/main/home_drawer.dart';
import 'package:listi_shop/screens/onboarding/get_started_screen.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

import '../../blocs/auth/auth_event.dart';
import '../../utils/constants/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void triggerSplashEvent(AuthBloc bloc) {
    bloc.add(AuthEventSplashAction());
  }

  @override
  void initState() {
    super.initState();
    triggerSplashEvent(context.read<AuthBloc>());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateSplashActionDone) {
          NavigationService.offAll(const HomeDrawer());
        }

        if (state is AuthStateLoginRequired) {
          Future.delayed(const Duration(seconds: 1), () {
            NavigationService.off(const GetStartedScreen());
          });
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                AppAssets.background,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(AppAssets.logo),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

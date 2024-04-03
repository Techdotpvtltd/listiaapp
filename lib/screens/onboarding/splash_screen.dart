// Project: 	   listi_shop
// File:    	   splash_screen
// Path:    	   lib/screens/onboarding/splash_screen.dart
// Author:       Ali Akbar
// Date:        02-04-24 20:22:54 -- Tuesday
// Description:

import 'package:flutter/material.dart';
import 'package:listi_shop/screens/onboarding/get_started_screen.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void triggerSplashEvent() async {
    await Future.delayed(const Duration(seconds: 3));
    NavigationService.off(const GetStartedScreen());
  }

  @override
  void initState() {
    super.initState();
    triggerSplashEvent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppAssets.background,
            fit: BoxFit.cover,
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: SvgPicture.asset(AppAssets.logo),
            ),
          ),
        ],
      ),
    );
  }
}

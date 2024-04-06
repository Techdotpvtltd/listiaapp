// Project: 	   listi_shop
// File:    	   auth_scaffold
// Path:    	   lib/screens/onboarding/components/auth_scaffold.dart
// Author:       Ali Akbar
// Date:        03-04-24 15:21:46 -- Wednesday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';

class AuthScaffold extends StatelessWidget {
  const AuthScaffold(
      {super.key,
      required this.asset,
      required this.title,
      required this.subTitle,
      required this.child});
  final String asset;
  final String title;
  final String subTitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: SCREEN_HEIGHT * 0.5,
            width: SCREEN_WIDTH,
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryLinearGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(76),
                bottomRight: Radius.circular(76),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      asset,
                      height: constraints.maxHeight * 0.60,
                    ),
                    gapH10,
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                    gapH6,
                    Text(
                      subTitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    gapH20,
                  ],
                );
              },
            ),
          ),
          child,
        ],
      ),
    );
  }
}

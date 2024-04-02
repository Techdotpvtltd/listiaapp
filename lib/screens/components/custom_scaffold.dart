// Project: 	   listi_shop
// File:    	   custom_scaffold
// Path:    	   lib/screens/components/custom_scaffold.dart
// Author:       Ali Akbar
// Date:        02-04-24 20:36:11 -- Tuesday
// Description:

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

import '../../utils/constants/app_assets.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold(
      {super.key, required this.title, required this.body, this.actions});
  final String title;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          AppAssets.background,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: AppBar(
                title: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
                actions: actions,
                leadingWidth: 80,
                leading: IconButton(
                  onPressed: () {
                    NavigationService.back();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      const Color(0xffffffff).withOpacity(0.07),
                    ),
                  ),
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
            body: Container(
              height: SCREEN_HEIGHT,
              width: SCREEN_WIDTH,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: body,
            ),
          ),
        ),
      ],
    );
  }
}

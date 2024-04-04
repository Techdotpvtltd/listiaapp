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
      {super.key,
      required this.title,
      this.body,
      this.actions,
      this.backButtonPressed,
      this.backButtonIcon,
      this.middleWidget,
      this.floatingActionButton,
      this.endDrawer,
      this.floatingActionButtonLocation});
  final String title;
  final Widget? body;
  final List<Widget>? actions;
  final VoidCallback? backButtonPressed;
  final Widget? backButtonIcon;
  final Widget? middleWidget;
  final Widget? floatingActionButton;
  final Widget? endDrawer;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

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
            key: scaffoldkey,
            backgroundColor: Colors.transparent,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            endDrawer: endDrawer,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(60),
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
                  onPressed: backButtonPressed ??
                      () {
                        NavigationService.back();
                      },
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      const Color(0xffffffff).withOpacity(0.07),
                    ),
                  ),
                  icon: backButtonIcon ??
                      const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
            body: Column(
              children: [
                if (middleWidget != null) middleWidget!,
                Expanded(
                  child: Container(
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}

final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

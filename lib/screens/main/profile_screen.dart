// Project: 	   listi_shop
// File:    	   profile_screen
// Path:    	   lib/screens/main/profile_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 16:48:30 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/avatar_widget.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/screens/main/edit_profile_screen.dart';
import 'package:listi_shop/screens/onboarding/forgot_screen.dart';
import 'package:listi_shop/screens/onboarding/splash_screen.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

import '../../blocs/drawer_cubit/drawer_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Profile",
      backButtonIcon: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      backButtonPressed: () {
        context.read<DrawerCubit>().openDrawer();
      },
      middleWidget: Container(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 36),
        child: Column(
          children: [
            /// Profile Widget
            SizedBox(
              width: 100,
              height: 80,
              child: Stack(
                children: [
                  const AvatarWidget(
                    width: 80,
                    height: 80,
                    backgroundColor: AppTheme.primaryColor2,
                  ),
                  Positioned(
                    right: -0,
                    bottom: 8,
                    child: SizedBox(
                      width: 26,
                      height: 26,
                      child: IconButton(
                        onPressed: () {
                          NavigationService.go(const EditProfileScreen());
                        },
                        style: const ButtonStyle(
                          padding: MaterialStatePropertyAll(EdgeInsets.zero),
                          visualDensity: VisualDensity.compact,
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.white),
                        ),
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: AppTheme.primaryColor1,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            gapH8,

            /// Name Text
            Text(
              "Ali Akbar",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            /// Email Text
            gapH8,
            Text(
              "Abc1231234@gmai.com",
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
      body: HorizontalPadding(
        child: Column(
          children: [
            SizedBox(height: SCREEN_HEIGHT * 0.08),
            _CustomButton(
              "Change password",
              () {
                NavigationService.go(const ForgotPasswordScreen());
              },
            ),
            gapH20,
            _CustomButton(
              "Subscription",
              () {},
            ),
            gapH20,
            _CustomButton(
              "Contact us",
              () {},
            ),
            const Spacer(),
            CustomButton(
                title: "Logout",
                onPressed: () {
                  NavigationService.offAll(const SplashScreen());
                }),
            gapH30,
          ],
        ),
      ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  const _CustomButton(this.title, this.onTap);
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        padding:
            const EdgeInsets.only(left: 34, right: 10, bottom: 14, top: 14),
        decoration: const BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadiusDirectional.all(Radius.circular(66)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF606060),
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: AppTheme.primaryColor1,
            ),
          ],
        ),
      ),
    );
  }
}

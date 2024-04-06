// Project: 	   listi_shop
// File:    	   login_screen
// Path:    	   lib/screens/onboarding/login_screen.dart
// Author:       Ali Akbar
// Date:        03-04-24 14:37:57 -- Wednesday
// Description:

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/screens/main/home_drawer.dart';
import 'package:listi_shop/screens/onboarding/components/auth_scaffold.dart';
import 'package:listi_shop/screens/onboarding/forgot_screen.dart';
import 'package:listi_shop/screens/onboarding/sign_up_screen.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: "Sign In",
      subTitle: "Please login to continue",
      asset: AppAssets.loginAsset,
      child: Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 38, left: 29, right: 29, bottom: 10),
            child: Column(
              children: [
                /// Email TextFiled
                const CustomTextFiled(
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                gapH12,

                /// Password TextFiled
                const CustomTextFiled(
                  hintText: "Password",
                  keyboardType: TextInputType.visiblePassword,
                ),

                /// Forgot Password Button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      NavigationService.go(const ForgotPasswordScreen());
                    },
                    style: const ButtonStyle(
                      shadowColor: MaterialStatePropertyAll(Colors.transparent),
                      splashFactory: NoSplash.splashFactory,
                      overlayColor:
                          MaterialStatePropertyAll(Colors.transparent),
                      surfaceTintColor:
                          MaterialStatePropertyAll(Colors.transparent),
                      padding: MaterialStatePropertyAll(EdgeInsets.zero),
                      visualDensity: VisualDensity.compact,
                    ),
                    child: Text(
                      "Forgot your password?",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.primaryColor2,
                      ),
                    ),
                  ),
                ),
                gapH50,
                gapH20,

                /// Login Button
                CustomButton(
                    title: "Login",
                    onPressed: () {
                      NavigationService.offAll(const HomeDrawer());
                    }),
                gapH20,

                /// Don't have Account Button
                Text.rich(
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppTheme.titleColor1.withOpacity(0.67),
                  ),
                  TextSpan(
                    text: "Don’t have an account? ",
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            NavigationService.offAll(const SignUpScreen());
                          },
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: AppTheme.primaryColor2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Project: 	   listi_shop
// File:    	   sign_up_screen
// Path:    	   lib/screens/onboarding/sign_up_screen.dart
// Author:       Ali Akbar
// Date:        03-04-24 16:43:03 -- Wednesday
// Description:

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/screens/onboarding/components/auth_scaffold.dart';
import 'package:listi_shop/screens/onboarding/login_screen.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isAcceptedTerms = false;

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      asset: AppAssets.signupAsset,
      title: "Sign Up",
      subTitle: "Please  Sign Up to Join Us",
      child: Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 38, left: 29, right: 29, bottom: 30),
            child: Column(
              /// TextFileds
              children: [
                const CustomTextFiled(
                  hintText: "Name",
                  keyboardType: TextInputType.name,
                ),
                gapH10,
                const CustomTextFiled(
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                gapH10,
                const CustomTextFiled(
                  hintText: "Phone",
                  keyboardType: TextInputType.phone,
                ),
                gapH10,
                const CustomTextFiled(
                  hintText: "Password",
                  keyboardType: TextInputType.visiblePassword,
                ),
                gapH10,
                const CustomTextFiled(
                  hintText: "Confirm Password",
                  keyboardType: TextInputType.visiblePassword,
                ),
                gapH4,

                /// Accept Agreement Checkbox
                Row(
                  children: [
                    Checkbox(
                      visualDensity: VisualDensity.compact,
                      value: isAcceptedTerms,
                      side: const BorderSide(color: AppTheme.primaryColor2),
                      activeColor: AppTheme.primaryColor2,
                      onChanged: (val) {
                        setState(() {
                          isAcceptedTerms = val ?? false;
                        });
                      },
                    ),
                    Text.rich(
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        color: const Color(0xFF414141).withOpacity(0.67),
                      ),
                      TextSpan(
                        text: "I agree to Terms ",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            NavigationService.offAll(const LoginScreen());
                          },
                        children: [
                          TextSpan(
                            text: "and",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w400,
                              fontSize: 11,
                              color: AppTheme.titleColor1.withOpacity(0.67),
                            ),
                          ),
                          TextSpan(
                            text: " condition & privacy.",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                NavigationService.offAll(const LoginScreen());
                              },
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                gapH10,

                /// Sign up button
                CustomButton(
                  title: "Sign Up",
                  onPressed: () {},
                  isEnabled: isAcceptedTerms,
                ),
                gapH26,
                Text.rich(
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    color: AppTheme.titleColor1.withOpacity(0.67),
                  ),

                  /// Already have Account Widgets
                  TextSpan(
                    text: "Already have an account? ",
                    children: [
                      TextSpan(
                        text: "Login In",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            NavigationService.offAll(const LoginScreen());
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

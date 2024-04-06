// Project: 	   listi_shop
// File:    	   sign_up_screen
// Path:    	   lib/screens/onboarding/sign_up_screen.dart
// Author:       Ali Akbar
// Date:        03-04-24 16:43:03 -- Wednesday
// Description:

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/blocs/auth/auth_bloc.dart';
import 'package:listi_shop/blocs/auth/auth_state.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/screens/main/home_drawer.dart';
import 'package:listi_shop/screens/onboarding/components/auth_scaffold.dart';
import 'package:listi_shop/screens/onboarding/login_screen.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

import '../../blocs/auth/auth_event.dart';
import '../../utils/dialogs/dialogs.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isAcceptedTerms = false;
  bool isLoading = false;
  int? errorCode;
  String? errorMessage;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void triggerSignupEvent(AuthBloc bloc) {
    bloc.add(
      AuthEventRegistering(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
        phoneNumber: phoneController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateRegistering ||
            state is AuthStateLogging ||
            state is AuthStateRegisterFailure ||
            state is AuthStateLoginFailure ||
            state is AuthStateRegistered ||
            state is AuthStateAppleLoggedIn ||
            state is AuthStateGoogleLoggedIn ||
            state is AuthStateGoogleLogging) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is AuthStateRegisterFailure) {
            if (state.exception.errorCode != null) {
              setState(() {
                errorCode = state.exception.errorCode;
                errorMessage = state.exception.message;
              });
              return;
            }
            CustomDilaogs().errorBox(message: state.exception.message);
          }
          if (state is AuthStateRegistered ||
              state is AuthStateAppleLoggedIn ||
              state is AuthStateGoogleLoggedIn) {
            NavigationService.go(const HomeDrawer());
          }
        }
      },
      child: AuthScaffold(
        asset: AppAssets.signupAsset,
        title: "Sign Up",
        subTitle: "Please  Sign Up to Join Us",
        child: Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 38, left: 29, right: 29, bottom: 30),
              child: Column(
                /// TextFileds
                children: [
                  CustomTextFiled(
                    controller: nameController,
                    errorCode: errorCode,
                    errorText: errorMessage,
                    fieldId: 3,
                    hintText: "Name",
                    keyboardType: TextInputType.name,
                  ),
                  gapH10,
                  CustomTextFiled(
                    controller: emailController,
                    errorCode: errorCode,
                    errorText: errorMessage,
                    fieldId: 1,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  gapH10,
                  CustomTextFiled(
                    controller: phoneController,
                    errorCode: errorCode,
                    errorText: errorMessage,
                    fieldId: 1012,
                    hintText: "Phone",
                    keyboardType: TextInputType.phone,
                  ),
                  gapH10,
                  CustomTextFiled(
                    controller: passwordController,
                    errorCode: errorCode,
                    errorText: errorMessage,
                    fieldId: 2,
                    hintText: "Password",
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  gapH10,
                  CustomTextFiled(
                    controller: confirmPasswordController,
                    errorCode: errorCode,
                    errorText: errorMessage,
                    fieldId: 5,
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
                    isLoading: isLoading,
                    onPressed: () {
                      triggerSignupEvent(context.read<AuthBloc>());
                    },
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
      ),
    );
  }
}

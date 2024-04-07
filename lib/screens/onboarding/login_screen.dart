// Project: 	   listi_shop
// File:    	   login_screen
// Path:    	   lib/screens/onboarding/login_screen.dart
// Author:       Ali Akbar
// Date:        03-04-24 14:37:57 -- Wednesday
// Description:

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/blocs/auth/auth_state.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/screens/components/social_icon_button.dart';
import 'package:listi_shop/screens/main/home_drawer.dart';
import 'package:listi_shop/screens/onboarding/components/auth_scaffold.dart';
import 'package:listi_shop/screens/onboarding/forgot_screen.dart';
import 'package:listi_shop/screens/onboarding/sign_up_screen.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/dialogs/loaders.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../utils/dialogs/dialogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  int? errorCode;
  String? errorMessage;

  void triggerLoginEvent(AuthBloc bloc) {
    bloc.add(
      AuthEventPerformLogin(
          email: emailController.text, password: passwordController.text),
    );
  }

  void triggeEmailVerificationMail(AuthBloc bloc) {
    bloc.add(AuthEventSentEmailVerificationLink());
  }

  void triggerAppleLogin(AuthBloc bloc) {
    bloc.add(AuthEventAppleLogin());
  }

  void triggerGoogleLogin(AuthBloc bloc) {
    bloc.add(AuthEventGoogleLogin());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLogging ||
            state is AuthStateLoggedIn ||
            state is AuthStateLoginFailure ||
            state is AuthStateEmailVerificationRequired ||
            state is AuthStateAppleLoggedIn ||
            state is AuthStateGoogleLoggedIn ||
            state is AuthStateGoogleLogging ||
            state is AuthStateSendingMailVerification ||
            state is AuthStateSendingMailVerificationFailure ||
            state is AuthStateSentMailVerification) {
          if (state is AuthStateLogging ||
              state is AuthStateLoggedIn ||
              state is AuthStateLoginFailure ||
              state is AuthStateEmailVerificationRequired ||
              state is AuthStateAppleLoggedIn ||
              state is AuthStateGoogleLoggedIn ||
              state is AuthStateGoogleLogging) {
            setState(() {
              isLoading = state.isLoading;
            });

            if (state is AuthStateLoginFailure) {
              if (state.exception.errorCode != null) {
                setState(() {
                  errorCode = state.exception.errorCode;
                  errorMessage = state.exception.message;
                });
                return;
              }
              CustomDilaogs().errorBox(message: state.exception.message);
            }

            if (state is AuthStateEmailVerificationRequired) {
              CustomDilaogs().alertBox(
                message:
                    "Please verify your email by clicking on the link provided in the email we've sent you.",
                title: "Email Verification Required",
                positiveTitle: "Login again",
                negativeTitle: "Sent link agin",
                onPositivePressed: () {
                  triggerLoginEvent(context.read<AuthBloc>());
                },
                onNegativePressed: () {
                  triggeEmailVerificationMail(context.read<AuthBloc>());
                },
              );
            }

            if (state is AuthStateLoggedIn ||
                state is AuthStateAppleLoggedIn ||
                state is AuthStateGoogleLoggedIn) {
              NavigationService.offAll(const HomeDrawer());
            }
          }
        }

        // For Email Verification States
        if (state is AuthStateSendingMailVerification ||
            state is AuthStateSendingMailVerificationFailure ||
            state is AuthStateSentMailVerification) {
          state.isLoading ? Loader().show() : NavigationService.back();

          if (state is AuthStateSendingMailVerificationFailure) {
            CustomDilaogs().errorBox(message: state.exception.message);
          }

          if (state is AuthStateSentMailVerification) {
            CustomDilaogs().successBox(
                message:
                    "We've sent you an email verification link to ${emailController.text}. Please verify your email by clicking the link before logging in.");
          }
        }
      },
      child: AuthScaffold(
        title: "Sign In",
        subTitle: "Please login to continue",
        asset: AppAssets.loginAsset,
        child: Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 38, left: 29, right: 29, bottom: 30),
              child: Column(
                children: [
                  /// Email TextFiled
                  CustomTextFiled(
                    controller: emailController,
                    errorCode: errorCode,
                    errorText: errorMessage,
                    fieldId: 1,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  gapH12,

                  /// Password TextFiled
                  CustomTextFiled(
                    controller: passwordController,
                    errorCode: errorCode,
                    errorText: errorMessage,
                    fieldId: 2,
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
                        shadowColor:
                            MaterialStatePropertyAll(Colors.transparent),
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

                  /// Login Button
                  CustomButton(
                      title: "Login",
                      isLoading: isLoading,
                      onPressed: () {
                        triggerLoginEvent(context.read<AuthBloc>());
                      }),
                  gapH20,
                  Text(
                    "------ OR ------",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.subTitleColor1,
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  gapH10,

                  /// Social Login Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialIconButton(
                          onPressed: () {
                            triggerAppleLogin(context.read<AuthBloc>());
                          },
                          icon: AppAssets.appleIcon),
                      gapW20,
                      SocialIconButton(
                          onPressed: () {
                            triggerGoogleLogin(context.read<AuthBloc>());
                          },
                          icon: AppAssets.googleIcon),
                    ],
                  ),
                  gapH30,

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
      ),
    );
  }
}

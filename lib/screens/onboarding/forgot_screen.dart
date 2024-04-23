// Project: 	   listi_shop
// File:    	   forgot_screen
// Path:    	   lib/screens/onboarding/forgot_screen.dart
// Author:       Ali Akbar
// Date:        03-04-24 17:02:10 -- Wednesday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:listi_shop/blocs/auth/auth_state.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/constants.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../utils/extensions/navigation_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  String loadingText = "Sending Mail...";
  bool isLoading = false;
  int? errorCode;
  String? errorMessage;

  void triggerForgotPassword(AuthBloc bloc) {
    bloc.add(
      AuthEventForgotPassword(email: emailController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateSendingForgotEmail ||
            state is AuthStateSendForgotEmailFailure ||
            state is AuthStateSentForgotEmail) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is AuthStateSendForgotEmailFailure) {
            if (state.exception.errorCode != null) {
              setState(() {
                errorCode = state.exception.errorCode;
                errorMessage = state.exception.message;
              });
              return;
            }
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is AuthStateSentForgotEmail) {
            CustomDialogs().successBox(
              message:
                  "We've just sent you an email containing a password reset link.\nPlease check your mail.",
              title: "Mail Sent!",
              positiveTitle: "Go back",
              onPositivePressed: () {
                NavigationService.back();
              },
            );
          }
        }
      },
      child: CustomScaffold(
        title: "Forgot Password",
        body: HorizontalPadding(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(top: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AppAssets.forgotPasswordAsset),
                gapH30,
                CustomTextFiled(
                  controller: emailController,
                  fieldId: 1,
                  errorCode: errorCode,
                  errorText: errorMessage,
                  hintText: " Enter Email",
                  titleText: " Enter Email",
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: SCREEN_HEIGHT * 0.15),
                CustomButton(
                  title: "Send mail",
                  isLoading: isLoading,
                  onPressed: () {
                    triggerForgotPassword(context.read<AuthBloc>());
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

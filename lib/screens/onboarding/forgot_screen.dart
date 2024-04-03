// Project: 	   listi_shop
// File:    	   forgot_screen
// Path:    	   lib/screens/onboarding/forgot_screen.dart
// Author:       Ali Akbar
// Date:        03-04-24 17:02:10 -- Wednesday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/constants.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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
              const CustomTextFiled(
                hintText: " Enter Email",
                titleText: " Enter Email",
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: SCREEN_HEIGHT * 0.15),
              CustomButton(title: "Sent mail", onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

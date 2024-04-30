// Project: 	   listi_shop
// File:    	   subscription_active_screen
// Path:    	   lib/screens/main/subscription_active_screen.dart
// Author:       Ali Akbar
// Date:        05-04-24 11:13:07 -- Friday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';

import '../../managers/app_manager.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../utils/extensions/navigation_service.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: HorizontalPadding(
        child: CustomButton(
          isLoading: isLoading,
          isEnabled: !AppManager().isActiveSubscription,
          title: "Subscribe",
          onPressed: () {
            CustomDialogs().alertBox(
              title: "Subscription Alert",
              message:
                  "This is for test purpose. In Product subscription method may work different.",
              positiveTitle: "Go and Subscribe",
              onPositivePressed: () {
                setState(() {
                  isLoading = true;
                });
                Future.delayed(const Duration(seconds: 3), () {
                  setState(() {
                    isLoading = false;
                    AppManager().isActiveSubscription = true;
                  });

                  CustomDialogs().successBox(
                    message:
                        "Subscription active successfully. Please Go to home screen to take effect of subscription.",
                    positiveTitle: "Back",
                    onPositivePressed: () {
                      NavigationService.back();
                    },
                  );
                });
              },
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      title: "Payment Method",
      body: HorizontalPadding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: SCREEN_HEIGHT * 0.10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "29.99\$",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 30,
                    color: AppTheme.primaryColor2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "/month",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    color: AppTheme.primaryColor2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            gapH50,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor2,
                borderRadius: BorderRadius.all(Radius.circular(44)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(AppAssets.appleSmallIcon),
                      gapW20,
                      Text(
                        "Apple",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                  SvgPicture.asset(AppAssets.roundIcon),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

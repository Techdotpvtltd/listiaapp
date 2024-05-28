// Project: 	   listi_shop
// File:    	   subscription_active_screen
// Path:    	   lib/screens/main/subscription_active_screen.dart
// Author:       Ali Akbar
// Date:        05-04-24 11:13:07 -- Friday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';

import '../../blocs/subscription/subscription_bloc.dart';
import '../../blocs/subscription/subscription_event.dart';
import '../../blocs/subscription/subscription_state.dart';
import '../../managers/app_manager.dart';
import '../../utils/dialogs/dialogs.dart';
import 'dart:io' show Platform;

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key, required this.productDetail});
  final ProductDetails productDetail;
  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  bool isLoading = false;

  void triggerBuySubscriptionEvent(SubscriptionBloc bloc) {
    bloc.add(
        SubscriptionEventBuySubscription(productDetails: widget.productDetail));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionStatePurchasing ||
            state is SubscriptionStatePurchased ||
            state is SubscriptionStatePurchaseFailure) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is SubscriptionStatePurchaseFailure) {
            CustomDialogs().errorBox(message: state.exception.message);
          }

          if (state is SubscriptionStatePurchased) {
            AppManager().isActiveSubscription = true;
            CustomDialogs().successBox(
              message:
                  "Thank you for subscribing! Your subscription is now active. Enjoy all the benefits and features available to you.",
              positiveTitle: "Go to Home",
              onPositivePressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            );
          }
        }
      },
      child: CustomScaffold(
        floatingActionButton: HorizontalPadding(
          child: CustomButton(
            isLoading: isLoading,
            title: "Subscribe",
            onPressed: () {
              triggerBuySubscriptionEvent(context.read<SubscriptionBloc>());
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
                    widget.productDetail.price,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor2,
                  borderRadius: BorderRadius.all(Radius.circular(44)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(Platform.isAndroid
                            ? AppAssets.googleIcon
                            : AppAssets.appleSmallIcon),
                        gapW20,
                        Text(
                          Platform.isAndroid ? "Google" : "Apple",
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
      ),
    );
  }
}

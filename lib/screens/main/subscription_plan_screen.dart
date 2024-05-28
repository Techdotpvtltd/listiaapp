// Project: 	   listi_shop
// File:    	   subscription_plan_screen
// Path:    	   lib/screens/main/subscription_plan_screen.dart
// Author:       Ali Akbar
// Date:        05-04-24 10:38:04 -- Friday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:listi_shop/screens/components/custom_ink_well.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/screens/main/payment_method_screen.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

import '../../blocs/drawer_cubit/drawer_cubit.dart';
import '../../blocs/subscription/subscription_bloc.dart';
import '../../blocs/subscription/subscription_event.dart';
import '../../blocs/subscription/subscription_state.dart';
import '../../managers/app_manager.dart';
import '../../repos/subscription_repo.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key, this.isShowMenu = false});
  final bool isShowMenu;
  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  String activeSubscriptionId = AppManager().isActiveSubscription
      ? SubscriptionRepo().lastSubscription?.productId ?? ""
      : "";
  List<ProductDetails> productDetails = [];

  void triggerGetProductsEvent() {
    context.read<SubscriptionBloc>().add(SubscriptionEventReady());
  }

  @override
  void initState() {
    triggerGetProductsEvent();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SubscriptionBloc, SubscriptionState>(
      listener: (context, state) {
        if (state is SubscriptionStateGettingProducts ||
            state is SubscriptionStateGotProducts ||
            state is SubscriptionStateReady ||
            state is SubscriptionStateFailure ||
            state is SubscriptionStateStoreStatus ||
            state is SubscriptionStatePurchased ||
            state is SubscriptionStatePurchaseFailure) {
          if (state is SubscriptionStateGotProducts) {
            setState(() {
              productDetails = state.products;
              activeSubscriptionId = AppManager().isActiveSubscription
                  ? SubscriptionRepo().lastSubscription?.productId ?? ""
                  : "";
            });
          }

          if (state is SubscriptionStateFailure) {
            debugPrint(state.exception.message);
          }

          if (state is SubscriptionStatePurchaseFailure) {
            debugPrint(state.exception.message);
          }

          if (state is SubscriptionStatePurchased) {
            setState(() {
              activeSubscriptionId = AppManager().isActiveSubscription
                  ? SubscriptionRepo().lastSubscription?.productId ?? ""
                  : "";
            });
          }
        }
      },
      child: CustomScaffold(
        title: "Subscription Plan",
        backButtonIcon: widget.isShowMenu
            ? const Icon(
                Icons.menu,
                color: Colors.white,
              )
            : null,
        backButtonPressed: widget.isShowMenu
            ? () {
                context.read<DrawerCubit>().openDrawer();
              }
            : null,
        body: HVPadding(
          verticle: 10,
          child: ListView.builder(
            itemCount: productDetails.length,
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            itemBuilder: (context, index) {
              return CustomInkWell(
                onTap: () {
                  NavigationService.go(
                    PaymentMethodScreen(productDetail: productDetails[index]),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 37, bottom: 24, left: 24, right: 24),
                  margin: const EdgeInsets.symmetric(vertical: 9),
                  decoration: BoxDecoration(
                    color: activeSubscriptionId == productDetails[index].id
                        ? null
                        : const Color(0xFF5A7D65).withOpacity(0.08),
                    gradient: activeSubscriptionId == productDetails[index].id
                        ? AppTheme.primaryLinearGradient
                        : null,
                    border: Border.all(color: AppTheme.primaryColor2),
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title and Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            productDetails[index].title,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: activeSubscriptionId ==
                                      productDetails[index].id
                                  ? Colors.white
                                  : AppTheme.titleColor1,
                            ),
                          ),

                          /// Price Text
                          Text(
                            "${productDetails[index].price}/ month",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                              color: activeSubscriptionId ==
                                      productDetails[index].id
                                  ? Colors.white
                                  : AppTheme.titleColor1,
                            ),
                          ),
                        ],
                      ),
                      gapH10,

                      for (String content
                          in productDetails[index].description.split(","))

                        /// Contents Row
                        Row(
                          children: [
                            Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: activeSubscriptionId ==
                                        productDetails[index].id
                                    ? Colors.white
                                    : AppTheme.primaryColor2,
                                shape: BoxShape.circle,
                              ),
                            ),
                            gapW10,
                            Flexible(
                              child: Text(
                                content,
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: activeSubscriptionId ==
                                          productDetails[index].id
                                      ? Colors.white
                                      : AppTheme.titleColor1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      gapH2,
                      Align(
                        alignment: Alignment.centerRight,
                        child: CustomInkWell(
                          onTap: () async {
                            await NavigationService.go(
                              PaymentMethodScreen(
                                productDetail: productDetails[index],
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: activeSubscriptionId ==
                                        productDetails[index].id
                                    ? Colors.white
                                    : AppTheme.primaryColor2,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: activeSubscriptionId ==
                                      productDetails[index].id
                                  ? Colors.white
                                  : AppTheme.primaryColor2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

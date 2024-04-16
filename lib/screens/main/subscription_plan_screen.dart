// Project: 	   listi_shop
// File:    	   subscription_plan_screen
// Path:    	   lib/screens/main/subscription_plan_screen.dart
// Author:       Ali Akbar
// Date:        05-04-24 10:38:04 -- Friday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_ink_well.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/screens/main/payment_method_screen.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

import '../../blocs/drawer_cubit/drawer_cubit.dart';
import '../../models/subscription_model.dart';

final List<SubscriptionModel> subscriptions = [
  SubscriptionModel(
    id: "0",
    title: "Silver",
    contents: [
      "Add MORE Than 5 People",
      "Also one boost weekly just for 24 hours",
    ],
    price: 19.9,
    periodDuration: "month",
  ),
  SubscriptionModel(
    id: "1",
    title: "Gold",
    contents: [
      "Add MORE Than 10 People",
      "Also one boost weekly just for 24 hours",
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
    ],
    price: 29.9,
    periodDuration: "month",
  ),
  SubscriptionModel(
    id: "0",
    title: "Platinum",
    contents: [
      "Add unlimited People",
      "Also one boost weekly just for 24 hours",
    ],
    price: 39.9,
    periodDuration: "month",
  ),
];

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key, this.isShowMenu = false});
  final bool isShowMenu;
  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
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
          itemCount: subscriptions.length,
          padding: const EdgeInsets.only(top: 40, bottom: 20),
          itemBuilder: (context, index) {
            bool isSelected = selectedIndex == index;
            return CustomInkWell(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.only(
                    top: 37, bottom: 24, left: 24, right: 24),
                margin: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected
                      ? null
                      : const Color(0xFF5A7D65).withOpacity(0.08),
                  gradient: isSelected ? AppTheme.primaryLinearGradient : null,
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
                          subscriptions[index].title,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.titleColor1,
                          ),
                        ),

                        /// Price Text
                        Text(
                          "\$${subscriptions[index].price}/ ${subscriptions[index].periodDuration}",
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                            color: isSelected
                                ? Colors.white
                                : AppTheme.titleColor1,
                          ),
                        ),
                      ],
                    ),
                    gapH10,

                    for (String content in subscriptions[index].contents)

                      /// Contents Row
                      Row(
                        children: [
                          Container(
                            width: 3,
                            height: 3,
                            decoration: BoxDecoration(
                              color: isSelected
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
                                color: isSelected
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
                        onTap: () {
                          NavigationService.go(const PaymentMethodScreen());
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.primaryColor2,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            color: isSelected
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
    );
  }
}

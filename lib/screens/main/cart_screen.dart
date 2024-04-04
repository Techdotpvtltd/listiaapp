// Project: 	   listi_shop
// File:    	   cart_screen
// Path:    	   lib/screens/main/cart_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 21:45:42 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_ink_well.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/paddings.dart';

import '../../utils/constants/app_assets.dart';
import '../../utils/constants/app_theme.dart';
import '../../utils/constants/constants.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: HVPadding(
        horizontal: 12,
        verticle: 0,
        child: CustomButton(
          title: "Mark as Bought",
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: HVPadding(
          verticle: 27,
          horizontal: 13,
          child: Column(
            children: [
              /// Title Widget
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cart",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.titleColor1,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  CustomInkWell(
                    onTap: () {
                      scaffoldkey.currentState!.closeEndDrawer();
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: AppTheme.titleColor1,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 40, bottom: 100),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 9),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF0474ED).withOpacity(0.19)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Milk",
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppTheme.titleColor1,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Row(
                                children: [
                                  SvgPicture.asset(AppAssets.fireIcon),
                                  gapW4,
                                  Text(
                                    "23 celeries",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF676767),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  gapW10,
                                  SvgPicture.asset(AppAssets.electricIcon),
                                  gapW4,
                                  Text(
                                    "64 macros",
                                    style: GoogleFonts.plusJakartaSans(
                                      color: const Color(0xFF676767),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          /// Delete Button
                          CustomInkWell(
                            onTap: () {},
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFB82D2D).withOpacity(0.14),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.delete,
                                  color: Color(0xFFB82D2D),
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

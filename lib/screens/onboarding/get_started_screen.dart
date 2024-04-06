// Project: 	   listi_shop
// File:    	   get_started_screen
// Path:    	   lib/screens/onboarding/get_started_screen.dart
// Author:       Ali Akbar
// Date:        02-04-24 21:00:15 -- Tuesday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/screens/onboarding/login_screen.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

import '../../models/get_started_model.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  final List<GetStartedModel> model = [
    GetStartedModel(
        title: 'Welcome to Listia',
        subTitle:
            "Make your shopping the easiest and fastest, in advance by making a list of your products with Listia",
        assetPath: AppAssets.gs2),
    GetStartedModel(
        title: 'Create and Share',
        subTitle: "Share shopping lists with family and friends",
        assetPath: AppAssets.gs1),
    GetStartedModel(
        title: 'Smart Categorization',
        subTitle:
            "Make your Shopping With  Automatic Grouping Of Products By category",
        assetPath: AppAssets.gs3),
  ];
  final PageController pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: HorizontalPadding(
        child: CustomButton(
          title: currentIndex != 2 ? "Next" : "Get Started",
          onPressed: () {
            if (currentIndex == 2) {
              NavigationService.offAll(const LoginScreen());
              return;
            }
            pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear);
          },
        ),
      ),
      body: SafeArea(
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: pageController,
          children: model
              .map((e) =>
                  _PageViewItemWidget(currentIndex: currentIndex, model: e))
              .toList(),
          onPageChanged: (value) {
            setState(() {
              currentIndex = value;
            });
          },
        ),
      ),
    );
  }
}

class _PageViewItemWidget extends StatelessWidget {
  const _PageViewItemWidget({required this.currentIndex, required this.model});
  final int currentIndex;
  final GetStartedModel model;

  @override
  Widget build(BuildContext context) {
    return HorizontalPadding(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(model.assetPath),
          gapH50,
          Text(
            model.title,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: AppTheme.titleColor1,
            ),
          ),
          gapH4,
          Text(
            model.subTitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF8D98AF),
            ),
          ),
          gapH50,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < 3; i++)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 4),
                  decoration: BoxDecoration(
                    color: i == currentIndex
                        ? AppTheme.primaryColor2
                        : Colors.grey[400],
                    borderRadius: const BorderRadius.all(Radius.circular(66)),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}

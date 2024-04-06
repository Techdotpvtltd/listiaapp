// Project: 	   listi_shop
// File:    	   home_drawer
// Path:    	   lib/screens/main/home_drawer.dart
// Author:       Ali Akbar
// Date:        03-04-24 19:14:56 -- Wednesday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/blocs/drawer_cubit/drawer_cubit.dart';
import 'package:listi_shop/blocs/drawer_cubit/drawer_state.dart';
import 'package:listi_shop/models/user_model.dart';
import 'package:listi_shop/repos/user_repo.dart';
import 'package:listi_shop/screens/components/avatar_widget.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/screens/main/complete_list_screen.dart';
import 'package:listi_shop/screens/main/contact_us_screen.dart';
import 'package:listi_shop/screens/main/home_screen.dart';
import 'package:listi_shop/screens/main/profile_screen.dart';
import 'package:listi_shop/screens/main/subscription_plan_screen.dart';
import 'package:listi_shop/screens/onboarding/splash_screen.dart';
import 'package:listi_shop/utils/constants/app_assets.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';
import 'package:listi_shop/utils/extensions/navigation_service.dart';

import '../../models/drawer_model.dart';

final List<DrawerModel> drawerItems = [
  DrawerModel(id: 0, title: "Home", asset: AppAssets.homeIcon),
  DrawerModel(id: 1, title: "Complete List", asset: AppAssets.listIcon),
  DrawerModel(id: 2, title: "Profile", asset: AppAssets.userIcon),
  DrawerModel(id: 3, title: "Contact Us", asset: AppAssets.chatIcon),
  DrawerModel(id: 4, title: "Subscription", asset: AppAssets.historyIcon),
];

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  int currentIndex = -1;

  Widget currentScreen() {
    switch (currentIndex) {
      case 0:
        return const HomeScreen();
      case 1:
        return const CompleteListScreen();
      case 2:
        return const ProfileScreen();
      case 3:
        return const ContactUsScreen();
      case 4:
        return const SubscriptionPlanScreen();
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DrawerCubit, HomeDrawerState>(
      builder: (context, state) {
        final bloc = context.read<DrawerCubit>();
        return Scaffold(
          body: Stack(
            children: [
              Image.asset(
                AppAssets.background,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: Stack(
                  children: [
                    ZoomDrawer(
                      controller: bloc.zoomDrawerController,
                      menuScreen: _DrawerMenuScreen(
                        onItemTap: (index) {
                          setState(() {
                            currentIndex = index;
                          });
                          bloc.closeDrawer();
                        },
                      ),
                      mainScreen: currentScreen(),
                      borderRadius: 30,
                      showShadow: true,
                      slideWidth: 260,
                      mainScreenScale: 0.23,
                      menuBackgroundColor: Colors.transparent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DrawerMenuScreen extends StatefulWidget {
  const _DrawerMenuScreen({required this.onItemTap});
  final Function(int) onItemTap;

  @override
  State<_DrawerMenuScreen> createState() => _DrawerMenuScreenState();
}

class _DrawerMenuScreenState extends State<_DrawerMenuScreen> {
  late final UserModel user = UserRepo().currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding:
              EdgeInsets.only(right: 30, top: SCREEN_HEIGHT * 0.12, bottom: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Profile Widget
              Container(
                width: 86,
                height: 86,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: AvatarWidget(
                  avatarUrl: user.avatar,
                  placeholderChar: user.name.isNotEmpty ? user.name[0] : 'U',
                  backgroundColor: AppTheme.primaryColor2,
                ),
              ),
              gapH6,

              /// Named Widget
              Text(
                user.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
              gapH50,

              /// Menu Widgets
              Padding(
                padding: const EdgeInsets.only(left: 34),
                child: Column(
                  children: [
                    for (int i = 0; i < drawerItems.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: InkWell(
                          onTap: () => widget.onItemTap(i),
                          child: Row(
                            children: [
                              SvgPicture.asset(drawerItems[i].asset),
                              gapW10,
                              Flexible(
                                child: Text(
                                  drawerItems[i].title,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Spacer(),

              /// CustomButton
              HorizontalPadding(
                child: Column(
                  children: [
                    const Divider(
                      color: Colors.white,
                    ),
                    gapH20,
                    CustomButton(
                      title: "Logout",
                      onPressed: () {
                        NavigationService.offAll(const SplashScreen());
                      },
                      height: 44,
                      backgroundColor: Colors.white.withOpacity(0.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

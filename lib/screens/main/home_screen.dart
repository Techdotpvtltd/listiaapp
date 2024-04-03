// Project: 	   listi_shop
// File:    	   home_screen
// Path:    	   lib/screens/main/home_screen.dart
// Author:       Ali Akbar
// Date:        03-04-24 19:11:54 -- Wednesday
// Description:
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listi_shop/blocs/drawer_cubit/drawer_cubit.dart';
import 'package:listi_shop/screens/components/avatar_widget.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: LayoutBuilder(
          builder: (context, constrains) {
            return Container(
              padding: EdgeInsets.only(
                  left: 34, right: 34, top: constrains.maxHeight * 0.2),
              width: SCREEN_WIDTH,
              height: constrains.maxHeight,
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryLinearGradient,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      context.read<DrawerCubit>().openDrawer();
                    },
                    child: AvatarWidget(
                      width: constrains.maxHeight * 0.3,
                      height: constrains.maxHeight * 0.3,
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Project: 	   listi_shop
// File:    	   edit_profile_screen
// Path:    	   lib/screens/main/edit_profile_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 17:49:45 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/utils/constants/constants.dart';

import '../../utils/constants/app_theme.dart';
import '../components/avatar_widget.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Edit Profile",
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 31, right: 31, top: 80, bottom: 30),
              child: Column(
                children: [
                  /// Profile
                  SizedBox(
                    width: 125,
                    height: 112,
                    child: Stack(
                      children: [
                        const AvatarWidget(
                          width: 112,
                          height: 112,
                          backgroundColor: AppTheme.primaryColor2,
                        ),
                        Positioned(
                          right: -0,
                          bottom: 6,
                          child: IconButton(
                            onPressed: () {},
                            style: const ButtonStyle(
                              padding:
                                  MaterialStatePropertyAll(EdgeInsets.zero),
                              visualDensity: VisualDensity.compact,
                              backgroundColor: MaterialStatePropertyAll(
                                  AppTheme.primaryColor1),
                            ),
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Name Text Filed
                  gapH50,
                  const CustomTextFiled(
                    hintText: "Name",
                    keyboardType: TextInputType.name,
                  ),
                  gapH10,
                  const CustomTextFiled(
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  gapH10,
                  const CustomTextFiled(
                    hintText: "Phone",
                    keyboardType: TextInputType.phone,
                  ),
                  const Spacer(),
                  CustomButton(title: "Save", onPressed: () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

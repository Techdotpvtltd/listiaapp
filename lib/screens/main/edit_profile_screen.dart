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

import '../../models/user_model.dart';
import '../../repos/user_repo.dart';
import '../../utils/constants/app_theme.dart';
import '../components/avatar_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final UserModel user = UserRepo().currentUser;
  bool isLoading = false;
  int? errorCode;
  String? errorMessage;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  void setProfileData() {
    emailController.text = user.email;
    nameController.text = user.name;
    phoneController.text = user.phoneNumber;
  }

  @override
  void initState() {
    super.initState();
    setProfileData();
  }

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
                        AvatarWidget(
                          avatarUrl: user.avatar,
                          placeholderChar:
                              user.name.isNotEmpty ? user.name[0] : 'U',
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
                  CustomTextFiled(
                    controller: nameController,
                    errorCode: errorCode,
                    errorText: errorMessage,
                    fieldId: 3,
                    hintText: "Name",
                    keyboardType: TextInputType.name,
                  ),
                  gapH10,
                  CustomTextFiled(
                    controller: emailController,
                    errorCode: errorCode,
                    errorText: errorMessage,
                    fieldId: 1,
                    hintText: "Email",
                    keyboardType: TextInputType.emailAddress,
                  ),
                  gapH10,
                  CustomTextFiled(
                    controller: phoneController,
                    errorCode: errorCode,
                    errorText: errorMessage,
                    fieldId: 1012,
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

// Project: 	   listi_shop
// File:    	   share_uses_list_screen
// Path:    	   lib/screens/main/share_uses_list_screen.dart
// Author:       Ali Akbar
// Date:        31-01-25 19:25:59 -- Friday
// Description:

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/repos/user_repo.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/screens/main/components/custom_checkbox.dart';

import '../../models/user_model.dart';
import '../../utils/constants/app_theme.dart';
import '../../utils/constants/constants.dart';
import '../components/avatar_widget.dart';
import '../components/custom_button.dart';
import '../components/custom_ink_well.dart';

class ShareUsersListScreen extends StatefulWidget {
  const ShareUsersListScreen({super.key, required this.invitedUsers});
  final List<UserInfoModel> invitedUsers;
  @override
  State<ShareUsersListScreen> createState() => _ShareUsersListScreenState();
}

class _ShareUsersListScreenState extends State<ShareUsersListScreen> {
  late List<UserInfoModel> users = List.from(widget.invitedUsers);
  List<UserInfoModel> removedUsers = [];
  bool isLoading = false;

  @override
  void initState() {
    users.removeWhere((e) => e.uid == UserRepo().currentUser.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Invited Users",
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: HorizontalPadding(
        child: CustomButton(
          isLoading: isLoading,
          title: "Remove Selected",
          isEnabled: removedUsers.isNotEmpty,
          onPressed: () {},
        ),
      ),
      body: HVPadding(
        verticle: 0,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 22, bottom: 100),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final bool isSelected =
                removedUsers.indexWhere((e) => e.uid == users[index].uid) > -1;

            final UserInfoModel user = users[index];

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 11),
              child: CustomInkWell(
                onTap: () {
                  if (!isSelected) {
                    final int index =
                        users.indexWhere((e) => e.uid == user.uid);
                    if (index > -1) {
                      removedUsers.add(user);
                    }
                  } else {
                    final int index =
                        removedUsers.indexWhere((e) => e.uid == user.uid);
                    if (index > -1) {
                      removedUsers.removeAt(index);
                    }
                  }
                  setState(() {});
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        /// Profile Widget
                        AvatarWidget(
                          avatarUrl: user.avatar,
                          placeholderChar:
                              user.name.characters.firstOrNull.toString(),
                          width: 38,
                          height: 38,
                          backgroundColor: AppTheme.primaryColor2,
                        ),
                        // Name Widget
                        gapW10,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.name,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.titleColor1,
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            gapH6,
                            Text(
                              user.phoneNumber == ""
                                  ? user.email
                                  : user.phoneNumber,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppTheme.titleColor1,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    CustomCheckBox(isChecked: isSelected),
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

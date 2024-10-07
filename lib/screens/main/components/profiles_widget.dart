// Project: 	   listi_shop
// File:    	   avatars_widget
// Path:    	   lib/screens/main/components/avatars_widget.dart
// Author:       Ali Akbar
// Date:        04-04-24 15:28:15 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/avatar_widget.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';

import '../../../models/user_model.dart';
import '../../../repos/user_repo.dart';

class ProfilesWidget extends StatefulWidget {
  const ProfilesWidget(
      {super.key,
      required this.invitedUsers,
      this.showCount = true,
      required this.height});
  final List<String> invitedUsers;
  final bool showCount;
  final double height;

  @override
  State<ProfilesWidget> createState() => _ProfilesWidgetState();
}

class _ProfilesWidgetState extends State<ProfilesWidget> {
  List<UserModel> profiles = [];
  late int length = profiles.length > 4 ? 4 : profiles.length;

  // void triggerInvitedUserProfileEvent() {
  //   context.read<ShareUserBloc>().add(
  //       SharedUserEventFetchInvitedUsers(sharedUserIds: widget.invitedUsers));
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserModel>>(
        future: UserRepo().fetchUsers(userIds: widget.invitedUsers),
        builder: (context, snapshots) {
          if (snapshots.hasData) {
            profiles = snapshots.data ?? [];
            length = profiles.length > 4 ? 4 : profiles.length;
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              !snapshots.hasData && !snapshots.hasError
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.amber,
                        ),
                      ),
                    )
                  : SizedBox(
                      height: widget.height,
                      width: (25 * length).toDouble(),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              for (int i = 0; i < length; i++)
                                Positioned.fill(
                                  left: (i / length) * (length * 25),
                                  right: 0,
                                  child: AvatarWidget(
                                    width: constraints.maxHeight * 0.5,
                                    height: constraints.maxHeight * 0.5,
                                    avatarUrl: profiles[i].avatar,
                                    placeholderChar: profiles[i].name[0],
                                    backgroundColor: AppTheme.primaryColor2,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
              if (profiles.length > length && widget.showCount)
                Row(
                  children: [
                    gapW8,
                    Text(
                      "+${profiles.length - length}",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.subTitleColor1,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
            ],
          );
        });
  }
}

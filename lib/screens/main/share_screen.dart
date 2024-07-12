// Project: 	   listi_shop
// File:    	   share_screen
// Path:    	   lib/screens/main/share_screen.dart
// Author:       Ali Akbar
// Date:        04-04-24 22:06:37 -- Thursday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/screens/components/avatar_widget.dart';
import 'package:listi_shop/screens/components/custom_button.dart';
import 'package:listi_shop/screens/components/custom_ink_well.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/custom_title_textfiled.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/screens/main/components/custom_checkbox.dart';
import 'package:listi_shop/screens/main/subscription_plan_screen.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';
import 'package:listi_shop/utils/constants/constants.dart';

import '../../blocs/share_user/share_user_bloc.dart';
import '../../blocs/share_user/share_user_event.dart';
import '../../blocs/share_user/share_user_state.dart';
import '../../exceptions/data_exceptions.dart';
import '../../models/list_model.dart';
import '../../models/user_model.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../utils/extensions/navigation_service.dart';

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key, required this.list});
  final ListModel list;
  @override
  State<ShareScreen> createState() => _ShareScreenState();
}

class _ShareScreenState extends State<ShareScreen> {
  List<int> selectedIndex = [];
  List<UserModel> users = [];
  late List<String> invitedUsers = widget.list.sharedUsers;
  bool isSearchingUsers = false;
  bool isInvitingUsers = false;

  final TextEditingController searchController = TextEditingController();

  void triggerSearchUsersEvent(ShareUserBloc bloc) {
    if (searchController.text.isEmpty) {
      return;
    }
    bloc.add(ShareUserEventSearch(searchText: searchController.text));
  }

  void triggerInviteEvent(ShareUserBloc bloc) {
    bloc.add(SharedUserEventSendInvite(
        listId: widget.list.id, sharedUserIds: invitedUsers));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShareUserBloc, ShareUserState>(
      listener: (context, state) {
        if (state is ShareUserStateSearching ||
            state is ShareUserStateSearchFailure ||
            state is ShareUserStateSearched) {
          setState(() {
            isSearchingUsers = state.isLoading;
          });

          if (state is ShareUserStateSearched) {
            setState(() {
              users = state.users;
            });
          }
        }

        if (state is ShareUserStateInvited ||
            state is ShareUserStateInviteFailure ||
            state is ShareUserStateInviting) {
          setState(() {
            isInvitingUsers = state.isLoading;
          });

          if (state is ShareUserStateInvited) {
            CustomDialogs().successBox(message: "Invitaions sent.");
          }

          if (state is ShareUserStateInviteFailure) {
            if (state.exception is DataExceptionSubscriptionRequired) {
              CustomDialogs().alertBox(
                message: state.exception.message,
                positiveTitle: "Show Subscription Plan",
                onPositivePressed: () {
                  NavigationService.go(const SubscriptionPlanScreen());
                },
              );
              return;
            }
            CustomDialogs().errorBox(message: state.exception.message);
          }
        }
      },
      child: CustomScaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: HorizontalPadding(
          child: CustomButton(
            isLoading: isInvitingUsers,
            title: "Invite Now",
            onPressed: () {
              triggerInviteEvent(context.read<ShareUserBloc>());
            },
          ),
        ),
        title: "Share",
        body: HVPadding(
          verticle: 29,
          child: Column(
            children: [
              CustomTextFiled(
                controller: searchController,
                textInputAction: TextInputAction.go,
                hintText: "Find by name, email or phone number",
                prefixWidget: const Icon(
                  Icons.search,
                  color: AppTheme.primaryColor2,
                ),
                onSubmitted: (_) {
                  triggerSearchUsersEvent(context.read<ShareUserBloc>());
                },
              ),
              Expanded(
                child: users.isEmpty
                    ? Text(
                        "Sorry, we're unable to locate any user.",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(top: 22, bottom: 100),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          final bool isSelected =
                              invitedUsers.contains(users[index].uid);
                          final UserModel user = users[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 11),
                            child: CustomInkWell(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    setState(() {
                                      invitedUsers
                                          .removeWhere((id) => user.uid == id);
                                    });
                                  } else {
                                    setState(() {
                                      invitedUsers.add(user.uid);
                                    });
                                  }
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      /// Profile Widget
                                      AvatarWidget(
                                        avatarUrl: user.avatar,
                                        placeholderChar: user
                                            .name.characters.firstOrNull
                                            .toString(),
                                        width: 38,
                                        height: 38,
                                        backgroundColor: AppTheme.primaryColor2,
                                      ),
                                      // Name Widget
                                      gapW10,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

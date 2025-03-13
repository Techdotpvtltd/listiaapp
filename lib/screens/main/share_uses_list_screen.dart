// Project: 	   listi_shop
// File:    	   share_uses_list_screen
// Path:    	   lib/screens/main/share_uses_list_screen.dart
// Author:       Ali Akbar
// Date:        31-01-25 19:25:59 -- Friday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listi_shop/blocs/share_user/share_user_bloc.dart';
import 'package:listi_shop/blocs/share_user/share_user_event.dart';
import 'package:listi_shop/blocs/share_user/share_user_state.dart';
import 'package:listi_shop/managers/app_manager.dart';
import 'package:listi_shop/models/list_model.dart';
import 'package:listi_shop/models/request.dart';
import 'package:listi_shop/screens/components/custom_scaffold.dart';
import 'package:listi_shop/screens/components/custom_snack_bar.dart';
import 'package:listi_shop/screens/components/paddings.dart';
import 'package:listi_shop/screens/main/components/custom_checkbox.dart';
import 'package:listi_shop/screens/main/share_screen.dart';
import 'package:listi_shop/utils/dialogs/dialogs.dart';

import '../../models/user_model.dart';
import '../../repos/user_repo.dart';
import '../../utils/constants/app_theme.dart';
import '../../utils/constants/constants.dart';
import '../../utils/extensions/navigation_service.dart';
import '../components/avatar_widget.dart';
import '../components/custom_button.dart';
import '../components/custom_ink_well.dart';

class ShareUsersListScreen extends StatefulWidget {
  const ShareUsersListScreen(
      {super.key, required this.list, required this.requests});
  final ListModel list;
  final List<RequestModel> requests;
  @override
  State<ShareUsersListScreen> createState() => _ShareUsersListScreenState();
}

class _ShareUsersListScreenState extends State<ShareUsersListScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      title: "Invited Users",
      actions: [
        if (AppManager().isActiveSubscription)
          IconButton(
            onPressed: () {
              NavigationService.go(
                  ShareScreen(list: widget.list, requests: widget.requests));
            },
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
          )
      ],
      body: HVPadding(
        verticle: 30,
        child: Column(
          spacing: 10,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                    color: AppTheme.subTitleColor1.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomInkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                        _pageController.animateToPage(_selectedIndex,
                            duration: Durations.long2, curve: Curves.ease);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _selectedIndex == 0
                              ? AppTheme.primaryColor2
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          "Invited",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedIndex == 0
                                ? Colors.white
                                : AppTheme.primaryColor1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: CustomInkWell(
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                        _pageController.animateToPage(_selectedIndex,
                            duration: Durations.long2, curve: Curves.ease);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _selectedIndex == 1
                              ? AppTheme.primaryColor2
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          "Pending",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedIndex == 1
                                ? Colors.white
                                : AppTheme.primaryColor1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                children: [
                  _InvitedUsers(
                    users: List.from(widget.list.sharedUsers),
                    listId: widget.list.id,
                    didInviteButtonPressed: () {
                      NavigationService.go(ShareScreen(
                          list: widget.list, requests: widget.requests));
                    },
                  ),
                  _PendingUserTab(
                    listId: widget.list.id,
                    requests: widget.requests,
                    didPressedInviteButton: () {
                      NavigationService.go(ShareScreen(
                          list: widget.list, requests: widget.requests));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvitedUsers extends StatefulWidget {
  const _InvitedUsers(
      {required this.users,
      required this.didInviteButtonPressed,
      required this.listId});
  final List<UserInfoModel> users;
  final VoidCallback didInviteButtonPressed;
  final String listId;
  @override
  State<_InvitedUsers> createState() => _InvitedUsersState();
}

class _InvitedUsersState extends State<_InvitedUsers> {
  late List<UserInfoModel> users = widget.users;
  List<UserInfoModel> removedUsers = [];
  bool isLoading = false;
  @override
  void initState() {
    users.removeWhere((e) => e.uid == UserRepo().currentUser.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShareUserBloc, ShareUserState>(
      listener: (context, state) {
        if (state is ShareUserStateRemoved ||
            state is ShareUserStateRemoving ||
            state is ShareUserStateRemoveFailure) {
          setState(() {
            isLoading = state.isLoading;
          });

          if (state is ShareUserStateRemoved) {
            for (final u in removedUsers) {
              widget.users.removeWhere((e) => e.uid == u.uid);
              users.removeWhere((e) => e.uid == u.uid);
            }

            setState(() {});
          }

          if (state is ShareUserStateRemoveFailure) {
            CustomSnackBar().error(state.exception.message);
          }
        }
      },
      child: Column(
        children: [
          Expanded(
            child: users.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 30,
                    children: [
                      const Text(
                        "No invitations sent yet. Start by inviting users to join.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      CustomButton(
                        title: "Send Invites",
                        isEnabled: AppManager().isActiveSubscription,
                        onPressed: widget.didInviteButtonPressed,
                      ),
                    ],
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final bool isSelected = removedUsers
                              .indexWhere((e) => e.uid == users[index].uid) >
                          -1;

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
                              final int index = removedUsers
                                  .indexWhere((e) => e.uid == user.uid);
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
          ),
          CustomButton(
            isLoading: isLoading,
            title: "Remove Selected",
            isEnabled: removedUsers.isNotEmpty,
            onPressed: () {
              CustomDialogs().alertBox(
                title: "Remove Users Confirmation",
                message: "Are you sure to remove these users from the list?",
                positiveTitle: "Yes, Remove",
                onPositivePressed: () {
                  triggerRemoveUsersEvent();
                },
              );
            },
          )
        ],
      ),
    );
  }

  void triggerRemoveUsersEvent() {
    context.read<ShareUserBloc>().add(
        ShareUserEventRemoveUsers(listId: widget.listId, users: removedUsers));
  }
}

class _PendingUserTab extends StatefulWidget {
  const _PendingUserTab({
    required this.listId,
    required this.requests,
    required this.didPressedInviteButton,
  });
  final String listId;
  final List<RequestModel> requests;
  final VoidCallback didPressedInviteButton;
  @override
  State<_PendingUserTab> createState() => __PendingUserTabState();
}

class __PendingUserTabState extends State<_PendingUserTab> {
  late final List<RequestModel> requests = widget.requests;

  @override
  Widget build(BuildContext context) {
    return requests.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30,
            children: [
              const Text(
                "No invitations sent yet. Start by inviting users to join.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              CustomButton(
                title: "Send Invites",
                isEnabled: AppManager().isActiveSubscription,
                onPressed: widget.didPressedInviteButton,
              ),
            ],
          )
        : BlocListener<ShareUserBloc, ShareUserState>(
            listener: (context, state) {
              if (state is ShareUserStateRemovedRequest) {
                setState(() {
                  requests.removeWhere((e) => e.uid == state.requestId);
                });
              }
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final RequestModel request = requests[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            /// Profile Widget
                            AvatarWidget(
                              avatarUrl: request.sharedTo.avatar,
                              placeholderChar: request
                                  .sharedTo.name.characters.firstOrNull
                                  .toString(),
                              width: 38,
                              height: 38,
                              backgroundColor: AppTheme.primaryColor2,
                            ),
                            // Name Widget
                            gapW10,
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.sharedTo.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppTheme.titleColor1,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  gapH6,
                                  Text(
                                    request.sharedTo.phoneNumber == ""
                                        ? request.sharedTo.email
                                        : request.sharedTo.phoneNumber,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      color: AppTheme.titleColor1,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        title: "Remove",
                        onPressed: () {
                          triggerRemoveRequestEvent(request.uid);
                        },
                        width: 100,
                        height: 30,
                        textSize: 12,
                        onlyBorder: true,
                      )
                    ],
                  ),
                );
              },
            ),
          );
  }

  void triggerRemoveRequestEvent(String requestId) {
    context
        .read<ShareUserBloc>()
        .add(ShareUserEventRemoveRequest(requestId: requestId));
  }
}

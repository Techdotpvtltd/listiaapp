// Project: 	   listi_shop
// File:    	   share_user_state
// Path:    	   lib/blocs/share_user/share_user_state.dart
// Author:       Ali Akbar
// Date:        30-04-24 15:11:39 -- Tuesday
// Description:

import '../../exceptions/app_exceptions.dart';
import '../../models/user_model.dart';

abstract class ShareUserState {
  final bool isLoading;

  ShareUserState({this.isLoading = false});
}

/// initial State
class ShareUserStateInitial extends ShareUserState {}

// =========================== Search User States ================================
class ShareUserStateSearching extends ShareUserState {
  ShareUserStateSearching({super.isLoading = true});
}

class ShareUserStateSearchFailure extends ShareUserState {
  final AppException exception;

  ShareUserStateSearchFailure({required this.exception});
}

class ShareUserStateSearched extends ShareUserState {
  final List<UserModel> users;

  ShareUserStateSearched({required this.users});
}

// =========================== Send Invite States ================================
class ShareUserStateInviting extends ShareUserState {
  ShareUserStateInviting({super.isLoading = true});
}

class ShareUserStateInviteFailure extends ShareUserState {
  final AppException exception;

  ShareUserStateInviteFailure({required this.exception});
}

class ShareUserStateInvited extends ShareUserState {
  ShareUserStateInvited();
}

// ===========================Find Invited Users================================
class ShareUserStateFoundInvitedUsers extends ShareUserState {
  final List<UserModel> users;

  ShareUserStateFoundInvitedUsers({required this.users});
}

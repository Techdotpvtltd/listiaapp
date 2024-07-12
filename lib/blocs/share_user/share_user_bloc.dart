// Project: 	   listi_shop
// File:    	   share_user_bloc
// Path:    	   lib/blocs/share_user/share_user_bloc.dart
// Author:       Ali Akbar
// Date:        30-04-24 15:16:47 -- Tuesday
// Description:

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../models/user_model.dart';
import '../../repos/user_repo.dart';
import 'share_user_event.dart';
import 'share_user_state.dart';

class ShareUserBloc extends Bloc<ShareUserEvent, ShareUserState> {
  ShareUserBloc() : super(ShareUserStateInitial()) {
    // on Search User
    on<ShareUserEventSearch>(
      (event, emit) async {
        try {
          emit(ShareUserStateSearching());
          final List<UserModel> users =
              await UserRepo().fetchUsersBy(searchText: event.searchText);
          emit(ShareUserStateSearched(users: users));
        } on AppException catch (e) {
          emit(ShareUserStateSearchFailure(exception: e));
        }
      },
    );

    // on Invite User
    on<SharedUserEventSendInvite>(
      (event, emit) async {
        try {
          emit(ShareUserStateInviting());
          await UserRepo().sendInvite(
            listId: event.listId,
            invitedUserIds: event.sharedUserIds,
          );
          emit(ShareUserStateInvited());
        } on AppException catch (e) {
          emit(ShareUserStateInviteFailure(exception: e));
        }
      },
    );

    // on Invite User
    on<SharedUserEventFetchInvitedUsers>(
      (event, emit) async {
        try {
          final users =
              await UserRepo().fetchUsers(userIds: event.sharedUserIds);
          emit(ShareUserStateFoundInvitedUsers(users: users));
        } on AppException catch (e) {
          debugPrint(e.message);
        }
      },
    );
  }
}

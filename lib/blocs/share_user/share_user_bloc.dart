// Project: 	   listi_shop
// File:    	   share_user_bloc
// Path:    	   lib/blocs/share_user/share_user_bloc.dart
// Author:       Ali Akbar
// Date:        30-04-24 15:16:47 -- Tuesday
// Description:

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listi_shop/repos/share_repo.dart';

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
          final int totalInvited =
              event.list.sharedUserIds.length + event.sharedUserIds.length;

          final requests = await ShareRepo().sendInvite(
            list: event.list,
            inviteUsers: event.sharedUserIds,
            totalInvited: totalInvited,
          );
          emit(ShareUserStateInvited(requests));
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

    // on Pending Request fetch for a list
    on<SharedUserEventFetchPendingRequests>(
      (event, emit) async {
        try {
          final requests = await ShareRepo().fetchPendingRequest(event.listId);
          emit(ShareUserStateFetchedPendingRequests(requests: requests));
        } on AppException catch (e) {
          debugPrint(e.message);
        }
      },
    );

    // on request withdraw
    on<ShareUserEventRemoveRequest>(
      (event, emit) async {
        try {
          await ShareRepo().removeRequest(event.requestId);
          emit(ShareUserStateRemovedRequest(requestId: event.requestId));
        } on AppException catch (e) {
          debugPrint(e.message);
        }
      },
    );

    // on request accept
    on<ShareUserEventAddUser>(
      (event, emit) async {
        try {
          emit(ShareUserStateAccepting());
          await ShareRepo()
              .addUser(listId: event.listId, requestId: event.requestId);
          emit(ShareUserStateAccepted());
        } on AppException catch (e) {
          debugPrint(e.message);
          emit(ShareUserStateAcceptFailure(exception: e));
        }
      },
    );
  }
}

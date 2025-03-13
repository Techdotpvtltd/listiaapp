// Project: 	   listi_shop
// File:    	   share_user_event
// Path:    	   lib/blocs/share_user/share_user_event.dart
// Author:       Ali Akbar
// Date:        30-04-24 15:14:59 -- Tuesday
// Description:

import 'package:listi_shop/models/list_model.dart';
import 'package:listi_shop/models/user_model.dart';

abstract class ShareUserEvent {}

/// Search User Event
class ShareUserEventSearch extends ShareUserEvent {
  final String searchText;

  ShareUserEventSearch({required this.searchText});
}

class SharedUserEventSendInvite extends ShareUserEvent {
  final ListModel list;
  final List<UserInfoModel> sharedUserIds;
  SharedUserEventSendInvite({
    required this.list,
    required this.sharedUserIds,
  });
}

class SharedUserEventFetchInvitedUsers extends ShareUserEvent {
  final List<String> sharedUserIds;
  SharedUserEventFetchInvitedUsers({required this.sharedUserIds});
}

class SharedUserEventFetchPendingRequests extends ShareUserEvent {
  final String listId;
  SharedUserEventFetchPendingRequests({required this.listId});
}

class ShareUserEventRemoveRequest extends ShareUserEvent {
  final String requestId;

  ShareUserEventRemoveRequest({required this.requestId});
}

class ShareUserEventAddUser extends ShareUserEvent {
  final String listId;
  final String requestId;

  ShareUserEventAddUser({required this.listId, required this.requestId});
}

class ShareUserEventRemoveUsers extends ShareUserEvent {
  final String listId;
  final List<UserInfoModel> users;

  ShareUserEventRemoveUsers({required this.listId, required this.users});
}

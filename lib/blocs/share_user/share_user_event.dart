// Project: 	   listi_shop
// File:    	   share_user_event
// Path:    	   lib/blocs/share_user/share_user_event.dart
// Author:       Ali Akbar
// Date:        30-04-24 15:14:59 -- Tuesday
// Description:

abstract class ShareUserEvent {}

/// Search User Event
class ShareUserEventSearch extends ShareUserEvent {
  final String searchText;

  ShareUserEventSearch({required this.searchText});
}

class SharedUserEventSendInvite extends ShareUserEvent {
  final String listId;
  final List<String> sharedUserIds;

  SharedUserEventSendInvite(
      {required this.listId, required this.sharedUserIds});
}

class SharedUserEventFetchInvitedUsers extends ShareUserEvent {
  final List<String> sharedUserIds;
  SharedUserEventFetchInvitedUsers({required this.sharedUserIds});
}

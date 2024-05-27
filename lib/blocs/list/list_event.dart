// Project: 	   listi_shop
// File:    	   list_event
// Path:    	   lib/blocs/list/list_event.dart
// Author:       Ali Akbar
// Date:        22-04-24 17:05:15 -- Monday
// Description:

abstract class ListEvent {}

// Create New List
class ListEventCreate extends ListEvent {
  final String title;

  ListEventCreate({required this.title});
}

class ListEventUpdate extends ListEvent {
  final String listId;
  final String title;

  ListEventUpdate({required this.listId, required this.title});
}

class ListEventDelete extends ListEvent {
  final String listId;
  final List<String> itemsIds;
  ListEventDelete({required this.listId, required this.itemsIds});
}

// Fetch List
class ListEventFetch extends ListEvent {
  final String forUser;

  ListEventFetch({required this.forUser});
}

class ListEventAdminFetch extends ListEvent {
  ListEventAdminFetch();
}

/// Move list to User Event
class ListEventMove extends ListEvent {
  final String listId;

  ListEventMove({required this.listId});
}

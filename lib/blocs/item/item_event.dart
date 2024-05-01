// Project: 	   listi_shop
// File:    	   item_event
// Path:    	   lib/blocs/item/item_event.dart
// Author:       Ali Akbar
// Date:        23-04-24 13:07:57 -- Tuesday
// Description:

abstract class ItemEvent {}

/// Add New Item Event
class ItemEventAddNew extends ItemEvent {
  final String itemName;
  final int? celeries;
  final int? macros;
  final String listId;
  final String category;

  ItemEventAddNew(
      {required this.itemName,
      this.celeries,
      this.macros,
      required this.listId,
      required this.category});
}

class ItemEventUpdate extends ItemEvent {
  final String itemName;
  final int? celeries;
  final int? macros;
  final String itemId;
  final String category;

  ItemEventUpdate(
      {required this.itemName,
      this.celeries,
      this.macros,
      required this.itemId,
      required this.category});
}

// Fetch Items Event
class ItemEventFetch extends ItemEvent {}

class ItemEventFetchAdmin extends ItemEvent {}

// Mark Complete Event
class ItemEventMarkComplete extends ItemEvent {
  final String itemId;

  ItemEventMarkComplete({required this.itemId});
}

// Mark Un Complete Event
class ItemEventRemoveItemComplete extends ItemEvent {
  final String itemId;

  ItemEventRemoveItemComplete({required this.itemId});
}

class ItemEventMarkItemsBought extends ItemEvent {
  final List<String> items;
  final String listId;
  ItemEventMarkItemsBought({required this.listId, required this.items});
}

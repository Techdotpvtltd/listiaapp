// Project: 	   listi_shop_admin
// File:    	   category_event
// Path:    	   lib/blocs/category/category_event.dart
// Author:       Ali Akbar
// Date:        25-04-24 16:40:52 -- Thursday
// Description:

abstract class CategoryEvent {}

// Add Category Event
class CategoryEventAdd extends CategoryEvent {
  final String category;

  CategoryEventAdd({required this.category});
}

// Fetch Category Event
class CategoryEventFetch extends CategoryEvent {}

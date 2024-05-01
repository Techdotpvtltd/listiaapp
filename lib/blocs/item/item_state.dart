// Project: 	   listi_shop
// File:    	   item_state
// Path:    	   lib/blocs/item/item_state.dart
// Author:       Ali Akbar
// Date:        23-04-24 12:43:59 -- Tuesday
// Description:

import '../../exceptions/app_exceptions.dart';

abstract class ItemState {
  final bool isLoading;
  final String loadingText;

  ItemState({this.isLoading = false, this.loadingText = "Processing..."});
}

// InitialState
class ItemStateInitial extends ItemState {}

// ===========================Add New Item States================================
class ItemStateAdding extends ItemState {
  ItemStateAdding(
      {super.isLoading = true, super.loadingText = "Adding Item..."});
}

class ItemStateAddFailure extends ItemState {
  final AppException exception;

  ItemStateAddFailure({required this.exception});
}

class ItemStateAdded extends ItemState {}

// ===========================Update Item States================================
class ItemStateUpdating extends ItemState {
  ItemStateUpdating(
      {super.isLoading = true, super.loadingText = "Adding Item..."});
}

class ItemStateUpdateFailure extends ItemState {
  final AppException exception;

  ItemStateUpdateFailure({required this.exception});
}

class ItemStateUpdated extends ItemState {}

// ===========================Fetch Items States================================
class ItemStateFetching extends ItemState {
  ItemStateFetching(
      {super.isLoading = true, super.loadingText = "Fetching..."});
}

class ItemStateFetchFailure extends ItemState {
  final AppException exception;

  ItemStateFetchFailure({required this.exception});
}

class ItemStateFetchedAll extends ItemState {}

class ItemStateFetched extends ItemState {}

// ===========================Complete Item States================================
class ItemStateMarkCompleted extends ItemState {}

class ItemStateItemRemoveFromCompleted extends ItemState {
  final String itemId;

  ItemStateItemRemoveFromCompleted({required this.itemId});
}

// ===========================Mark As Bought Items States================================
class ItemStateMarkingItemBought extends ItemState {
  ItemStateMarkingItemBought(
      {super.isLoading = true, super.loadingText = "Marking items bought"});
}

class ItemStateMarkItemBoughtFailure extends ItemState {
  final AppException exception;

  ItemStateMarkItemBoughtFailure({required this.exception});
}

class ItemStateMarkedItemBought extends ItemState {}

// ===========================Deleted States================================
class ItemStateDeleted extends ItemState {}

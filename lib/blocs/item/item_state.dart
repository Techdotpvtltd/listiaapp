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

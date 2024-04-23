// Project: 	   listi_shop
// File:    	   list_state
// Path:    	   lib/blocs/list/list_state.dart
// Author:       Ali Akbar
// Date:        22-04-24 17:05:30 -- Monday
// Description:

import '../../exceptions/app_exceptions.dart';

abstract class ListState {
  final bool isLoading;
  final String loadingText;

  ListState({this.isLoading = false, this.loadingText = ''});
}

/// Initial State
class ListStateInitial extends ListState {}

// ===========================Craete List States================================

class ListStateCreating extends ListState {
  ListStateCreating(
      {super.isLoading = true, super.loadingText = "Creating..."});
}

class ListStateCreateFailure extends ListState {
  final AppException exception;

  ListStateCreateFailure({required this.exception});
}

class ListStateCreated extends ListState {}

// ===========================Fetching List States================================

class ListStateFetching extends ListState {
  ListStateFetching(
      {super.isLoading = true, super.loadingText = "Fetching..."});
}

class ListStateFetchFailure extends ListState {
  final AppException exception;

  ListStateFetchFailure({required this.exception});
}

class ListStateFetched extends ListState {}

class ListStateNewAdded extends ListState {}
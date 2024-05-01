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

// ===========================Fetching List States================================

class ListStateAdminFetching extends ListState {
  ListStateAdminFetching(
      {super.isLoading = true, super.loadingText = "Fetching..."});
}

class ListStateAdminFetchFailure extends ListState {
  final AppException exception;

  ListStateAdminFetchFailure({required this.exception});
}

class ListStateAdminFetched extends ListState {}

class ListStateNewAdminAdded extends ListState {}

// ===========================Move List States================================
class ListStateMoving extends ListState {
  final String listId;
  ListStateMoving(
      {super.isLoading = true,
      super.loadingText = "Moving...",
      required this.listId});
}

class ListStateMoveFailure extends ListState {
  final AppException exception;

  ListStateMoveFailure({required this.exception});
}

class ListStateMoved extends ListState {}

// =========================== Update List State ================================

class ListStateUpdating extends ListState {
  ListStateUpdating(
      {super.isLoading = true, super.loadingText = "Creating..."});
}

class ListStateUpdateFailure extends ListState {
  final AppException exception;

  ListStateUpdateFailure({required this.exception});
}

class ListStateUpdated extends ListState {}

// ===========================Delete List State================================
class ListStateDeleting extends ListState {
  ListStateDeleting({super.isLoading = true});
}

class ListStateDeleted extends ListState {
  ListStateDeleted();
}

class ListStateDeleteFailure extends ListState {
  final AppException exception;

  ListStateDeleteFailure({required this.exception});
}

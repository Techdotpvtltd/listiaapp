// Project: 	   listi_shop_admin
// File:    	   category_state
// Path:    	   lib/blocs/category/category_state.dart
// Author:       Ali Akbar
// Date:        25-04-24 16:37:06 -- Thursday
// Description:

import '../../exceptions/app_exceptions.dart';

abstract class CategoryState {
  final bool isLoading;
  final String loadingText;

  CategoryState({this.isLoading = false, this.loadingText = "Processing...."});
}

/// Initail state
class CategoryStateInitial extends CategoryState {}

// ===========================Add Category States================================
class CategoryStateAdding extends CategoryState {
  CategoryStateAdding(
      {super.isLoading = true, super.loadingText = "Adding Category..."});
}

class CategoryStateAddFailure extends CategoryState {
  final AppException exception;

  CategoryStateAddFailure({required this.exception});
}

class CategoryStateAdded extends CategoryState {}

// ===========================Fetch Categories States================================
class CategoryStateFetching extends CategoryState {
  CategoryStateFetching(
      {super.isLoading = true, super.loadingText = "Fetching Category..."});
}

class CategoryStateFetchFailure extends CategoryState {
  final AppException exception;
  CategoryStateFetchFailure({required this.exception});
}

class CategoryStateFetched extends CategoryState {}

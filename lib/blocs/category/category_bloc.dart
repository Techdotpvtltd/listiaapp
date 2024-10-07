// Project: 	   listi_shop_admin
// File:    	   category_bloc
// Path:    	   lib/blocs/category/category_bloc.dart
// Author:       Ali Akbar
// Date:        25-04-24 16:41:46 -- Thursday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../repos/category_repo.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryStateInitial()) {
    // Add Category Event
    on<CategoryEventAdd>(
      (event, emit) async {
        try {
          emit(CategoryStateAdding());
          await CategoryRepo().addCategory(category: event.category);
          emit(CategoryStateAdded());
        } on AppException catch (e) {
          emit(CategoryStateAddFailure(exception: e));
        }
      },
    );

    // Fetch Categories Event
    on<CategoryEventFetch>(
      (event, emit) async {
        try {
          emit(CategoryStateFetching());
          await CategoryRepo().fetchCategories();
          emit(CategoryStateFetched());
        } on AppException catch (e) {
          emit(CategoryStateFetchFailure(exception: e));
        }
      },
    );
  }
}

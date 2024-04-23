// Project: 	   listi_shop
// File:    	   item_bloc
// Path:    	   lib/blocs/item/item_bloc.dart
// Author:       Ali Akbar
// Date:        23-04-24 13:12:25 -- Tuesday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../repos/item_repo.dart';
import 'item_event.dart';
import 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(ItemStateInitial()) {
    // Fetc
    on<ItemEventAddNew>(
      (event, emit) async {
        try {
          emit(ItemStateAdding());
          await ItemRepo().addItem(
            itemName: event.itemName,
            listId: event.listId,
            category: event.category,
            macros: event.macros,
            celeries: event.celeries,
          );
          emit(ItemStateAdded());
        } on AppException catch (e) {
          emit(ItemStateAddFailure(exception: e));
        }
      },
    );
    on<ItemEventFetch>((event, emit) async {});
  }
}

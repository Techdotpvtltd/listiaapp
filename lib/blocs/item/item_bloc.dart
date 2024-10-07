// Project: 	   listi_shop
// File:    	   item_bloc
// Path:    	   lib/blocs/item/item_bloc.dart
// Author:       Ali Akbar
// Date:        23-04-24 13:12:25 -- Tuesday
// Description:

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../exceptions/app_exceptions.dart';
import '../../repos/item_repo.dart';
import 'item_event.dart';
import 'item_state.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  ItemBloc() : super(ItemStateInitial()) {
    // Add New Item List
    on<ItemEventAddNew>(
      (event, emit) async {
        try {
          emit(ItemStateAdding());
          await ItemRepo().addItem(
            itemName: event.itemName,
            listId: event.listId,
            category: event.category,
            quantity: event.quantity,
            unit: event.unit,
            amount: event.amount,
          );
          emit(ItemStateAdded());
        } on AppException catch (e) {
          emit(ItemStateAddFailure(exception: e));
        }
      },
    );

    // Add New Item List
    on<ItemEventUpdate>(
      (event, emit) async {
        try {
          emit(ItemStateUpdating());
          await ItemRepo().updateItem(
            itemName: event.itemName,
            itemId: event.itemId,
            category: event.category,
            quantity: event.quantity,
            unit: event.unit,
            amount: event.amount,
          );
          emit(ItemStateUpdated());
        } on AppException catch (e) {
          emit(ItemStateUpdateFailure(exception: e));
        }
      },
    );

    // Add New Item List
    on<ItemEventUpdateIsReadyToBuy>(
      (event, emit) async {
        try {
          emit(ItemStateUpdating());
          await ItemRepo().updateIsReadyToBuy(
            itemId: event.itemId,
            isReadyToBuy: event.isReadyToBuy,
          );
          emit(ItemStateUpdated());
        } on AppException catch (e) {
          emit(ItemStateUpdateFailure(exception: e));
        }
      },
    );

    /// Fetch item Event
    on<ItemEventFetch>((event, emit) async {
      emit(ItemStateFetching());
      await ItemRepo().fetchItems(
        onGetAll: () {
          emit(ItemStateFetchedAll());
        },
        onGetData: () {
          emit(ItemStateFetched());
        },
        onError: (e) {
          emit(ItemStateFetchFailure(exception: e));
        },
      );
    });

    /// Fetch Admin item Event
    on<ItemEventFetchAdmin>((event, emit) async {
      emit(ItemStateFetching());
      await ItemRepo().fetchAdminItems(
        onGetAll: () {
          emit(ItemStateFetchedAll());
        },
        onGetData: () {
          emit(ItemStateFetched());
        },
        onError: (e) {
          emit(ItemStateFetchFailure(exception: e));
        },
      );
    });

    /// Mark Item Complete Event
    on<ItemEventMarkComplete>(
      (event, emit) async {
        try {
          ItemRepo().markItemComplete(itemId: event.itemId);
          emit(ItemStateMarkCompleted());
        } on AppException catch (e) {
          debugPrint(e.toString());
        }
      },
    );

    /// Remoev Item Complete Event
    on<ItemEventRemoveItemComplete>(
      (event, emit) async {
        try {
          ItemRepo().removeItemComplete(itemId: event.itemId);
          emit(ItemStateItemRemoveFromCompleted(itemId: event.itemId));
        } on AppException catch (e) {
          debugPrint(e.toString());
        }
      },
    );

    /// Mark Item Bought'
    on<ItemEventMarkItemsBought>(
      (event, emit) async {
        try {
          emit(ItemStateMarkingItemBought());
          await ItemRepo()
              .markItemsBought(items: event.items, listId: event.listId);
          emit(ItemStateMarkedItemBought());
        } on AppException catch (e) {
          emit(ItemStateMarkItemBoughtFailure(exception: e));
        }
      },
    );

    /// Mark Deleted
    on<ItemEventDeleted>((event, emit) async {
      try {
        await ItemRepo().deleteItem(itemId: event.itemId);
        emit(ItemStateDeleted());
      } on AppException catch (_) {
        ///
      }
    });
  }
}

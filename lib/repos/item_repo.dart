// Project: 	   listi_shop
// File:    	   item_repo
// Path:    	   lib/repos/item_repo.dart
// Author:       Ali Akbar
// Date:        23-04-24 13:34:19 -- Tuesday
// Description:

import 'package:flutter/material.dart';
import 'package:listi_shop/utils/extensions/boolean.dart';

import '../exceptions/app_exceptions.dart';
import '../exceptions/exception_parsing.dart';
import '../models/item_bought_model.dart';
import '../models/item_complete_model.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import '../web_services/query_model.dart';
import 'list_repo.dart';
import 'user_repo.dart';
import 'validations/data_validations.dart';

class ItemRepo {
  // ===========================Singleton Instance================================
  static ItemRepo _instance = ItemRepo._internal();
  ItemRepo._internal();
  factory ItemRepo() => _instance;

  // ===========================Properties================================
  final List<ItemModel> _items = [];

  // ===========================Methods================================
  void reset() {
    _instance = ItemRepo._internal();
  }

  int getNumberOfItemsBy({String? listId}) {
    return listId == null
        ? _items
            .where((element) =>
                element.createdBy != "admin" && element.boughtBy == null)
            .length
        : _items
            .where((element) =>
                element.listId == listId && element.boughtBy == null)
            .length;
  }

  int getNumberOfCompletedItemsBy({String? listId}) {
    return listId == null
        ? _items
            .where((element) =>
                element.completedBy != null && element.boughtBy == null)
            .length
        : _items
            .where((element) =>
                element.listId == listId &&
                element.completedBy != null &&
                element.boughtBy == null)
            .length;
  }

  List<CategorizeItemsModel> filteredItems(
      {required String listId,
      String? searchText,
      List<String>? categories,
      required bool isShowBoughtItemsOnly}) {
    /// When Search text is empty
    if (searchText == "" || searchText == null) {
      return _getCategoriesItemsBy(
          listId: listId,
          categories: categories ?? [],
          isShowBoughtItemsOnly: isShowBoughtItemsOnly);
    }
    List<ItemModel> items = getItemsBy(
        listId: listId,
        category: "All",
        isShowBoughtItemsOnly: isShowBoughtItemsOnly);

    final filteredItems = items
        .where((element) =>
            element.itemName.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    return _categorizeItems(
        listId: listId,
        filteredItems: filteredItems,
        isShowBoughtItemsOnly: isShowBoughtItemsOnly);
  }

  List<String> getCategories({required String listId}) {
    return _items
        .where((element) => element.listId == listId)
        .map((e) => e.category)
        .toSet()
        .toList();
  }

  List<CategorizeItemsModel> _categorizeItems(
      {required String listId,
      List<ItemModel>? filteredItems,
      required bool isShowBoughtItemsOnly}) {
    final List<CategorizeItemsModel> categories;
    final List<ItemModel> items = filteredItems ??
        _items
            .where((element) => element.listId == listId)
            .where((element) => isShowBoughtItemsOnly
                ? element.boughtBy != null
                : element.boughtBy == null)
            .toList();
    Map<String, List<ItemModel>> groupedItems =
        items.fold({}, (Map<String, List<ItemModel>> map, item) {
      map[item.category] = [...(map[item.category] ?? []), item];
      return map;
    });

    categories = groupedItems.entries.map((entry) {
      return CategorizeItemsModel(category: entry.key, items: entry.value);
    }).toList();

    return categories;
  }

  List<CategorizeItemsModel> _getCategoriesItemsBy(
      {required List<String> categories,
      required String listId,
      required bool isShowBoughtItemsOnly}) {
    final List<CategorizeItemsModel> categoryItems = [];
    final List<CategorizeItemsModel> items = _categorizeItems(
        listId: listId, isShowBoughtItemsOnly: isShowBoughtItemsOnly);
    for (final String category in categories) {
      final int index = items.indexWhere((element) =>
          element.category.toLowerCase() == category.toLowerCase());
      if (index > -1) {
        categoryItems.add(items[index]);
      }
    }
    categoryItems.sort((a, b) => a.category.compareTo(b.category));
    return categoryItems;
  }

  List<ItemModel> getCompletedItemsBy({required String listId}) {
    final items = _items
        .where((element) =>
            element.listId == listId &&
            element.completedBy != null &&
            element.boughtBy == null)
        .toList();
    items.sort((a, b) =>
        a.isReadyToBuy.convertToInt().compareTo(b.isReadyToBuy.convertToInt()));
    return items;
  }

  List<ItemModel> getItemsBy(
      {String? category,
      required String listId,
      required bool isShowBoughtItemsOnly}) {
    final items = _items
        .where((element) => isShowBoughtItemsOnly
            ? element.boughtBy != null
            : element.boughtBy == null)
        .where((element) =>
            element.category.toLowerCase() == category?.toLowerCase() ||
            element.listId == listId)
        .toList();
    return items;
  }

  List<String> getItemsIdBy({required String listId}) {
    return _items
        .where((element) => element.listId == listId)
        .map((e) => e.id)
        .toList();
  }

  // ===========================API Methods================================
  // Add New Item Method
  Future<void> addItem(
      {required String itemName,
      required String listId,
      required String category,
      int? quantity,
      int? macros}) async {
    try {
      await DataValidation.addItem(title: itemName, category: category);
      final UserModel currentUser = UserRepo().currentUser;
      final ItemModel uploadingModel = ItemModel(
        id: "",
        createdAt: DateTime.now(),
        createdBy: currentUser.uid,
        itemName: itemName,
        category: category,
        listId: listId,
        isReadyToBuy: false,
        quantity: quantity,
      );
      final Map<String, dynamic> _ = await FirestoreService()
          .saveWithSpecificIdFiled(
              path: FIREBASE_COLLECTION_ITEMS,
              data: uploadingModel.toMap(),
              docIdFiled: 'id');
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  // Add New Item Method
  Future<void> updateItem({
    required String itemName,
    required String itemId,
    required String category,
    int? quantity,
  }) async {
    try {
      await DataValidation.addItem(title: itemName, category: category);
      await FirestoreService().updateWithDocId(
          path: FIREBASE_COLLECTION_ITEMS,
          data: {
            "itemName": itemName,
            'category': category,
            'quantity': quantity,
          },
          docId: itemId);
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  // Add New Item Method
  Future<void> updateIsReadyToBuy({
    required bool isReadyToBuy,
    required String itemId,
  }) async {
    try {
      await FirestoreService().updateWithDocId(
        path: FIREBASE_COLLECTION_ITEMS,
        data: {
          "isReadyToBuy": isReadyToBuy,
        },
        docId: itemId,
      );
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  Future<void> deleteItem({required String itemId}) async {
    try {
      await FirestoreService()
          .delete(collection: FIREBASE_COLLECTION_ITEMS, docId: itemId);
      _items.removeWhere(
          (element) => element.id.toLowerCase() == itemId.toLowerCase());
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  // Fetch All Items Method
  Future<void> fetchItems({
    required VoidCallback onGetAll,
    required VoidCallback onGetData,
    required Function(AppException) onError,
  }) async {
    await FirestoreService().fetchWithListener(
      collection: FIREBASE_COLLECTION_ITEMS,
      onError: (e) => throwAppException(e: e),
      onData: (data) {
        final ItemModel model = ItemModel.fromMap(data);

        final int index =
            _items.indexWhere((element) => element.id == model.id);
        if (index > -1) {
          // If Item Already existed
          _items[index] = model;
        } else {
          _items.add(model);
        }
        _items.sort((a, b) {
          return (a.completedBy?.completedAt.millisecondsSinceEpoch ?? 0)
              .compareTo(0);
        });
        onGetData();
      },
      onAllDataGet: onGetAll,
      onCompleted: (listener) {},
      queries: [
        QueryModel(
          field: "listId",
          value: ListRepo().lists.map((e) => e.id).toList(),
          type: QueryType.whereIn,
        ),
        QueryModel(field: "createdAt", value: false, type: QueryType.orderBy),
      ],
    );
  }

  // Move Items to User Items
  Future<void> moveItemsToUser(
      {required String fromList, required String forList}) async {
    final List<ItemModel> itemsToBeMoved =
        _items.where((element) => element.listId == fromList).toList();
    for (final ItemModel item in itemsToBeMoved) {
      await addItem(
        itemName: item.itemName,
        listId: forList,
        category: item.category,
        quantity: item.quantity,
      );
    }
  }

  // Fetch All Items For Admin List Method
  Future<void> fetchAdminItems({
    required VoidCallback onGetAll,
    required VoidCallback onGetData,
    required Function(AppException) onError,
  }) async {
    await FirestoreService().fetchWithListener(
      collection: FIREBASE_COLLECTION_ITEMS_ADMIN,
      onError: (e) => throwAppException(e: e),
      onData: (data) {
        final ItemModel model = ItemModel.fromMap(data);
        final int index =
            _items.indexWhere((element) => element.id == model.id);
        if (index > -1) {
          // If Item Already existed
          _items[index] = model;
        } else {
          _items.add(model);
        }
        _items.sort((a, b) {
          return (a.completedBy?.completedAt.millisecondsSinceEpoch ?? 0)
              .compareTo(0);
        });
        onGetData();
      },
      onAllDataGet: onGetAll,
      onCompleted: (listener) {},
      queries: [
        QueryModel(
          field: "listId",
          value: ListRepo().adminLists.map((e) => e.id).toList(),
          type: QueryType.whereIn,
        ),
        QueryModel(field: "createdAt", value: false, type: QueryType.orderBy),
      ],
    );
  }

  /// Mark Item Complete
  Future<void> markItemComplete({required String itemId}) async {
    try {
      final UserModel currentUser = UserRepo().currentUser;
      final ItemCompleteModel completedModel = ItemCompleteModel(
          completeBy: currentUser.uid, completedAt: DateTime.now());
      FirestoreService().updateWithDocId(
          path: FIREBASE_COLLECTION_ITEMS,
          docId: itemId,
          data: {"completedBy": completedModel.toMap()});
    } catch (e) {
      throwAppException(e: e);
    }
  }

  /// Mark Item Complete
  Future<void> removeItemComplete({required String itemId}) async {
    try {
      FirestoreService().updateWithDocId(
          path: FIREBASE_COLLECTION_ITEMS,
          docId: itemId,
          data: {"completedBy": null});
    } catch (e) {
      throwAppException(e: e);
    }
  }

  /// Mark Items Bought
  Future<void> markItemsBought(
      {required List<String> items, required String listId}) async {
    try {
      final UserModel currentUser = UserRepo().currentUser;
      for (final String item in items) {
        final ItemBoughtModel boughtModel = ItemBoughtModel(
            boughtBy: currentUser.uid, boughtAt: DateTime.now());
        await FirestoreService().updateWithDocId(
            path: FIREBASE_COLLECTION_ITEMS,
            docId: item,
            data: {"boughtBy": boughtModel.toMap()});
      }
      ListRepo().markListComplete(listId: listId);
    } catch (e) {
      throwAppException(e: e);
    }
  }
}

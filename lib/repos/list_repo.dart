// Project: 	   listi_shop
// File:    	   list_repo
// Path:    	   lib/repos/list_repo.dart
// Author:       Ali Akbar
// Date:        22-04-24 17:49:29 -- Monday
// Description:

import 'package:flutter/widgets.dart';

import '../exceptions/app_exceptions.dart';
import '../exceptions/exception_parsing.dart';
import '../models/list_model.dart';
import '../models/user_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import '../web_services/query_model.dart';
import 'item_repo.dart';
import 'user_repo.dart';
import 'validations/data_validations.dart';

class ListRepo {
  /// Singleton Instance
  static ListRepo _instance = ListRepo._internal();
  ListRepo._internal();
  factory ListRepo() => _instance;
  // ==============================Properties=============================
  final List<ListModel> _lists = [];
  final List<ListModel> _adminLists = [];
  List<ListModel> get adminLists => _adminLists;
  List<ListModel> get lists => _lists;

  void reset() {
    _instance = ListRepo._internal();
  }

// ===========================Methods================================
  /// Get Completed Lists
  List<ListModel> completedLists() {
    return _lists.where((element) => element.isCompleted == true).toList();
  }

  /// Craete List
  Future<String?> createList({
    required String title,
    required List<String> categories,
    String? referBy,
    String? referListId,
  }) async {
    try {
      final UserModel user = UserRepo().currentUser;
      await DataValidation.createList(categories: categories, title: title);
      final ListModel uploadingList = ListModel(
          id: "",
          createdBy: user.uid,
          title: title,
          categories: categories,
          isCompleted: false,
          sharedUsers: [user.uid],
          referBy: referBy,
          referListId: referListId,
          createdAt: DateTime.now());
      final Map<String, dynamic> mapped = await FirestoreService()
          .saveWithSpecificIdFiled(
              path: FIREBASE_COLLECTION_LISTS,
              data: uploadingList.toMap(),
              docIdFiled: 'id');
      return mapped['id'];
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  /// Update List
  Future<void> updateList({
    required String id,
    required String title,
    required List<String> categories,
  }) async {
    try {
      await DataValidation.createList(categories: categories, title: title);
      await FirestoreService().updateWithDocId(
        path: FIREBASE_COLLECTION_LISTS,
        docId: id,
        data: {
          "title": title,
          "categories": categories,
        },
      );
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  /// Delete List
  Future<void> deleteList({
    required String id,
    required List<String> itemsIds,
  }) async {
    try {
      await FirestoreService().delete(
        collection: FIREBASE_COLLECTION_LISTS,
        docId: id,
      );
      for (final String itemId in itemsIds) {
        await FirestoreService().delete(
          collection: FIREBASE_COLLECTION_ITEMS,
          docId: itemId,
        );
      }

      _lists.removeWhere(
          (element) => element.id.toLowerCase() == id.toLowerCase());
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  /// Fetch Lists
  Future<void> fetchLists(
      {required VoidCallback onData,
      required VoidCallback onAllDataGet,
      required Function(AppException) onError,
      required}) async {
    final UserModel user = UserRepo().currentUser;
    await FirestoreService().fetchWithListener(
      collection: FIREBASE_COLLECTION_LISTS,
      onError: (e) {
        onError(throwAppException(e: e));
      },
      onData: (Map<String, dynamic> data) {
        final ListModel model = ListModel.fromMap(data);
        final int index =
            _lists.indexWhere((element) => element.id == model.id);

        if (index > -1) {
          _lists[index] = model;
        } else {
          _lists.add(model);
        }

        onData();
      },
      onAllDataGet: onAllDataGet,
      onCompleted: (listener) {},
      queries: [
        QueryModel(
            field: "sharedUsers",
            value: [user.uid],
            type: QueryType.arrayContainsAny),
        QueryModel(field: 'createdAt', value: true, type: QueryType.orderBy),
      ],
    );
  }

  /// Fetch Lists
  Future<void> fetchAdminLists(
      {required VoidCallback onData,
      required VoidCallback onAllDataGet,
      required Function(AppException) onError,
      required}) async {
    await FirestoreService().fetchWithListener(
      collection: FIREBASE_COLLECTION_LISTS_ADMIN,
      onError: (e) {
        onError(throwAppException(e: e));
      },
      onData: (Map<String, dynamic> data) {
        final ListModel model = ListModel.fromMap(data);
        final int index =
            _adminLists.indexWhere((element) => element.id == model.id);
        if (index > -1) {
          _adminLists[index] = model;
        } else {
          _adminLists.add(model);
        }
        onData();
      },
      onAllDataGet: onAllDataGet,
      onCompleted: (listener) {},
      queries: [
        QueryModel(field: 'createdBy', value: 'admin', type: QueryType.isEqual),
      ],
    );
  }

  /// Move List To User
  Future<void> moveListToUser({required String listId}) async {
    try {
      final ListModel movedList =
          _adminLists.firstWhere((element) => element.id == listId);
      final String? id = await createList(
        title: movedList.title,
        categories: movedList.categories,
        referBy: "admin",
        referListId: listId,
      );
      if (id != null) {
        await ItemRepo().moveItemsToUser(fromList: listId, forList: id);
      }
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  /// Mark complete
  Future<void> markListComplete({required String listId}) async {
    final int index = _lists.indexWhere((element) => element.id == listId);
    if (index > -1) {
      final ListModel list = _lists[index];
      if (!list.isCompleted) {
        FirestoreService().updateWithDocId(
            path: FIREBASE_COLLECTION_LISTS,
            docId: listId,
            data: {"isCompleted": true});
        debugPrint("Marking $listId list to complete");
      }
    }
  }
}

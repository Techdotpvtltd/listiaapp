// Project: 	   listi_shop
// File:    	   list_repo
// Path:    	   lib/repos/list_repo.dart
// Author:       Ali Akbar
// Date:        22-04-24 17:49:29 -- Monday
// Description:

import 'dart:ui';

import '../exceptions/app_exceptions.dart';
import '../exceptions/exception_parsing.dart';
import '../models/list_model.dart';
import '../models/user_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import '../web_services/query_model.dart';
import 'user_repo.dart';
import 'validations/data_validations.dart';

class ListRepo {
  /// Singleton Instance
  static final ListRepo _instance = ListRepo._internal();
  ListRepo._internal();
  factory ListRepo() => _instance;
  // ==============================Properties=============================
  final List<ListModel> _lists = [];
  List<ListModel> get lists => _lists;

// ===========================Methods================================

  /// Craete List
  Future<void> createList(
      {required String title, required List<String> categories}) async {
    try {
      final UserModel user = UserRepo().currentUser;
      await DataValidation.createList(categories: categories, title: title);
      final ListModel uploadingList = ListModel(
          id: "",
          createdBy: user.uid,
          title: title,
          categories: categories,
          sharedUsers: [user.uid],
          createdAt: DateTime.now());
      final Map<String, dynamic> _ = await FirestoreService()
          .saveWithSpecificIdFiled(
              path: FIREBASE_COLLECTION_LISTS,
              data: uploadingList.toMap(),
              docIdFiled: 'id');
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
      },
      onAllDataGet: onAllDataGet,
      onCompleted: (listener) {},
      queries: [
        QueryModel(
            field: "sharedUsers",
            value: user.uid,
            type: QueryType.arrayContains),
        QueryModel(field: 'createdAt', value: true, type: QueryType.orderBy),
      ],
    );
  }
}

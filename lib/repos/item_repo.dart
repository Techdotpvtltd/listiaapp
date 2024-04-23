// Project: 	   listi_shop
// File:    	   item_repo
// Path:    	   lib/repos/item_repo.dart
// Author:       Ali Akbar
// Date:        23-04-24 13:34:19 -- Tuesday
// Description:

import '../exceptions/exception_parsing.dart';
import '../models/item_model.dart';
import '../models/user_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import 'user_repo.dart';
import 'validations/data_validations.dart';

class ItemRepo {
  // ===========================Singleton Instance================================
  static final ItemRepo _instance = ItemRepo._internal();
  ItemRepo._internal();
  factory ItemRepo() => _instance;

  // ===========================Properties================================
  final List<ItemModel> _items = [];
  List<ItemModel> get items => _items;

  // ===========================Methods================================

  // Add New Item Method
  Future<void> addItem(
      {required String itemName,
      required String listId,
      required String category,
      int? celeries,
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
        celeries: celeries,
        macros: macros,
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

  // Fetch All Items Method
  Future<void> fetchItems() async {}
}

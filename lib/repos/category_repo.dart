// Project: 	   listi_shop_admin
// File:    	   category_page
// Path:    	   lib/repos/category_page.dart
// Author:       Ali Akbar
// Date:        25-04-24 16:25:20 -- Thursday
// Description:

import '../exceptions/exception_parsing.dart';
import '../models/category_model.dart';
import '../models/user_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import '../web_services/query_model.dart';
import 'list_repo.dart';
import 'user_repo.dart';
import 'validations/data_validations.dart';

class CategoryRepo {
  // ===========================Signleton Instance================================
  static CategoryRepo _instance = CategoryRepo._internal();
  CategoryRepo._internal();
  factory CategoryRepo() => _instance;

  // ===========================Properties================================
  final List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  // ===========================Methods================================

  void reset() {
    _instance = CategoryRepo._internal();
  }

  List<CategoryModel> getCategoriesFrom({required List<String> categoryIds}) {
    final List<CategoryModel> nCategories = [];
    for (final String id in categoryIds) {
      final int index = _categories.indexWhere(
          (element) => element.id.toLowerCase() == id.toLowerCase());
      // debugPrint("$id == $index");
      if (index > -1) {
        nCategories.add(_categories[index]);
      }
    }
    return nCategories;
  }

  CategoryModel? getCategoryFrom({required String categoryId}) {
    final int index = _categories.indexWhere(
        (element) => element.id.toLowerCase() == categoryId.toLowerCase());
    if (index > -1) {
      return _categories[index];
    }
    return null;
  }

  // ===========================API Methods================================
  Future<void> addCategory({required String category}) async {
    try {
      await DataValidation.createCategory(name: category);
      final UserModel currentUser = UserRepo().currentUser;
      final CategoryModel uploadingModel = CategoryModel(
        id: "",
        item: category,
        createdAt: DateTime.now(),
        createdBy: currentUser.uid,
      );
      final Map<String, dynamic> map = await FirestoreService()
          .saveWithSpecificIdFiled(
              path: FIREBASE_COLLECTION_CATEGORY,
              data: uploadingModel.toMap(),
              docIdFiled: 'id');
      _categories.insert(0, CategoryModel.fromMap(map));
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  Future<void> fetchCategories() async {
    try {
      final UserModel currentUser = UserRepo().currentUser;
      final listCreaterIds =
          ListRepo().lists.map((e) => e.createdBy).toSet().toList();
      listCreaterIds.addAll([currentUser.uid, "admin"]);
      final List<Map<String, dynamic>> map =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_CATEGORY,
        queries: [
          QueryModel(
            field: 'createdBy',
            value: listCreaterIds,
            type: QueryType.whereIn,
          ),
        ],
      );
      for (final Map<String, dynamic> data in map) {
        final CategoryModel category = CategoryModel.fromMap(data);
        if (_categories.indexWhere((element) =>
                element.item.toLowerCase() == category.item.toLowerCase()) <
            0) {
          _categories.add(category);
        }
      }
    } catch (e) {
      throw throwAppException(e: e);
    }
  }
}

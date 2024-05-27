import 'package:listi_shop/utils/extensions/string_extension.dart';

import '../../exceptions/auth_exceptions.dart';
import '../../exceptions/data_exceptions.dart';
import '../../utils/utils.dart';
import '../category_repo.dart';

class DataValidation {
  static Future<void> loginUser({String? email, String? password}) async {
    if (email == null || email == "") {
      throw AuthExceptionEmailRequired();
    }

    if (!Util.isValidEmail(email: email)) {
      throw AuthExceptionInvalidEmail();
    }

    if (password == null || password == "") {
      throw AuthExceptionPasswordRequired();
    }
  }

  static Future<void> createList({String? title}) async {
    if (title == "" || title == null) {
      throw AuthExceptionRequiredField(
          message: "Please Enter list name.", errorCode: 1);
    }
  }

  static Future<void> addItem(
      {required String title, required String category}) async {
    if (title == "") {
      throw AuthExceptionRequiredField(
          message: "Please Enter item name.", errorCode: 1);
    }

    if (category == "") {
      throw AuthExceptionRequiredField(message: "Please select a category");
    }
  }

  static Future<void> createUser({
    String? name,
    String? password,
    String? confirmPassword,
    String? email,
    String? phone,
  }) async {
    if (name == null || name == "") {
      throw AuthExceptionFullNameRequired();
    }

    if (email == null || email == "") {
      throw AuthExceptionEmailRequired();
    }

    if (!Util.isValidEmail(email: email)) {
      throw AuthExceptionInvalidEmail();
    }

    if (phone == null || phone == "") {
      throw AuthExceptionRequiredPhone();
    }

    if (password == null || password == "") {
      throw AuthExceptionPasswordRequired();
    }

    if (password.length < 6) {
      throw AuthExceptionWeekPassword();
    }

    if (confirmPassword == null || confirmPassword == "") {
      throw AuthExceptionConfirmPasswordRequired();
    }

    if (confirmPassword != password) {
      throw AuthExceptionConfirmPasswordDoesntMatching();
    }
  }

  static Future<void> updateUser({
    String? name,
    String? email,
    String? phone,
  }) async {
    if (name == null || name == "") {
      throw AuthExceptionFullNameRequired();
    }

    if (email == null) {
      throw AuthExceptionEmailRequired();
    }

    if (!Util.isValidEmail(email: email)) {
      throw AuthExceptionInvalidEmail();
    }

    if (phone == null || phone == "") {
      throw AuthExceptionRequiredPhone();
    }
  }

  static Future<void> createCategory({
    required String name,
  }) async {
    if (!name.isValidString()) {
      throw DataExceptionRequiredField(
          message:
              "Category is invalid.\nRules:\n1. Category doesn't contain special character.\n2. Category must not be empty.",
          errorCode: 1000);
    }

    if (CategoryRepo()
        .categories
        .map((e) => e.item.toLowerCase())
        .contains(name.toLowerCase())) {
      throw DataExceptionRequiredField(
          message: "Category is already added.", errorCode: 1000);
    }
  }
}

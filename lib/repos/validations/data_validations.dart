import '../../exceptions/auth_exceptions.dart';
import '../../utils/utils.dart';

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

  static Future<void> createList(
      {String? title, required List<String> categories}) async {
    if (title == "" || title == null) {
      throw AuthExceptionRequiredField(
          message: "Please Enter list name.", errorCode: 1);
    }

    if (categories.isEmpty) {
      throw AuthExceptionRequiredField(
          message: "Please select at least 1 category");
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
}

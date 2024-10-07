import 'app_exceptions.dart';

abstract class AuthException extends AppException {
  AuthException({required super.message, super.errorCode});
}

//  Email Already in Used ====================================

class AuthExceptionEmailAlreadyInUse extends AuthException {
  AuthExceptionEmailAlreadyInUse({
    super.message = "Email is already used by another user.",
  });
}

class AuthExceptionUnAuthorized extends AuthException {
  AuthExceptionUnAuthorized({super.message = "Please login again."});
}

//  Email Already in Used ====================================
class AuthExceptionInvalidUserCredentials extends AuthException {
  AuthExceptionInvalidUserCredentials(
      {super.message = "Invalid email or password."});
}

/// when calling signInWithCredential with a credential that asserts an email address in use by another account.
/// This error will only be thrown if the "One account per email address" setting is enabled in the Firebase console (recommended).
class AuthExceptionAccountAlreadyExists extends AuthException {
  AuthExceptionAccountAlreadyExists(
      {super.message =
          "Anoother account is already existed with this credential."});
}

/// when trying to link a user with an corresponding to another account already in use.
class AuthExceptionAccountAlreadyLinked extends AuthException {
  AuthExceptionAccountAlreadyLinked(
      {super.message =
          "Anoother account is already linked with this credential"});
}

//  InValid Email ====================================
class AuthExceptionInvalidEmail extends AuthException {
  AuthExceptionInvalidEmail(
      {super.message = "Invalid Email.", super.errorCode = 1});
}

class AuthExceptionEmailVerificationRequired extends AuthException {
  AuthExceptionEmailVerificationRequired(
      {super.message =
          "We have sent a verification link at your email.\nPlease verify your email.",
      super.errorCode = 1});
}

//  operation-not-allowe ====================================
/// Thrown if email/password accounts are not enabled.
/// Enable email/password accounts in the Firebase Console, under the Auth tab.
class AuthExceptionOperationNotAllow extends AuthException {
  AuthExceptionOperationNotAllow(
      {super.message = "Oops! We're facing backend issue."});
}

//  Week Password ====================================
class AuthExceptionWeekPassword extends AuthException {
  AuthExceptionWeekPassword(
      {super.message = "Password must be greater then 5 characters.",
      super.errorCode = 2});
}

/// if the user has been disabled (for example, in the Firebase console)
class AuthExceptionDisabledUser extends AuthException {
  AuthExceptionDisabledUser({
    super.message = "You're not allow to login with this email.",
  });
}

//  User not found ====================================
class AuthExceptionUserNotFound extends AuthException {
  AuthExceptionUserNotFound(
      {super.message = "User not found with this email."});
}

/// if the user's token has been revoked in the backend.
///  This happens automatically if the user's credentials change in another device (for example, on a password change event).
class AuthExceptionUserTokenExpired extends AuthException {
  AuthExceptionUserTokenExpired({super.message = "Session expired."});
}

/// if the user's token is malformed. This should not happen under normal circumstances.
class AuthExceptionInvalidToken extends AuthException {
  AuthExceptionInvalidToken({super.message = "Invalid session."});
}

//  Wrong Password ====================================
class AuthExceptionWrongPassword extends AuthException {
  AuthExceptionWrongPassword(
      {super.message = "Incorrect password.", super.errorCode = 2});
}

//  First Name Required ====================================
class AuthExceptionFirstNameRequired extends AuthException {
  AuthExceptionFirstNameRequired(
      {super.message = "Please enter your first name", super.errorCode = 3});
}

class AuthExceptionFullNameRequired extends AuthException {
  AuthExceptionFullNameRequired(
      {super.message = "Please enter your name", super.errorCode = 3});
}

//  Last Name Required ====================================
class AuthExceptionLastNameRequired extends AuthException {
  AuthExceptionLastNameRequired(
      {super.message = "Please enter your Last name", super.errorCode = 4});
}

//  Email  Required ====================================
class AuthExceptionEmailRequired extends AuthException {
  AuthExceptionEmailRequired(
      {super.message = "Please enter your email.", super.errorCode = 1});
}

//  Password  Required ====================================
class AuthExceptionPasswordRequired extends AuthException {
  AuthExceptionPasswordRequired(
      {super.message = "Please enter password.", super.errorCode = 2});
}

//  Confirm Password  Required ====================================
class AuthExceptionConfirmPasswordRequired extends AuthException {
  AuthExceptionConfirmPasswordRequired(
      {super.message = "Please enter confirm password.", super.errorCode = 5});
}

//  Confirm Password doesn't matching  ====================================
class AuthExceptionConfirmPasswordDoesntMatching extends AuthException {
  AuthExceptionConfirmPasswordDoesntMatching(
      {super.message = "Password doesn't match.", super.errorCode = 5});
}

//  Location Required  ====================================
class AuthExceptionLocationRequired extends AuthException {
  AuthExceptionLocationRequired(
      {super.message = "Please select the location.", super.errorCode = 6});
}

//  Phone Number Required Required  ====================================
class AuthExceptionRequiredPhone extends AuthException {
  AuthExceptionRequiredPhone(
      {super.message = "Please add phone number.", super.errorCode = 1012});
}

//  Agent Required Required  ====================================
class AuthExceptionRequiredAgent extends AuthException {
  AuthExceptionRequiredAgent(
      {super.message = "Please select agent.", super.errorCode = 1022});
}

//  Address Required Required  ====================================
class AuthExceptionRequiredAddress extends AuthException {
  AuthExceptionRequiredAddress(
      {super.message = "Please add address.", super.errorCode = 1042});
}

//  Field Required Required  ====================================
class AuthExceptionRequiredField extends AuthException {
  AuthExceptionRequiredField({required super.message, super.errorCode});
}

//  Unknown Error ====================================
class AuthExceptionUnknown extends AuthException {
  AuthExceptionUnknown({required super.message});
}

AuthException throwAuthException({required String errorCode, String? message}) {
  switch (errorCode.toLowerCase()) {
    case 'invalid_login_credentials':
      return AuthExceptionInvalidUserCredentials();
    case 'user-not-found':
      return AuthExceptionUserNotFound();
    case 'user-disabled':
      return AuthExceptionDisabledUser();
    case 'error-user-token-expired':
    case 'user-token-expired':
      return AuthExceptionUserTokenExpired();
    case 'error-invalid-user-token':
    case 'invalid-user-token':
      return AuthExceptionInvalidToken();
    case "email-already-in-use":
      return AuthExceptionEmailAlreadyInUse();
    case 'invalid-email':
      return AuthExceptionInvalidEmail();
    case 'operation-not-allowed':
      return AuthExceptionOperationNotAllow();
    case 'weak-password':
      return AuthExceptionWeekPassword();
    case 'error-account-exists-with-different-credential':
      return AuthExceptionAccountAlreadyExists();
    case 'error-credential-already-in-use':
      return AuthExceptionAccountAlreadyLinked();
    default:
      return AuthExceptionUnknown(message: message ?? "Something went wrong!");
  }
}

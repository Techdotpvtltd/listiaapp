import 'package:firebase_auth/firebase_auth.dart';
import '../exceptions/auth_exceptions.dart';
import '../exceptions/exception_parsing.dart';
import '../utils/utils.dart';
import '../web_services/firebase_auth_serivces.dart';
import 'user_repo.dart';
import 'validations/data_validations.dart';

class AuthRepo {
  int userFetchFailureCount = 0;
  //  LoginUser ====================================
  Future<void> loginUser(
      {required String withEmail, required String withPassword}) async {
    try {
      // Make Validation
      await DataValidation.loginUser(email: withEmail, password: withPassword);
      final _ = await FirebaseAuthService()
          .login(withEmail: withEmail, withPassword: withPassword);
      await UserRepo().fetch();
    } catch (e) {
      throw thrownAppException(e: e);
    }
  }

  Future<void> sendEmailVerifcationLink() async {
    try {
      await FirebaseAuthService().sendEmailVerifcationLink();
    } catch (e) {
      throw thrownAppException(e: e);
    }
  }

//  RegisteredAUser ====================================
  Future<void> registeredUser({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required String phoenNumber,
  }) async {
    try {
      /// Make validation
      await DataValidation.createUser(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
        phone: phoenNumber,
      );

      // Create user After validation
      final UserCredential userCredential = await FirebaseAuthService()
          .registerUser(email: email, password: password);
      await UserRepo().create(
        uid: userCredential.user?.uid ?? "",
        name: name,
        email: email,
        phoneNumber: phoenNumber,
      );
    } catch (e) {
      throw thrownAppException(e: e);
    }
  }

  /// Return Login user object
  User? currentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  /// Perform Logout
  Future<void> performLogout() async {
    await FirebaseAuthService().logoutUser();
    UserRepo().clearAll();
  }

  /// Perform Logout
  Future<void> sendForgotPasswordEmail({required String atMail}) async {
    if (atMail == "") {
      throw AuthExceptionEmailRequired();
    }

    if (!Util.isValidEmail(email: atMail)) {
      throw AuthExceptionInvalidEmail();
    }
    await FirebaseAuthService().resetPassword(email: atMail);
  }
}


// =========================== Social Auth Methods ================================
  // //  Login With Apple ====================================
  // Future<void> loginWithApple() async {
  //   try {
  //     final credential = await SignInWithApple.getAppleIDCredential(scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ]);

  //     AuthCredential authCredential = OAuthProvider("apple.com").credential(
  //         accessToken: credential.authorizationCode,
  //         idToken: credential.identityToken);
  //     await FirebaseAuthService()
  //         .loginWithCredentials(credential: authCredential);
  //     await _fetchOrCreateUser();
  //   } catch (e) {
  //     throw thrownAppException(e: e);
  //   }
  // }

  /// Mostly used for Social Account Authenticatopn
  // Future<void> _fetchOrCreateUser() async {
  //   try {
  //     await UserRepo().fetch();
  //     userFetchFailureCount = 0;
  //   } on AppException catch (e) {
  //     if (UserRepo().isUserNull || e is AuthExceptionUserNotFound) {
  //       final User? user = FirebaseAuth.instance.currentUser;

  //       if (user != null) {
  //         if (userFetchFailureCount <= 1) {
  //           await UserRepo().create(
  //               uid: user.uid,
  //               name: user.displayName ?? "",
  //               avatarUrl: user.photoURL,
  //               phoneNumber: user.phoneNumber,
  //               email: user.email ?? "");
  //           _fetchOrCreateUser();
  //         } else {
  //           throw thrownAppException(e: e);
  //         }
  //         userFetchFailureCount += 1;
  //       }
  //       return;
  //     }
  //     throw thrownAppException(e: e);
  //   }
  // }

  // //  Login With Google ====================================
  // Future<void> loginWithGoogle() async {
  //   try {
  //     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;

  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );
  //     await FirebaseAuthService().loginWithCredentials(credential: credential);
  //     await _fetchOrCreateUser();
  //   } catch (e) {
  //     throw thrownAppException(e: e);
  //   }
  // }

  

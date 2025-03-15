import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  late FirebaseAuth _auth;
  FirebaseAuthService() {
    _auth = FirebaseAuth.instance;
  }

// Create New User ====================================
  Future<UserCredential> registerUser({
    required String email,
    required String password,
  }) async {
    final user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await _auth.currentUser?.sendEmailVerification();
    return user;
  }

  // Login User With Email ====================================
  Future<UserCredential> login(
      {required String withEmail, required String withPassword}) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: withEmail, password: withPassword);
    return credential;
  }

  Future<void> sendEmailVerifcationLink() async {
    _auth.currentUser?.sendEmailVerification();
  }

  // Login User With Credentials ====================================
  Future<UserCredential> loginWithCredentials(
      {required AuthCredential credential}) async {
    return await _auth.signInWithCredential(credential);
  }

// Send Reset Password Mail ====================================
  Future<void> resetPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  //  Logout User ====================================
  Future<void> logoutUser() async {
    await _auth.signOut();
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../exceptions/exception_parsing.dart';

import '../../web_services/firestore_services.dart';
import '../../exceptions/data_exceptions.dart';
import '../exceptions/auth_exceptions.dart';
import '../models/user_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/query_model.dart';
import '../web_services/storage_services.dart';
import 'validations/data_validations.dart';

class UserRepo {
  /// This class is used to get data/ request from user business layer and send
  /// to network layer.
  /// This class is used to parse user data from network layer and return back to
  /// business layer.
  ///

  static final UserRepo _instance = UserRepo._internal();
  UserModel? _userModel;
  UserModel get currentUser =>
      _userModel == null ? throw AuthExceptionUserNotFound() : _userModel!;
  bool get isUserNull => _userModel == null;

  UserRepo._internal();

  /// Promise to return instance
  factory UserRepo() => _instance;

  /// Clear all
  void clearAll() {
    _userModel = null;
  }

  /// Fetch user
  Future<void> fetch() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser?.emailVerified == false) {
        throw AuthExceptionEmailVerificationRequired();
      }
      debugPrint("user id = ${currentUser?.uid}");
      final data = await FirestoreService().fetchSingleRecord(
          path: FIREBASE_COLLECTION_USER, docId: currentUser?.uid ?? "");

      if (data == null) {
        throw AuthExceptionUserNotFound();
      }

      final UserModel userModel = UserModel.fromMap(data);
      _userModel = userModel;
      debugPrint("user id = $_userModel");
    } catch (e) {
      throw thrownAppException(e: e);
    }
  }

  /// Create User Profile
  Future<void> create({
    required String uid,
    required String name,
    required String email,
    required String phoneNumber,
    String? avatarUrl,
  }) async {
    try {
      if (uid == "") {
        throw AuthExceptionUnAuthorized();
      }

      final UserModel user = UserModel(
        uid: uid,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        avatar: avatarUrl ?? "",
      );

      final Map<String, dynamic> data = await FirestoreService().saveWithDocId(
        path: FIREBASE_COLLECTION_USER,
        docId: user.uid,
        data: user.toMap(),
      );
      _userModel = UserModel.fromMap(data);
    } catch (e) {
      debugPrint(e.toString());
      throw thrownAppException(e: e);
    }
  }

  //  Update user Profile ====================================
  Future<UserModel> update({
    required String name,
    required String email,
    required String phone,
    String? imagePath,
  }) async {
    try {
      await DataValidation.updateUser(
        name: name,
        email: email,
        phone: phone,
      );

      /// There is no user profile
      if (_userModel == null) {
        final UserModel model = UserModel(
          uid: FirebaseAuth.instance.currentUser?.uid ?? "",
          name: name,
          email: email,
          phoneNumber: phone,
          createdAt: DateTime.now(),
          avatar: imagePath ?? "",
        );
        await FirestoreService().saveWithDocId(
          path: FIREBASE_COLLECTION_USER,
          docId: model.uid,
          data: model.toMap(),
        );
        _userModel = model;
        return _userModel!;
      }
      final UserModel updatedModel = _userModel!.copyWith(
        name: name,
        email: email,
        avatar: imagePath,
        phoneNumber: phone,
      );

      await FirestoreService().updateWithDocId(
          path: FIREBASE_COLLECTION_USER,
          docId: updatedModel.uid,
          data: updatedModel.toMap());
      _userModel = updatedModel;
      return _userModel!;
    } catch (e) {
      debugPrint(e.toString());
      throw thrownAppException(e: e);
    }
  }

  /// Upload User Profile
  Future<String> uploadProfile({required String path}) async {
    try {
      final String collectionPath =
          "$FIREBASE_COLLECTION_USER_PROFILES/${UserRepo().currentUser.uid}";
      return await StorageService()
          .uploadImage(withFile: File(path), collectionPath: collectionPath);
    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      throw e is FirebaseAuthException
          ? throwAuthException(errorCode: e.code)
          : throwDataException(errorCode: e.code);
    } catch (e) {
      debugPrint(e.toString());
      throw DataExceptionUnknown(message: e.toString());
    }
  }

  // Fetch Profile
  Future<UserModel> fetchUser({required String profileId}) async {
    try {
      final List<Map<String, dynamic>> data = await FirestoreService()
          .fetchWithMultipleConditions(
              collection: FIREBASE_COLLECTION_USER,
              queries: [
            QueryModel(field: "uid", value: profileId, type: QueryType.isEqual),
          ]);
      // ignore: sdk_version_since
      if (data.firstOrNull != null) {
        return UserModel.fromMap(data.first);
      }
      throw throwAuthException(errorCode: 'user-not-found');
    } catch (e) {
      throw thrownAppException(e: e);
    }
  }
}

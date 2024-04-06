import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'query_model.dart';

class FirestoreService {
  late final FirebaseFirestore _firestore;

  FirestoreService() {
    _firestore = FirebaseFirestore.instance;
  }

//  Save & Update Services ====================================

  ///  Save Data without DocumentId ====================================
  Future<Map<String, dynamic>> saveWithoutDocId(
      {required String path, required Map<String, dynamic> data}) async {
    await _firestore.collection(path).doc().set(data);
    return data;
  }

  /// Save Data With DocumentId
  Future<Map<String, dynamic>> saveWithDocId(
      {required String path,
      required String docId,
      required Map<String, dynamic> data}) async {
    await _firestore.collection(path).doc(docId).set(data);
    return data;
  }

  /// Save Data Without DocId and return with docId field
  /// Save Data With DocumentId
  Future<Map<String, dynamic>> saveWithSpecificIdFiled(
      {required String path,
      required Map<String, dynamic> data,
      required String docIdFiled}) async {
    final doc = _firestore.collection(path).doc();
    data[docIdFiled] = doc.id;

    /// Save Id in specific fieldz
    await doc.set(data);
    return data;
  }

  /// Update Data with document id
  Future<Map<String, dynamic>> updateWithDocId(
      {required String path,
      required String docId,
      required Map<String, dynamic> data}) async {
    await _firestore.collection(path).doc(docId).update(data);
    return data;
  }

  /// Update Data with document id
  Future<Map<String, dynamic>> updateDataWithDocId(
      {required String path,
      required String docId,
      required Map<String, dynamic> data}) async {
    await _firestore
        .collection(path)
        .doc(docId)
        .set(data, SetOptions(merge: true));
    return data;
  }

//  Fetch Services ====================================
  Future<Map<String, dynamic>?> fetchSingleRecord({
    required String path,
    required String docId,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> reference =
        await _firestore.collection(path).doc(docId).get();
    return reference.data();
  }

  /// Mutliple records fetching method
  @Deprecated("Use fetchWithMultipleConditions instead")
  Future<List<Map<String, dynamic>>> fetchRecords({
    required String collection,
  }) async {
    final QuerySnapshot snapshot =
        await _firestore.collection(collection).get();
    return snapshot.docs
        .map((e) => e.data() as Map<String, dynamic>? ?? <String, dynamic>{})
        .toList();
  }

  /// Mutliple records fetching query method
  Future<List<Map<String, dynamic>>> _getWithQuery(
      {required Query<Map<String, dynamic>> query}) async {
    final snapshot = await query.get();
    return snapshot.docs.map((e) => e.data()).toList();
  }

  /// With Equal Condition
  @Deprecated("Use fetchWithMultipleConditions instead")
  Future<List<Map<String, dynamic>>> fetchWithEqual({
    required String collection,
    required String filedId,
    required dynamic isEqualTo,
  }) async {
    final Query<Map<String, dynamic>> query =
        _firestore.collection(collection).where(filedId, isEqualTo: isEqualTo);
    return _getWithQuery(query: query);
  }

  /// with multiple conditions
  Future<List<Map<String, dynamic>>> fetchWithMultipleConditions({
    required String collection,
    required List<QueryModel> queries,
  }) async {
    final CollectionReference<Map<String, dynamic>> collectionReference =
        _firestore.collection(collection);

    Query<Map<String, dynamic>> query = collectionReference;

    for (QueryModel condition in queries) {
      switch (condition.type) {
        case QueryType.isEqual:
          query = query.where(condition.field, isEqualTo: condition.value);
          break;
        //Note: isNotEqual will not work if you have already add other queries
        case QueryType.isNotEqual:
          query = query.where(condition.field, isNotEqualTo: condition.value);
          break;
        case QueryType.whereIn:
          query = query.where(condition.field, whereIn: condition.value);
          break;
        // Note: WhereNotIn will not work if you have already add isEqual or isNotEqual
        case QueryType.whereNotIn:
          query = query.where(condition.field, whereNotIn: condition.value);
          break;
        case QueryType.arrayContains:
          query = query.where(condition.field, arrayContains: condition.value);
          break;
        case QueryType.arrayContainsAny:
          query =
              query.where(condition.field, arrayContainsAny: condition.value);
          break;
        case QueryType.isGreaterThan:
          query = query.where(condition.field, isGreaterThan: condition.value);
          break;
        case QueryType.isGreaterThanOrEqual:
          query = query.where(condition.field,
              isGreaterThanOrEqualTo: condition.value);
          break;

        case QueryType.isLessThan:
          query = query.where(condition.field, isLessThan: condition.value);
          break;

        case QueryType.isLessThanOrEqual:
          query = query.where(condition.field,
              isLessThanOrEqualTo: condition.value);
          break;

        case QueryType.orderBy:
          query = query.orderBy(condition.field, descending: condition.value);
          break;

        case QueryType.startAt: // Add OrderBy query first
          query = query.startAt(condition.value);
          break;

        case QueryType.startAfter: // Add OrderBy query first
          query = query.startAfter(condition.value);
          break;

        case QueryType.endAt: // Add OrderBy query first
          query = query.endAt(condition.value);
          break;

        case QueryType.endBefore: // Add OrderBy query first
          query = query.endBefore(condition.value);
          break;

        case QueryType.limit: // Add OrderBy query first
          query = query.limit(condition.value);
          break;

        case QueryType.limitToLast: // Add OrderBy query first
          query = query.limitToLast(condition.value);
          break;

        default:
          query = collectionReference;
      }
    }

    debugPrint(query.parameters.toString());
    return _getWithQuery(query: query);
  }

  //  Delete Services ====================================
  Future<void> delete(
      {required String collection, required String docId}) async {
    final ref = _firestore.collection(collection).doc(docId);
    await ref.delete();
  }
}

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
  Future<Map<String, dynamic>> updateWithDocId({
    required String path,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
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

  Query<Map<String, dynamic>> _generateQuery(
      {required List<QueryModel> queries,
      required CollectionReference<Map<String, dynamic>> collectionReference}) {
    Query<Map<String, dynamic>> query = collectionReference;
    for (QueryModel condition in queries) {
      switch (condition.type) {
        case QueryType.isEqual:
          query = query.where(condition.field, isEqualTo: condition.value);
          break; //Note: isNotEqual will not work if you have already add other queries
        case QueryType.isNotEqual:
          query = query.where(condition.field, isNotEqualTo: condition.value);
          break;
        case QueryType.whereIn:
          query = query.where(condition.field, whereIn: condition.value);
          break; // Note: WhereNotIn will not work if you have already add isEqual or isNotEqual
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
          break;
      }
    }
    debugPrint(query.parameters.toString());
    return query;
  }

  /// Fetch With Listener
  Future<void> fetchWithListener({
    required String collection,
    required Function(dynamic) onError,
    required Function(Map<String, dynamic>) onData,
    required VoidCallback onAllDataGet,
    required Function(
            StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? listener)
        onCompleted,
    required List<QueryModel> queries,
  }) async {
    final collectionReference = _firestore.collection(collection);

    final Query<Map<String, dynamic>> query = _generateQuery(
        queries: queries, collectionReference: collectionReference);
    // Create a Completer to signal completion
    Completer<void> completer = Completer<void>();

    final listener = query.snapshots().listen(
      (querySnapshot) {
        for (final change in querySnapshot.docChanges) {
          final Map<String, dynamic>? data = change.doc.data();
          if (data != null) {
            onData(data);
          }
        }
        onAllDataGet();
      },
      onError: (e) {
        debugPrint(e.toString());
        onError(e);
      },
      onDone: () {
        completer.complete();
        onCompleted(null);
      },
    );
    // Wait for the operation to complete before returning
    await completer.future;
    onCompleted(listener);
  }

  /// with multiple conditions
  Future<List<Map<String, dynamic>>> fetchWithMultipleConditions({
    required String collection,
    required List<QueryModel> queries,
  }) async {
    final CollectionReference<Map<String, dynamic>> collectionReference =
        _firestore.collection(collection);

    final Query<Map<String, dynamic>> query = _generateQuery(
        queries: queries, collectionReference: collectionReference);

    return _getWithQuery(query: query);
  }

  //  Delete Services ====================================
  Future<void> delete(
      {required String collection, required String docId}) async {
    final ref = _firestore.collection(collection).doc(docId);
    await ref.delete();
  }

  /// Copy  all data from one collection to another collection

  Future<void> copyData(
      {required String fromCollection, required String toCollection}) async {
    final fromSnap = await _firestore.collection(fromCollection).get();
    final toRef = _firestore.collection(toCollection);
    for (final doc in fromSnap.docs) {
      await toRef.doc(doc.id).set(doc.data());
      debugPrint("Set doc-${doc.id}");
    }
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../exceptions/data_exceptions.dart';
import 'query_model.dart';
import 'reference_model.dart';

class FirestoreService {
  late final FirebaseFirestore _firestore;

  FirestoreService() {
    _firestore = FirebaseFirestore.instance;

    ///To Get Most recent update from the cloud, disabled it
    _firestore.settings = const Settings(persistenceEnabled: false);
  }

  Future<dynamic> save(
      {required List<FirePathReference> refs,
      required Map<String, dynamic> payload,
      String? returnDocIdWithField}) async {
    final docRef = await _getDocRef(refs);
    if (returnDocIdWithField != null) {
      payload[returnDocIdWithField] = docRef.id;
    }
    await docRef.set(payload);
    return payload;
  }

  Future<dynamic> update(
      {required List<FirePathReference> refs,
      required Map<String, dynamic> payload}) async {
    final docRef = await _getDocRef(refs);
    await docRef.set(payload, SetOptions(merge: true));
    return payload;
  }

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

  Future<Map<String, dynamic>?> fetch(
      {required List<FirePathReference> refs}) async {
    final ref = await _getDocRef(refs);
    final documentSnap = await ref.get();

    return documentSnap.data() as Map<String, dynamic>?;
  }

  @Deprecated("Use fetch")
//  Fetch Services ====================================
  Future<Map<String, dynamic>?> fetchSingleRecord({
    required String path,
    required String docId,
  }) async {
    final DocumentSnapshot<Map<String, dynamic>> reference =
        await _firestore.collection(path).doc(docId).get();
    return reference.data();
  }

  /// Fetch With Listener
  Future<void> fetchWithListener({
    required String collection,
    required Function(dynamic) onError,
    required Function(Map<String, dynamic>) onAdded,
    required Function(Map<String, dynamic>) onRemoved,
    required Function(Map<String, dynamic>) onUpdated,
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
            if (change.type.name == "removed") {
              onRemoved(data);
            }

            if (change.type.name == "added") {
              onAdded(data);
            }

            if (change.type.name == "modified") {
              onUpdated(data);
            }
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

  Future<List<Map<String, dynamic>>> fetchRecords({
    required List<FirePathReference> refs,
    required List<QueryModel> queries,
    Function(DocumentSnapshot?)? lastDocSnapshot,
  }) async {
    final CollectionReference<Map<String, dynamic>> collectionReference =
        _getCollectionRef(refs: refs);
    final Query<Map<String, dynamic>> query = _generateQuery(
        queries: queries, collectionReference: collectionReference);
    return _getWithQuery(
      query: query,
      lastDocSnapshot: (snapshot) {
        if (lastDocSnapshot != null) {
          lastDocSnapshot(snapshot);
        }
      },
    );
  }

  // with multiple conditions
  @Deprecated("Use fetchRecords")
  Future<List<Map<String, dynamic>>> fetchWithMultipleConditions({
    required String collection,
    required List<QueryModel> queries,
    Function(DocumentSnapshot?)? lastDocSnapshot,
  }) async {
    final CollectionReference<Map<String, dynamic>> collectionReference =
        _firestore.collection(collection);

    final Query<Map<String, dynamic>> query = _generateQuery(
        queries: queries, collectionReference: collectionReference);
    return _getWithQuery(
      query: query,
      lastDocSnapshot: (snapshot) {
        if (lastDocSnapshot != null) {
          lastDocSnapshot(snapshot);
        }
      },
    );
  }

  //  Delete Services ====================================
  Future<void> deleteOld(
      {required String collection, required String docId}) async {
    final ref = _firestore.collection(collection).doc(docId);
    await ref.delete();
  }

  Future<void> delete(
      {required List<FirePathReference> refs, required String docId}) async {
    final docRef = await _getDocRef(refs);
    docRef.delete();
  }

  /// Copy  all data from one collection to another collection

  Future<void> copyData(
      {required String fromCollection, required String toCollection}) async {
    final fromSnap = await _firestore.collection(fromCollection).get();
    final toRef = _firestore.collection(toCollection);
    for (final doc in fromSnap.docs) {
      await toRef.doc(doc.id).set(doc.data());
    }
  }
}

extension _FireExt on FirestoreService {
  CollectionReference<Map<String, dynamic>> _getCollectionRef(
      {required List<FirePathReference> refs}) {
    dynamic pathReference = _firestore;
    for (final ref in refs) {
      if (ref.type == FIREReferenceType.collection) {
        if (pathReference is DocumentReference ||
            pathReference is FirebaseFirestore) {
          pathReference = pathReference.collection(ref.path);
        }
      }

      if (ref.type == FIREReferenceType.doc) {
        if (pathReference is CollectionReference) {
          pathReference = pathReference.doc(ref.path);
        } else {
          throw DataExceptionInvalidArgument(
              message: "Please add collection type first");
        }
      }
    }

    // check if the type is DocumentReference, it means last one is doc.
    if (pathReference is DocumentReference) {
      throw DataExceptionInvalidArgument(
          message: "Last one must be a collection");
    }

    return pathReference;
  }

  Future<DocumentReference<Object?>> _getDocRef(
      List<FirePathReference> refs) async {
    dynamic pathReference = _firestore;

    for (final ref in refs) {
      if (ref.type == FIREReferenceType.collection) {
        if (pathReference is DocumentReference ||
            pathReference is FirebaseFirestore) {
          pathReference = pathReference.collection(ref.path);
        }
      }

      if (ref.type == FIREReferenceType.doc) {
        if (pathReference is CollectionReference) {
          pathReference = pathReference.doc(ref.path);
        } else {
          throw DataExceptionInvalidArgument(
              message: "Please add collection type first");
        }
      }
    }

    if (pathReference is CollectionReference) {
      return pathReference.doc();
    }
    if (pathReference is DocumentReference) {
      return pathReference;
    }

    throw DataExceptionInvalidArgument(message: "Invalid reference added");
  }

  /// Mutliple records fetching query method
  Future<List<Map<String, dynamic>>> _getWithQuery(
      {required Query<Map<String, dynamic>> query,
      required Function(DocumentSnapshot?) lastDocSnapshot}) async {
    final snapshot =
        await query.get(const GetOptions(source: Source.serverAndCache));

    lastDocSnapshot(snapshot.docs.lastOrNull);

    return snapshot.docs.map((e) => e.data()).toList();
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
        case QueryType.startAfterDocument:
          // Take document as value and fetch after that document. he starting position is relative to the order of the query.
          // The [documentSnapshot] must contain all of the fields provided in the orderBy of this query.
          query = query.startAfterDocument(condition.value);
          break;
        case QueryType.startAtDocument:
          //Creates and returns a new [Query] that starts at the provided document (inclusive). The starting position is relative to the order of the query. The document must contain all of the fields provided in the orderBy of this query.
          ///Calling this method will replace any existing cursor "start" query modifiers.
          query = query.startAtDocument(condition.value);
          break;
      }
    }
    // debugPrint(query.parameters.toString());
    return query;
  }
}

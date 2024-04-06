// ignore_for_file: public_member_api_docs, sort_constructors_first

// ignore: dangling_library_doc_comments
/// Project: 	   CarRenterApp
/// File:    	   query_model
/// Path:    	   lib/models/query_model.dart
/// Author:       Ali Akbar
/// Date:        29-02-24 15:37:09 -- Thursday
/// Description:

class QueryModel {
  final String field;
  final dynamic value;
  final QueryType type;
  QueryModel({
    required this.field,
    required this.value,
    required this.type,
  });
}

enum QueryType {
  isEqual,
  isNotEqual,
  isLessThan,
  isLessThanOrEqual,
  isGreaterThan,
  isGreaterThanOrEqual,
  whereIn,
  whereNotIn,
  arrayContains,
  arrayContainsAny,
  orderBy,
  limit,
  limitToLast,
  startAt,
  startAfter,
  endAt,
  endBefore,
}

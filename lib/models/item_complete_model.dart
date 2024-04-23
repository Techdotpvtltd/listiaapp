// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// Project: 	   listi_shop
// File:    	   item_complete_model
// Path:    	   lib/models/item_complete_model.dart
// Author:       Ali Akbar
// Date:        23-04-24 16:47:07 -- Tuesday
// Description:

class ItemCompleteModel {
  final String completeBy;
  final DateTime completedAt;
  ItemCompleteModel({
    required this.completeBy,
    required this.completedAt,
  });

  ItemCompleteModel copyWith({
    String? completeBy,
    DateTime? completedAt,
  }) {
    return ItemCompleteModel(
      completeBy: completeBy ?? this.completeBy,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'completeBy': completeBy,
      'completedAt': Timestamp.fromDate(completedAt),
    };
  }

  factory ItemCompleteModel.fromMap(Map<String, dynamic> map) {
    return ItemCompleteModel(
      completeBy: map['completeBy'] as String,
      completedAt: (map['completedAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemCompleteModel.fromJson(String source) =>
      ItemCompleteModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ItemCompleteModel(completeBy: $completeBy, completedAt: $completedAt)';

  @override
  bool operator ==(covariant ItemCompleteModel other) {
    if (identical(this, other)) return true;

    return other.completeBy == completeBy && other.completedAt == completedAt;
  }

  @override
  int get hashCode => completeBy.hashCode ^ completedAt.hashCode;
}

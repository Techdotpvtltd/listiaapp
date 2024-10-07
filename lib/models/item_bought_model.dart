// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// Project: 	   listi_shop
// File:    	   item_bought_model
// Path:    	   lib/models/item_bought_model.dart
// Author:       Ali Akbar
// Date:        24-04-24 17:48:12 -- Wednesday
// Description:

class ItemBoughtModel {
  final String boughtBy;
  final DateTime boughtAt;
  ItemBoughtModel({
    required this.boughtBy,
    required this.boughtAt,
  });

  ItemBoughtModel copyWith({
    String? boughtBy,
    DateTime? boughtAt,
  }) {
    return ItemBoughtModel(
      boughtBy: boughtBy ?? this.boughtBy,
      boughtAt: boughtAt ?? this.boughtAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'boughtBy': boughtBy,
      'boughtAt': Timestamp.fromDate(boughtAt),
    };
  }

  factory ItemBoughtModel.fromMap(Map<String, dynamic> map) {
    return ItemBoughtModel(
      boughtBy: map['boughtBy'] as String,
      boughtAt: (map['boughtAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemBoughtModel.fromJson(String source) =>
      ItemBoughtModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ItemBoughtModel(boughtBy: $boughtBy, boughtAt: $boughtAt)';

  @override
  bool operator ==(covariant ItemBoughtModel other) {
    if (identical(this, other)) return true;

    return other.boughtBy == boughtBy && other.boughtAt == boughtAt;
  }

  @override
  int get hashCode => boughtBy.hashCode ^ boughtAt.hashCode;
}

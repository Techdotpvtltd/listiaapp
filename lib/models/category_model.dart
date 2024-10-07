// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listi_shop/utils/extensions/string_extension.dart';

// Project: 	   listi_shop
// File:    	   category_model
// Path:    	   lib/models/category_model.dart
// Author:       Ali Akbar
// Date:        22-04-24 18:06:37 -- Monday
// Description:

class CategoryModel {
  final String id;
  final String item;
  final DateTime createdAt;
  final String createdBy;
  final bool isCreatedByAdmin;
  CategoryModel({
    required this.id,
    required this.item,
    required this.createdAt,
    required this.createdBy,
    this.isCreatedByAdmin = false,
  });

  CategoryModel copyWith({
    String? item,
    DateTime? createdAt,
    String? createdBy,
    bool? isCreatedByAdmin,
    String? id,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      item: item ?? this.item,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      isCreatedByAdmin: isCreatedByAdmin ?? this.isCreatedByAdmin,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item': item.capitalizeFirstCharacter(),
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'isCreatedByAdmin': isCreatedByAdmin,
      'id': id,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      item: (map['item'] as String).capitalizeFirstCharacter(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdBy: map['createdBy'] as String,
      isCreatedByAdmin: map['isCreatedByAdmin'] as bool,
      id: map['id'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CategoryModel(id:$id, item: $item, createdAt: $createdAt, createdBy: $createdBy, isCreatedByAdmin: $isCreatedByAdmin)';
  }

  @override
  bool operator ==(covariant CategoryModel other) {
    if (identical(this, other)) return true;

    return other.item == item &&
        other.createdAt == createdAt &&
        other.createdBy == createdBy &&
        other.id == id &&
        other.isCreatedByAdmin == isCreatedByAdmin;
  }

  @override
  int get hashCode {
    return item.hashCode ^
        createdAt.hashCode ^
        createdBy.hashCode ^
        id.hashCode ^
        isCreatedByAdmin.hashCode;
  }
}

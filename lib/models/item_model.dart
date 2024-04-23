// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'item_complete_model.dart';

// Project: 	   listi_shop
// File:    	   item_model
// Path:    	   lib/models/item_model.dart
// Author:       Ali Akbar
// Date:        23-04-24 13:20:02 -- Tuesday
// Description:

class ItemModel {
  final String id;
  final DateTime createdAt;
  final String createdBy;
  final String itemName;
  final String category;
  final int? celeries;
  final int? macros;
  final ItemCompleteModel? completedBy;
  final String listId;
  ItemModel({
    required this.id,
    required this.createdAt,
    required this.createdBy,
    required this.itemName,
    required this.category,
    required this.listId,
    this.celeries,
    this.macros,
    this.completedBy,
  });

  ItemModel copyWith({
    String? id,
    DateTime? createdAt,
    String? createdBy,
    String? itemName,
    String? category,
    String? listId,
    int? celeries,
    int? macros,
    ItemCompleteModel? completedBy,
  }) {
    return ItemModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
      itemName: itemName ?? this.itemName,
      category: category ?? this.category,
      celeries: celeries ?? this.celeries,
      macros: macros ?? this.macros,
      completedBy: completedBy ?? this.completedBy,
      listId: listId ?? this.listId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'itemName': itemName,
      'category': category,
      'celeries': celeries,
      'macros': macros,
      'completedBy': completedBy,
      'listId': listId,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdBy: map['createdBy'] as String,
      itemName: map['itemName'] as String,
      category: map['category'] as String,
      celeries: map['celeries'] != null ? map['celeries'] as int : null,
      macros: map['macros'] != null ? map['macros'] as int : null,
      completedBy: ItemCompleteModel.fromMap(map['completedBy']),
      listId: map['listId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemModel(id: $id,listId: $listId, createdAt: $createdAt, createdBy: $createdBy, itemName: $itemName, category: $category, celeries: $celeries, macros: $macros, completedBy: $completedBy)';
  }

  @override
  bool operator ==(covariant ItemModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.createdBy == createdBy &&
        other.itemName == itemName &&
        other.category == category &&
        other.celeries == celeries &&
        other.macros == macros &&
        other.listId == listId &&
        completedBy == other.completedBy;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        createdBy.hashCode ^
        itemName.hashCode ^
        category.hashCode ^
        celeries.hashCode ^
        macros.hashCode ^
        listId.hashCode ^
        completedBy.hashCode;
  }
}

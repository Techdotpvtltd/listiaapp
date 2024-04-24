// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listi_shop/utils/extensions/string_extension.dart';

import 'item_bought_model.dart';
import 'item_complete_model.dart';

// Project: 	   listi_shop
// File:    	   item_model
// Path:    	   lib/models/item_model.dart
// Author:       Ali Akbar
// Date:        23-04-24 13:20:02 -- Tuesday
// Description:

class CategorizeItemsModel {
  final String category;
  final List<ItemModel> items;
  CategorizeItemsModel({required this.category, required this.items});
}

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
  final ItemBoughtModel? boughtBy;
  ItemModel({
    required this.id,
    required this.createdAt,
    required this.createdBy,
    required this.itemName,
    required this.category,
    required this.listId,
    this.celeries,
    this.macros,
    this.boughtBy,
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
    ItemBoughtModel? boughtBy,
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
      boughtBy: boughtBy ?? this.boughtBy,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
      'itemName': itemName.capitalizeFirstCharacter(),
      'category': category,
      'celeries': celeries,
      'macros': macros,
      'listId': listId,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      id: map['id'] as String? ?? "",
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdBy: map['createdBy'] as String,
      itemName: (map['itemName'] as String).capitalizeFirstCharacter(),
      category: map['category'] as String,
      celeries: map['celeries'] != null ? map['celeries'] as int : null,
      macros: map['macros'] != null ? map['macros'] as int : null,
      completedBy: map['completedBy'] != null
          ? ItemCompleteModel.fromMap(map['completedBy'])
          : null,
      boughtBy: map['boughtBy'] != null
          ? ItemBoughtModel.fromMap(map['boughtBy'])
          : null,
      listId: map['listId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemModel.fromJson(String source) =>
      ItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemModel(id: $id,listId: $listId, createdAt: $createdAt, createdBy: $createdBy, itemName: $itemName, category: $category, celeries: $celeries, macros: $macros, completedBy: $completedBy, boughtBy: $boughtBy)';
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
        other.boughtBy == boughtBy &&
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
        boughtBy.hashCode ^
        completedBy.hashCode;
  }
}

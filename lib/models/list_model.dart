// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:listi_shop/utils/extensions/string_extension.dart';

// Project: 	   listi_shop
// File:    	   list_model
// Path:    	   lib/models/list_model.dart
// Author:       Ali Akbar
// Date:        22-04-24 17:38:21 -- Monday
// Description:

class ListModel {
  final String id;
  final String createdBy;
  final String title;
  final List<String> categories;
  final List<String> sharedUsers;
  final DateTime createdAt;
  ListModel({
    required this.id,
    required this.createdBy,
    required this.title,
    required this.categories,
    required this.sharedUsers,
    required this.createdAt,
  });

  ListModel copyWith({
    String? id,
    String? createdBy,
    String? title,
    List<String>? categories,
    List<String>? sharedUsers,
    DateTime? createdAt,
  }) {
    return ListModel(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
      title: title ?? this.title,
      categories: categories ?? this.categories,
      sharedUsers: sharedUsers ?? this.sharedUsers,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdBy': createdBy,
      'title': title.capitalizeFirstCharacter(),
      'categories': categories,
      'sharedUsers': sharedUsers,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      id: map['id'] as String,
      createdBy: map['createdBy'] as String,
      title: map['title'] as String,
      categories: (map['categories'] as List<dynamic>)
          .map((e) => e.toString().capitalizeFirstCharacter())
          .toList(),
      sharedUsers: (map['sharedUsers'] as List<dynamic>)
          .map((e) => e.toString())
          .toList(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListModel.fromJson(String source) =>
      ListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListModel(id: $id, createdBy: $createdBy, title: $title, categories: $categories, sharedUsers: $sharedUsers, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ListModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdBy == createdBy &&
        other.title == title &&
        listEquals(other.categories, categories) &&
        listEquals(other.sharedUsers, sharedUsers) &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdBy.hashCode ^
        title.hashCode ^
        categories.hashCode ^
        sharedUsers.hashCode ^
        createdAt.hashCode;
  }
}

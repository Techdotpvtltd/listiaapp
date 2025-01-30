// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:listi_shop/models/user_model.dart';
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
  final List<UserInfoModel> sharedUsers;
  final List<String> sharedUserIds;
  final DateTime createdAt;
  final bool isCompleted;
  String? referBy;
  String? referListId;

  ListModel({
    required this.id,
    required this.createdBy,
    required this.title,
    required this.sharedUsers,
    required this.createdAt,
    required this.isCompleted,
    required this.sharedUserIds,
    this.referBy,
    this.referListId,
  });

  ListModel copyWith({
    String? id,
    String? createdBy,
    String? title,
    List<UserInfoModel>? sharedUsers,
    DateTime? createdAt,
    bool? isCompleted,
    String? referBy,
    List<String>? sharedUserIds,
    String? referListId,
  }) {
    return ListModel(
      id: id ?? this.id,
      isCompleted: isCompleted ?? this.isCompleted,
      createdBy: createdBy ?? this.createdBy,
      title: title ?? this.title,
      sharedUsers: sharedUsers ?? this.sharedUsers,
      createdAt: createdAt ?? this.createdAt,
      referBy: referBy ?? this.referBy,
      referListId: referListId ?? this.referListId,
      sharedUserIds: sharedUserIds ?? this.sharedUserIds,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdBy': createdBy,
      'title': title.capitalizeFirstCharacter(),
      'sharedList': sharedUsers.map((e) => e.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'isCompleted': isCompleted,
      'referBy': referBy,
      'referListId': referListId,
      'sharedUserIds': sharedUserIds,
    };
  }

  factory ListModel.fromMap(Map<String, dynamic> map) {
    return ListModel(
      id: map['id'] as String,
      createdBy: map['createdBy'] as String,
      referBy: map['referBy'] as String?,
      referListId: map['referListId'] as String?,
      isCompleted: map['isCompleted'] as bool? ?? false,
      title: map['title'] as String,
      sharedUsers: map['sharedList'] != null
          ? (map['sharedList'] as List<dynamic>)
              .map((e) => UserInfoModel.fromMap(e))
              .toList()
          : [],
      sharedUserIds: map['sharedUserIds'] != null
          ? (map['sharedUserIds'] as List<dynamic>)
              .map((e) => e.toString())
              .toList()
          : [],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory ListModel.fromJson(String source) =>
      ListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ListModel(id: $id, createdBy: $createdBy, title: $title, sharedUsers: $sharedUsers, createdAt: $createdAt, referBy: $referBy, referListId: $referListId)';
  }

  @override
  bool operator ==(covariant ListModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.createdBy == createdBy &&
        other.title == title &&
        listEquals(other.sharedUsers, sharedUsers) &&
        other.createdAt == createdAt &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdBy.hashCode ^
        title.hashCode ^
        sharedUsers.hashCode ^
        isCompleted.hashCode ^
        createdAt.hashCode;
  }
}

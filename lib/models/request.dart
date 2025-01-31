// ignore_for_file: public_member_api_docs, sort_constructors_first
// Project: 	   listi_shop
// File:    	   share_list_model
// Path:    	   lib/models/share_list_model.dart
// Author:       Ali Akbar
// Date:        31-01-25 20:18:42 -- Friday
// Description:

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listi_shop/models/user_model.dart';

class RequestModel {
  final String uid;
  final String sharedBy;
  final UserInfoModel sharedUser;
  final String listId;
  final DateTime createdAt;
  RequestModel({
    required this.uid,
    required this.sharedBy,
    required this.sharedUser,
    required this.listId,
    required this.createdAt,
  });

  RequestModel copyWith({
    String? uid,
    String? sharedBy,
    UserInfoModel? sharedUser,
    String? listId,
    DateTime? createdAt,
  }) {
    return RequestModel(
      uid: uid ?? this.uid,
      sharedBy: sharedBy ?? this.sharedBy,
      sharedUser: sharedUser ?? this.sharedUser,
      listId: listId ?? this.listId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'sharedBy': sharedBy,
      'sharedUser': sharedUser.toMap(),
      'listId': listId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      uid: map['uid'] as String,
      sharedBy: map['sharedBy'] as String,
      sharedUser:
          UserInfoModel.fromMap(map['sharedUser'] as Map<String, dynamic>),
      listId: map['listId'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  @override
  String toString() {
    return 'ShareListModel(uid: $uid, sharedBy: $sharedBy, sharedUser: $sharedUser, listId: $listId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant RequestModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.sharedBy == sharedBy &&
        other.sharedUser == sharedUser &&
        other.listId == listId &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        sharedBy.hashCode ^
        sharedUser.hashCode ^
        listId.hashCode ^
        createdAt.hashCode;
  }
}

// ignore_for_file: public_member_api_docs, sort_constructors_first
// Project: 	   listi_shop
// File:    	   share_list_model
// Path:    	   lib/models/share_list_model.dart
// Author:       Ali Akbar
// Date:        31-01-25 20:18:42 -- Friday
// Description:

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:listi_shop/models/user_model.dart';

enum RequestStatus { pending, accepted, rejected, canceled }

class RequestModel {
  final String uid;
  final UserInfoModel sharedBy;
  final UserInfoModel sharedTo;
  final String listId;
  final DateTime createdAt;
  final String listTitle;
  final RequestStatus status;
  RequestModel({
    required this.uid,
    required this.sharedBy,
    required this.sharedTo,
    required this.listId,
    required this.createdAt,
    required this.listTitle,
    required this.status,
  });

  RequestModel copyWith({
    String? uid,
    UserInfoModel? sharedBy,
    UserInfoModel? sharedTo,
    String? listId,
    DateTime? createdAt,
    String? listTitle,
    RequestStatus? status,
  }) {
    return RequestModel(
        uid: uid ?? this.uid,
        sharedBy: sharedBy ?? this.sharedBy,
        sharedTo: sharedTo ?? this.sharedTo,
        listId: listId ?? this.listId,
        createdAt: createdAt ?? this.createdAt,
        status: status ?? this.status,
        listTitle: listTitle ?? this.listTitle);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'sharedTo': sharedTo.toMap(),
      'sharedBy': sharedBy.toMap(),
      'listId': listId,
      'createdAt': Timestamp.fromDate(createdAt),
      'listTitle': listTitle,
      'status': status.name.toLowerCase(),
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      uid: map['uid'] as String,
      sharedBy: UserInfoModel.fromMap(map['sharedBy'] as Map<String, dynamic>),
      sharedTo: UserInfoModel.fromMap(map['sharedTo'] as Map<String, dynamic>),
      listId: map['listId'] as String,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      listTitle: map['listTitle'] as String? ?? "",
      status: RequestStatus.values.firstWhere((e) =>
          e.name.toLowerCase() == (map['status'] as String? ?? "pending")),
    );
  }

  @override
  String toString() {
    return 'ShareListModel(uid: $uid, sharedBy: $sharedBy, sharedBy: $sharedBy, sharedTo: $sharedTo, listId: $listId, createdAt: $createdAt, listTitle: $listTitle, status: $status)';
  }

  @override
  bool operator ==(covariant RequestModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.sharedBy == sharedBy &&
        other.sharedTo == sharedTo &&
        other.listId == listId &&
        other.listTitle == listTitle &&
        other.status == status &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        sharedBy.hashCode ^
        sharedTo.hashCode ^
        listId.hashCode ^
        status.hashCode ^
        listTitle.hashCode ^
        createdAt.hashCode;
  }
}

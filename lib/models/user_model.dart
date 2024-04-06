// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: dangling_library_doc_comments
/// Project: 	   playtogethher
/// File:    	   user_model
/// Path:    	   lib/model/user_model.dart
/// Author:       Ali Akbar
/// Date:        08-03-24 14:13:23 -- Friday
/// Description:

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String avatar;
  final String phoneNumber;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.avatar,
    required this.createdAt,
    required this.phoneNumber,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? avatar,
    String? phoneNumber,
    String? apartment,
    String? address,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'email': email,
      'avatar': avatar,
      'phone': phoneNumber,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String? ?? "",
      email: map['email'] as String? ?? "",
      avatar: map['avatar'] as String? ?? "",
      phoneNumber: map['phone'] as String? ?? "",
      createdAt: (map['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, email: $email, avatar: $avatar, createdAt: $createdAt, phone: $phoneNumber)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.email == email &&
        other.avatar == avatar &&
        other.phoneNumber == phoneNumber &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        email.hashCode ^
        avatar.hashCode ^
        phoneNumber.hashCode ^
        createdAt.hashCode;
  }
}

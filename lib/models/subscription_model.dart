// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

// Project: 	   listi_shop
// File:    	   subscription_model
// Path:    	   lib/models/subscription_model.dart
// Author:       Ali Akbar
// Date:        05-04-24 10:40:37 -- Friday
// Description:

class SubscriptionModel {
  final String id;
  final String periodDuration;
  final String productId;
  final String purchaseId;
  final DateTime startTime;
  final DateTime endTime;
  final String title;
  final String subscribedBy;

  SubscriptionModel({
    required this.id,
    required this.periodDuration,
    required this.productId,
    required this.startTime,
    required this.endTime,
    required this.subscribedBy,
    required this.title,
    required this.purchaseId,
  });

  SubscriptionModel copyWith({
    String? id,
    String? periodDuration,
    String? subscriptionId,
    DateTime? startTime,
    DateTime? endTime,
    String? subscribedBy,
    String? title,
    String? purchaseId,
  }) {
    return SubscriptionModel(
      id: id ?? this.id,
      periodDuration: periodDuration ?? this.periodDuration,
      productId: subscriptionId ?? productId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      title: title ?? this.title,
      subscribedBy: subscribedBy ?? this.subscribedBy,
      purchaseId: purchaseId ?? this.purchaseId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'periodDuration': periodDuration,
      'subscriptionId': productId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'subscribedBy': subscribedBy,
      'title': title,
      'purchaseId': purchaseId,
    };
  }

  factory SubscriptionModel.fromMap(Map<String, dynamic> map) {
    return SubscriptionModel(
      id: map['id'] as String,
      periodDuration: map['periodDuration'] as String,
      productId: map['subscriptionId'] as String,
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp).toDate(),
      title: map['title'] as String,
      subscribedBy: map['subscribedBy'] as String,
      purchaseId: map['purchaseId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubscriptionModel.fromJson(String source) =>
      SubscriptionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'SubscriptionModel(id: $id, periodDuration: $periodDuration, subscriptionId: $productId, startTime: $startTime, endTime: $endTime, title: $title, subscribedBy: $subscribedBy, purchaseId: $purchaseId)';
  }

  @override
  bool operator ==(covariant SubscriptionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.periodDuration == periodDuration &&
        other.productId == productId &&
        other.startTime == startTime &&
        other.endTime == endTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        periodDuration.hashCode ^
        productId.hashCode ^
        startTime.hashCode ^
        endTime.hashCode;
  }
}

// Project: 	   listi_shop
// File:    	   subscription_repo
// Path:    	   lib/repos/subscription_repo.dart
// Author:       Ali Akbar
// Date:        28-05-24 16:49:07 -- Tuesday
// Description:

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:listi_shop/repos/user_repo.dart';
import 'package:ntp/ntp.dart';

import '../exceptions/exception_parsing.dart';
import '../managers/app_manager.dart';
import '../models/subscription_model.dart';
import '../utils/constants/firebase_collections.dart';
import '../web_services/firestore_services.dart';
import '../web_services/query_model.dart';
import 'package:flutter/foundation.dart' show kReleaseMode;

class SubscriptionRepo {
  // ===========================Singleton InStance================================
  static final SubscriptionRepo _instance = SubscriptionRepo._internal();
  SubscriptionRepo._internal();
  factory SubscriptionRepo() => _instance;
  // ===========================Properties================================
  SubscriptionModel? _subscription;
  SubscriptionModel? get lastSubscription => _subscription;

  // ===========================API Methods================================

  Future<void> saveSubscription({required PurchaseDetails purchase}) async {
    try {
      final DateTime startDate = DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(purchase.transactionDate ?? "0") ?? 0);
      final DateTime endDate = startDate.add(
          kReleaseMode ? const Duration(days: 30) : const Duration(minutes: 5));
      final SubscriptionModel model = SubscriptionModel(
          id: "",
          periodDuration: "month",
          productId: purchase.productID,
          startTime: startDate,
          endTime: endDate,
          subscribedBy: UserRepo().currentUser.uid,
          title: purchase.productID.contains("house") ? "House" : "Business",
          purchaseId: purchase.purchaseID ?? "");
      final Map<String, dynamic> map = await FirestoreService()
          .saveWithSpecificIdFiled(
              path: FIREBASE_COLLECTION_SUBSCRIPTIONS,
              data: model.toMap(),
              docIdFiled: 'id');
      _subscription = SubscriptionModel.fromMap(map);
      await _validateSubscription();
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  Future<void> getLastSubscription() async {
    try {
      final List<Map<String, dynamic>> mapped =
          await FirestoreService().fetchWithMultipleConditions(
        collection: FIREBASE_COLLECTION_SUBSCRIPTIONS,
        queries: [
          QueryModel(
              field: "subscribedBy",
              value: UserRepo().currentUser.uid,
              type: QueryType.isEqual),
          QueryModel(field: "startTime", value: false, type: QueryType.orderBy),
          QueryModel(field: "", value: 1, type: QueryType.limit),
        ],
      );

      if (mapped.isNotEmpty) {
        _subscription = SubscriptionModel.fromMap(mapped.first);
        await _validateSubscription();
        debugPrint(_subscription.toString());
      }
    } catch (e) {
      throw throwAppException(e: e);
    }
  }

  Future<void> _validateSubscription() async {
    final DateTime now = await NTP.now();
    if (_subscription!.endTime.millisecondsSinceEpoch >=
        now.millisecondsSinceEpoch) {
      AppManager().isActiveSubscription = true;
    }
  }
}

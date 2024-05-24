// Project: 	   listi_shop
// File:    	   subscription_manager
// Path:    	   lib/managers/subscription_manager.dart
// Author:       Ali Akbar
// Date:        02-05-24 14:07:06 -- Thursday
// Description:

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../exceptions/app_exceptions.dart';
import '../exceptions/data_exceptions.dart';

class SubscriptionManager {
  // =========================== Singleton Instance ================================
  static final SubscriptionManager _instance = SubscriptionManager._internal();
  SubscriptionManager._internal() {
    _inAppPurchase = InAppPurchase.instance;
  }
  factory SubscriptionManager() => _instance;

  // ===========================Properties================================
  late StreamSubscription<dynamic> _subscription;
  final Stream _purchasedUpdated = InAppPurchase.instance.purchaseStream;
  late final InAppPurchase _inAppPurchase;

  List<ProductDetails> products = [];
  // ===========================Methods================================

  // Listen Subscription Purchase Update
  Future<void> listenSubscriptionPurchaseUpdate({
    Function(AppException)? onError,
    required Function(PurchaseDetails) onData,
  }) async {
    _subscription = _purchasedUpdated.listen(
      (purchaseDetailsList) {
        if (purchaseDetailsList is List<PurchaseDetails>) {
          // ignore: avoid_function_literals_in_foreach_calls
          purchaseDetailsList.forEach(
            (purchaseDetails) async {
              onData(purchaseDetails);
            },
          );
        }
      },
      onError: (e) {
        if (onError != null) {
          onError(
            DataExceptionSubscriptionFailure(
              message: e.toString(),
              code: 'subscription-failure',
              source: "",
            ),
          );
        }

        debugPrint(e.toString());
      },
      onDone: () {
        _subscription.cancel();
      },
    );
  }

  /// Load Products
  Future<List<ProductDetails>> loadProducts(
      {required Set<String> productsId,
      required Function(List<String>) onNotFoundIDs}) async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    debugPrint("Is Store available = $isAvailable");
    final ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(productsId);
    if (response.error != null) {
      throw DataExceptionSubscriptionFailure(
          message: response.error?.message ?? "",
          code: response.error?.code,
          source: response.error?.source);
    }

    if (response.notFoundIDs.isNotEmpty) {
      onNotFoundIDs(response.notFoundIDs);
    }

    products = response.productDetails;
    return products;
  }

  // Buy Subscription
  Future<bool> buySubscription({required ProductDetails productDetails}) async {
    final PurchaseParam param = PurchaseParam(productDetails: productDetails);
    return await _inAppPurchase.buyConsumable(purchaseParam: param);
  }

  // Restore Previous Subsriptions
  Future<void> restoreSubscription() async {
    await _inAppPurchase.restorePurchases();
  }
}

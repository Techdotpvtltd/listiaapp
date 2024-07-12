// Project: 	   listi_shop
// File:    	   subscription_bloc
// Path:    	   lib/blocs/subscription/subscription_bloc.dart
// Author:       Ali Akbar
// Date:        02-05-24 16:41:04 -- Thursday
// Description:

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../exceptions/app_exceptions.dart';
import '../../exceptions/data_exceptions.dart';
import '../../managers/subscription_manager.dart';
import '../../repos/subscription_repo.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';
import 'dart:io' show Platform;

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(SubscriptionStateInitial()) {
    on<SubscriptionEventGetLast>(
      (event, emit) async {
        try {
          emit(SubscriptionStateGettingLast());
          await SubscriptionRepo().getLastSubscription();
          emit(SubscriptionStateGotLast());
          SubscriptionManager()
              .restorePurchases(); // Check for previous purchases
        } on AppException catch (e) {
          log("[debug GetLastSubscription] ${e.message.toString()}");
        }
      },
    );

    on<SubscriptionEventListener>(
      (event, emit) async {
        /// Get Last Subscription Plan
        emit(SubscriptionStateReady());
        await SubscriptionManager().listenSubscriptionPurchaseUpdate(
          onData: (purchaseDetails) async {
            if (purchaseDetails.status == PurchaseStatus.canceled) {
              if (Platform.isIOS) {
                SubscriptionManager().completePurchases(purchaseDetails);
              }
              emit(
                SubscriptionStatePurchaseFailure(
                  exception: DataExceptionSubscriptionFailure(
                      message: "User cancel the subscription.",
                      code: purchaseDetails.error!.code,
                      source: purchaseDetails.error!.source),
                ),
              );
            }
            if (purchaseDetails.status == PurchaseStatus.error) {
              emit(
                SubscriptionStatePurchaseFailure(
                  exception: DataExceptionSubscriptionFailure(
                      message: purchaseDetails.error!.message,
                      code: purchaseDetails.error!.code,
                      source: purchaseDetails.error!.source),
                ),
              );
            }

            if (purchaseDetails.status == PurchaseStatus.pending) {
              emit(
                SubscriptionStatePurchaseFailure(
                  exception: DataExceptionSubscriptionFailure(
                      message:
                          "It seems there's an unfinished transaction for this subscription. Please wait for the current transaction to complete, or finish it manually in your purchase history to proceed.",
                      code: purchaseDetails.error!.code,
                      source: purchaseDetails.error!.source),
                ),
              );
            }

            if (purchaseDetails.status == PurchaseStatus.restored) {
              try {
                await verifyAndDeliverProduct(purchaseDetails);
                SubscriptionManager().completePurchases(purchaseDetails);
                emit(SubscriptionStateRestored());
              } catch (e) {
                log("[debug verifyAndDeliver] $e");
              }
            }

            if (purchaseDetails.status == PurchaseStatus.purchased) {
              try {
                await SubscriptionRepo()
                    .saveSubscription(purchase: purchaseDetails);
                await SubscriptionManager().completePurchases(purchaseDetails);
                emit(SubscriptionStatePurchased());
              } catch (e) {
                log("[debug PurchasedError] $e");
              }
            }

            if (purchaseDetails.pendingCompletePurchase) {
              await SubscriptionManager().completePurchases(purchaseDetails);
            }
          },
          onError: (e) {
            emit(SubscriptionStateFailure(exception: e));
          },
        );
      },
    );

    /// OnReady Subscription Event
    on<SubscriptionEventReady>(
      (event, emit) async {
        try {
          emit(SubscriptionStateGettingProducts());
          final List<ProductDetails> products =
              await SubscriptionManager().loadProducts(
            productsId: {
              'household_monthly',
              'business_monthly',
              'household_annual',
              'business_annual'
            },
            onNotFoundIDs: (ids) {
              for (final String id in ids) {
                emit(
                  SubscriptionStatePurchaseFailure(
                    exception: (DataExceptionSubscriptionFailure(
                        message: "Product $id not found.",
                        code: 'ids-not-found',
                        source: "")),
                  ),
                );
              }
            },
          );
          emit(SubscriptionStateGotProducts(products: products));
        } on AppException catch (e) {
          emit(SubscriptionStateFailure(exception: e));
        }
      },
    );

    // onPurchase Subscription Event
    on<SubscriptionEventBuySubscription>(
      (event, emit) async {
        try {
          emit(SubscriptionStatePurchasing());
          await SubscriptionManager()
              .buySubscription(productDetails: event.productDetails);
        } on AppException catch (e) {
          emit(SubscriptionStatePurchaseFailure(exception: e));
        }
      },
    );

    /// Mark Purchase Completed
    on<SubscriptionEventMarkPurchaseCompleted>(
      (event, emit) async {
        await SubscriptionManager().completePurchases(event.purchaseDetails);
        emit(SubcriptionStateMarkedPurchaseCompleted());
      },
    );
  }

  Future<void> verifyAndDeliverProduct(PurchaseDetails purchaseDetails) async {
    try {
      final int? lastSubscriptionStartDate =
          SubscriptionRepo().lastSubscription?.startTime.millisecondsSinceEpoch;
      final int transcationDate =
          int.tryParse(purchaseDetails.transactionDate ?? "0") ?? 0;

      if (lastSubscriptionStartDate == null) {
        return;
      }

      if (transcationDate != lastSubscriptionStartDate) {
        final bool isRecentRenewal =
            DateTime.fromMillisecondsSinceEpoch(transcationDate).isAfter(
                DateTime.fromMillisecondsSinceEpoch(lastSubscriptionStartDate));
        if (isRecentRenewal) {
          log("Saving....");
          await SubscriptionRepo().saveSubscription(purchase: purchaseDetails);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}

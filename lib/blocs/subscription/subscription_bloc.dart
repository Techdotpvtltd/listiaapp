// Project: 	   listi_shop
// File:    	   subscription_bloc
// Path:    	   lib/blocs/subscription/subscription_bloc.dart
// Author:       Ali Akbar
// Date:        02-05-24 16:41:04 -- Thursday
// Description:

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../exceptions/app_exceptions.dart';
import '../../exceptions/data_exceptions.dart';
import '../../managers/subscription_manager.dart';
import 'subscription_event.dart';
import 'subscription_state.dart';

class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc() : super(SubscriptionStateInitial()) {
    /// OnReady Subscription Event
    on<SubscriptionEventReady>(
      (event, emit) async {
        try {
          emit(SubscriptionStateGettingProducts());
          final List<ProductDetails> products = await SubscriptionManager()
              .loadProducts(
                  productsId: {'com.techdot.listiShop.sliver_monthly'});
          emit(SubscriptionStateGotProducts(products: products));
          emit(SubscriptionStateReady());
          await SubscriptionManager().listenSubscriptionPurchaseUpdate(
            onData: (purchaseDetails) {
              if (purchaseDetails.error != null) {
                emit(SubscriptionStatePurchaseFailure(
                    exception: DataExceptionSubscriptionFailure(
                        message: purchaseDetails.error!.message,
                        code: purchaseDetails.error!.code,
                        source: purchaseDetails.error!.source)));
              }

              if (purchaseDetails.status == PurchaseStatus.error) {
                emit(SubscriptionStatePurchaseFailure(
                    exception: DataExceptionSubscriptionFailure(
                        message: purchaseDetails.error!.message,
                        code: purchaseDetails.error!.code,
                        source: purchaseDetails.error!.source)));
              }

              if (purchaseDetails.status == PurchaseStatus.pending) {}

              if (purchaseDetails.status == PurchaseStatus.restored) {
                emit(SubscriptionStateRestored());
              }

              if (purchaseDetails.status == PurchaseStatus.purchased) {
                emit(SubscriptionStatePurchased());
              }

              if (purchaseDetails.pendingCompletePurchase) {}
            },
            onError: (e) {
              emit(SubscriptionStateFailure(exception: e));
            },
          );
        } on AppException catch (e) {
          emit(SubscriptionStateFailure(exception: e));
        }
      },
    );

    // onPurchase Subscription Event
    on<SubscriptionEventBuyPurchase>(
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
  }
}

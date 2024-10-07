// Project: 	   listi_shop
// File:    	   subscription_event
// Path:    	   lib/blocs/subscription/subscription_event.dart
// Author:       Ali Akbar
// Date:        02-05-24 16:33:33 -- Thursday
// Description:

import 'package:in_app_purchase/in_app_purchase.dart';

abstract class SubscriptionEvent {}

// Get Ready Subscription Event
class SubscriptionEventReady extends SubscriptionEvent {}

class SubscriptionEventFetechProducts extends SubscriptionEvent {}

class SubscriptionEventBuySubscription extends SubscriptionEvent {
  final ProductDetails productDetails;

  SubscriptionEventBuySubscription({required this.productDetails});
}

class SubscriptionEventMarkPurchaseCompleted extends SubscriptionEvent {
  final PurchaseDetails purchaseDetails;

  SubscriptionEventMarkPurchaseCompleted({required this.purchaseDetails});
}

// ===========================Listener Product ================================
class SubscriptionEventListener extends SubscriptionEvent {}

// ===========================Get Last Subscription Event================================

class SubscriptionEventGetLast extends SubscriptionEvent {}

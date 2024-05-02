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

class SubscriptionEventBuyPurchase extends SubscriptionEvent {
  final ProductDetails productDetails;

  SubscriptionEventBuyPurchase({required this.productDetails});
}

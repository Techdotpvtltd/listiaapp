// Project: 	   listi_shop
// File:    	   subscription_state
// Path:    	   lib/blocs/subscription/subscription_state.dart
// Author:       Ali Akbar
// Date:        02-05-24 16:35:52 -- Thursday
// Description:

import 'package:in_app_purchase/in_app_purchase.dart';

import '../../exceptions/app_exceptions.dart';

abstract class SubscriptionState {
  final bool isLoading;

  SubscriptionState({this.isLoading = false});
}

// initial State
class SubscriptionStateInitial extends SubscriptionState {}

// ===========================Get Ready Subscription================================
class SubscriptionStateGettingProducts extends SubscriptionState {
  SubscriptionStateGettingProducts({super.isLoading = true});
}

class SubscriptionStateGotProducts extends SubscriptionState {
  final List<ProductDetails> products;

  SubscriptionStateGotProducts({required this.products});
}

class SubscriptionStateReady extends SubscriptionState {}

class SubscriptionStateReadyFailure extends SubscriptionState {
  final AppException exception;

  SubscriptionStateReadyFailure({required this.exception});
}

// ===========================Subscription Failure State================================
class SubscriptionStateFailure extends SubscriptionState {
  final AppException exception;

  SubscriptionStateFailure({required this.exception});
}

// ===========================Restore Subscription State================================
class SubscriptionStateRestored extends SubscriptionState {}

// ===========================Purchase Subscription State================================

class SubscriptionStatePurchasing extends SubscriptionState {
  SubscriptionStatePurchasing({super.isLoading = true});
}

class SubscriptionStatePurchaseFailure extends SubscriptionState {
  final AppException exception;

  SubscriptionStatePurchaseFailure({required this.exception});
}

class SubscriptionStatePurchased extends SubscriptionState {}

// ===========================Available Purchase State================================

class SubscriptionStateStoreStatus extends SubscriptionState {
  final bool isAvailable;

  SubscriptionStateStoreStatus({required this.isAvailable});
}

// ===========================Mark Purchased Completed================================

class SubcriptionStateMarkedPurchaseCompleted extends SubscriptionState {}

// ===========================Get Last Subscription States================================
class SubscriptionStateGettingLast extends SubscriptionState {}

class SubscriptionStateGotLast extends SubscriptionState {}

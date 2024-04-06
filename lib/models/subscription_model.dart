// Project: 	   listi_shop
// File:    	   subscription_model
// Path:    	   lib/models/subscription_model.dart
// Author:       Ali Akbar
// Date:        05-04-24 10:40:37 -- Friday
// Description:

class SubscriptionModel {
  final String id;
  final String title;
  final List<String> contents;
  final double price;
  final String periodDuration;

  SubscriptionModel(
      {required this.id,
      required this.title,
      required this.contents,
      required this.price,
      required this.periodDuration});
}

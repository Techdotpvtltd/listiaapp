// Project: 	   listi_shop
// File:    	   horizontal_padding
// Path:    	   lib/screens/components/horizontal_padding.dart
// Author:       Ali Akbar
// Date:        03-04-24 13:57:03 -- Wednesday
// Description:

import 'package:flutter/material.dart';

class HorizontalPadding extends StatelessWidget {
  const HorizontalPadding({super.key, this.child, this.value});
  final Widget? child;
  final double? value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 29),
      child: child,
    );
  }
}

class VerticalPadding extends StatelessWidget {
  const VerticalPadding({super.key, this.child, this.value});
  final Widget? child;
  final double? value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 29),
      child: child,
    );
  }
}

class HVPadding extends StatelessWidget {
  const HVPadding({super.key, this.child, this.horizontal, this.verticle});
  final Widget? child;
  final double? horizontal;
  final double? verticle;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: verticle ?? 29,
        horizontal: horizontal ?? 29,
      ),
      child: child,
    );
  }
}

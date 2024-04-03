// Project: 	   playtogethher
// File:    	   circle_network_image_widget
// Path:    	   lib/widgets/circle_network_image_widget.dart
// Author:       Ali Akbar
// Date:        13-03-24 13:49:57 -- Wednesday
// Description:

import 'package:flutter/material.dart';
import 'custom_network_image.dart';

class CircleNetworkImage extends StatelessWidget {
  const CircleNetworkImage({
    super.key,
    required this.url,
    this.onTapImage,
    this.width,
    this.height,
    this.backgroundColor,
    this.showPlaceholder = true,
    this.placeholderWidget,
  });
  final String url;
  final VoidCallback? onTapImage;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final bool showPlaceholder;
  final Widget? placeholderWidget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 50,
      height: height ?? 50,
      child: InkWell(
        onTap: onTapImage,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.blueGrey[50],
            borderRadius: const BorderRadius.all(
              Radius.circular(300),
            ),
          ),
          child: CustomNetworkImage(
            imageUrl: url,
            backgroundColor: backgroundColor ?? Colors.transparent,
            showPlaceholder: showPlaceholder,
            placeholderWidget: placeholderWidget,
          ),
        ),
      ),
    );
  }
}

// Project: 	   playtogethher
// File:    	   circle_network_image_widget
// Path:    	   lib/widgets/circle_network_image_widget.dart
// Author:       Ali Akbar
// Date:        13-03-24 13:49:57 -- Wednesday
// Description:

import 'package:flutter/material.dart';
import 'custom_network_image.dart';

class CircleNetworkImage extends StatefulWidget {
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
  State<CircleNetworkImage> createState() => _CircleNetworkImageState();
}

class _CircleNetworkImageState extends State<CircleNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 50,
      height: widget.height ?? 50,
      child: InkWell(
        onTap: widget.onTapImage,
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? Colors.blueGrey[50],
            borderRadius: const BorderRadius.all(
              Radius.circular(300),
            ),
          ),
          child: CustomNetworkImage(
            imageUrl: widget.url,
            backgroundColor: widget.backgroundColor ?? Colors.transparent,
            showPlaceholder: widget.showPlaceholder,
            placeholderWidget: widget.placeholderWidget,
          ),
        ),
      ),
    );
  }
}

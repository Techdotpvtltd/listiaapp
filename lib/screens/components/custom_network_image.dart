import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';

/// Project: 	   CarRenterApp
/// File:    	   custom_network_image
/// Path:    	   lib/utilities/widgets/custom_network_image.dart
/// Author:       Ali Akbar
/// Date:        28-02-24 15:39:43 -- Wednesday
/// Description:

class CustomNetworkImage extends StatefulWidget {
  const CustomNetworkImage(
      {super.key,
      required this.imageUrl,
      this.width,
      this.height,
      this.backgroundColor,
      this.showPlaceholder = true,
      this.placeholderWidget});
  final String imageUrl;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final bool showPlaceholder;
  final Widget? placeholderWidget;

  @override
  State<CustomNetworkImage> createState() => _CustomNetworkImageState();
}

class _CustomNetworkImageState extends State<CustomNetworkImage> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      width: widget.width,
      height: widget.height,
      errorListener: (value) {},
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryColor1,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: widget.backgroundColor ?? Colors.blueGrey[50],
        child: LayoutBuilder(
          builder: (context, constraints) {
            return url != "" &&
                    error.toString().contains("No host specified in URI")
                ? Image.file(
                    File(widget.imageUrl),
                    height: widget.height,
                    width: widget.width,
                    fit: BoxFit.cover,
                  )
                : Visibility(
                    visible: widget.showPlaceholder,
                    child: Center(
                      child: widget.placeholderWidget ??
                          Icon(
                            Icons.image,
                            size: (widget.height ?? constraints.maxHeight) / 2,
                          ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

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

class CustomNetworkImage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      errorListener: (value) {},
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(
          color: AppTheme.primaryColor1,
        ),
      ),
      errorWidget: (context, url, error) => Container(
        color: backgroundColor ?? Colors.blueGrey[50],
        child: LayoutBuilder(
          builder: (context, constraints) {
            return url != "" &&
                    error.toString().contains("No host specified in URI")
                ? Image.file(
                    File(imageUrl),
                    height: height,
                    width: width,
                    fit: BoxFit.cover,
                  )
                : Visibility(
                    visible: showPlaceholder,
                    child: Center(
                      child: placeholderWidget ??
                          Icon(
                            Icons.image,
                            size: (height ?? constraints.maxHeight) / 2,
                          ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

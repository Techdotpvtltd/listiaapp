import 'package:flutter/material.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';

import 'circle_network_image_widget.dart';

class AvatarWidget extends StatelessWidget {
  const AvatarWidget({
    super.key,
    this.width,
    this.height,
    this.avatarUrl,
    this.backgroundColor,
    this.placeholderChar,
    this.onEditPressed,
  });
  final double? width;
  final double? height;
  final String? avatarUrl;
  final Color? backgroundColor;
  final String? placeholderChar;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Positioned(
            child: CircleNetworkImage(
              height: height ?? 115,
              width: width ?? 115,
              backgroundColor: placeholderChar != null
                  ? AppTheme.primaryColor1
                  : backgroundColor,
              url: avatarUrl ?? "",
              placeholderWidget: LayoutBuilder(
                builder: (context, constraints) {
                  return Text(
                    placeholderChar ?? "U",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: constraints.maxWidth * 0.6,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
            ),
          ),
          Visibility(
            visible: onEditPressed != null,
            child: Positioned(
              right: 0,
              bottom: -6,
              child: IconButton(
                onPressed: () {
                  if (onEditPressed != null) {
                    onEditPressed!();
                  }
                },
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.zero),
                  visualDensity: VisualDensity.compact,
                  backgroundColor:
                      MaterialStatePropertyAll(AppTheme.primaryColor1),
                ),
                icon: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listi_shop/utils/constants/app_theme.dart';

import 'circle_network_image_widget.dart';
import 'my_image_picker.dart';

class AvatarWidget extends StatefulWidget {
  const AvatarWidget({
    super.key,
    this.width,
    this.height,
    this.onSelectedImage,
    this.avatarUrl,
    this.backgroundColor,
    this.placeholderChar,
  });
  final double? width;
  final double? height;
  final Function(String)? onSelectedImage;
  final String? avatarUrl;
  final Color? backgroundColor;
  final String? placeholderChar;

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> {
  late String selectedAvatar = widget.avatarUrl ?? "";

  void selectImage() {
    final MyImagePicker imagePicker = MyImagePicker();
    imagePicker.pick();
    imagePicker.onSelection(
      (exception, data) {
        if (data is XFile) {
          setState(() {
            if (widget.onSelectedImage != null) {
              widget.onSelectedImage!(data.path);
            }
            setState(() {
              selectedAvatar = data.path;
            });
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Positioned(
            child: CircleNetworkImage(
              height: widget.height ?? 115,
              width: widget.width ?? 115,
              backgroundColor: widget.placeholderChar != null
                  ? AppTheme.primaryColor1
                  : widget.backgroundColor,
              url: selectedAvatar,
              placeholderWidget: LayoutBuilder(
                builder: (context, constraints) {
                  return Text(
                    widget.placeholderChar ?? "U",
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
            visible: widget.onSelectedImage != null,
            child: Positioned(
              right: 0,
              bottom: -6,
              child: IconButton(
                onPressed: () {
                  selectImage();
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

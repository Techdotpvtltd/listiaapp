import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../exceptions/app_exceptions.dart';
import '../../exceptions/data_exceptions.dart';
import '../../main.dart';

/// Project: 	   CarRenterApp
/// File:    	   my_image_picker
/// Path:    	   lib/utilities/extensions/my_image_picker.dart
/// Author:       Ali Akbar
/// Date:        27-02-24 14:14:24 -- Tuesday
/// Description:
enum MIPickerSource { both, camera, gallery }

class MyImagePicker {
  MyImagePicker({
    this.pickerSource = MIPickerSource.both,
    this.imageQuality = 30,
    this.allowMultipleImageSelection = false,
    this.maxImages,
  });

  final MIPickerSource pickerSource;
  final int imageQuality;
  ImageSource _imageSource = ImageSource.gallery;
  final bool allowMultipleImageSelection;
  final int? maxImages;

  void Function(AppException? exception, dynamic data)? _caller;

  void onSelection(Function(AppException? exception, dynamic data) caller) {
    _caller = caller;
  }

  Future<void> _pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    dynamic data;

    data = allowMultipleImageSelection
        ? await imagePicker.pickMultiImage(
            imageQuality: imageQuality,
          )
        : await imagePicker.pickImage(
            source: _imageSource,
            imageQuality: imageQuality,
          );
    if (data != null) {
      _caller?.call(null, data);
      Navigator.pop(navKey.currentContext!);
      return;
    }

    _caller?.call(DataExceptionUnknown(message: "Something went wrong."), null);
  }

  void pick() {
    switch (pickerSource) {
      case MIPickerSource.both:
        _showBottomSheet();
        break;
      case MIPickerSource.camera:
        _imageSource = ImageSource.camera;
        _pickImage();
        break;
      case MIPickerSource.gallery:
        _imageSource = ImageSource.gallery;
        _pickImage();
        break;
    }
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: navKey.currentContext!,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.28,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Media Source",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () {
                    _imageSource = ImageSource.camera;
                    _pickImage();
                  },
                  child: const SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Camera",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    _imageSource = ImageSource.gallery;
                    _pickImage();
                  },
                  child: const SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_album,
                          size: 24,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Gallery",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class Picker {
  Future<File?> pickImage(ImageSource source,
      {bool lockRatio = false,
        int quality = 60,
        CropStyle cropStyle = CropStyle.rectangle,
        CropAspectRatioPreset cropPreset = CropAspectRatioPreset.square}) async {
    final ImagePicker _picker = ImagePicker();
    try {
      final pickedImage = await _picker.pickImage(source: source);
      if (pickedImage != null) {
        File? cropped = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          compressQuality: quality,
          maxWidth: 1600,
          maxHeight: 1600,
          cropStyle: cropStyle,
          compressFormat: ImageCompressFormat.jpg,
          androidUiSettings: AndroidUiSettings(
              lockAspectRatio: lockRatio,
              initAspectRatio: cropPreset,
              toolbarColor: Colors.blue,
              toolbarTitle: "Resize Image",
              backgroundColor: Colors.white),
          iosUiSettings: const IOSUiSettings(aspectRatioLockEnabled: false),
        );
        return cropped;
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

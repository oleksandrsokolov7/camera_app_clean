import 'dart:io';
import 'package:flutter/services.dart';

class PlatformChannel {
  static const _methodChannel = MethodChannel(
    'com.example.camera_app/mediastore',
  );

  static Future<bool> saveImageToGallery(File file) async {
    try {
      final result = await _methodChannel.invokeMethod('saveImage', {
        'imagePath': file.path,
      });
      return result == 'success';
    } on PlatformException catch (e) {
      print("Ошибка при сохранении: '${e.message}'.");
      return false;
    }
  }
}

// Изменения в lib/core/platform/platform_channel.dart
import 'dart:io';
import 'package:flutter/services.dart';

class PlatformChannel {
  static const _methodChannel = MethodChannel(
    'com.example.camera_app/mediastore',
  );

  static Future<bool> saveImageToGallery(File file) async {
    try {
      // Проверка существования файла перед отправкой в нативный код
      if (!await file.exists()) {
        print("Файл не существует по пути: ${file.path}");
        return false;
      }

      final result = await _methodChannel.invokeMethod('saveImage', {
        'imagePath': file.path,
      });

      // Добавьте отладочную информацию
      print("Результат сохранения: $result, путь: ${file.path}");

      return result == 'success';
    } on PlatformException catch (e) {
      print("Ошибка при сохранении: '${e.message}'.");
      print("Детали ошибки: ${e.details}");
      return false;
    } catch (e) {
      print("Неизвестная ошибка при сохранении: $e");
      return false;
    }
  }
}

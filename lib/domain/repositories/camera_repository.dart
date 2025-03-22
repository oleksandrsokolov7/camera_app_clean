import 'dart:io';
import 'package:camera/camera.dart';

import '../entities/captured_media.dart';

abstract class CameraRepository {
  Future<void> initCamera();
  Future<void> switchCamera();
  Future<CapturedMedia?> takePicture();
  Future<void> startVideoRecording();
  Future<CapturedMedia?> stopVideoRecording();
  Future<void> pickOverlayImage();
  Future<bool> saveMediaToGallery(CapturedMedia media);
  bool get isRecording;
  File? get overlayImage;

  CameraController? get controller;
}

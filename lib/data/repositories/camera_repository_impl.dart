import 'dart:io';
import 'package:camera/camera.dart';

import '../../domain/entities/captured_media.dart';
import '../../domain/repositories/camera_repository.dart';
import '../datasources/camera_local_data_source.dart';

class CameraRepositoryImpl implements CameraRepository {
  final CameraLocalDataSource dataSource;

  CameraRepositoryImpl({required this.dataSource});
  @override
  CameraController? get controller => dataSource.controller;
  @override
  Future<void> initCamera() async {
    await dataSource.initCamera();
  }

  @override
  Future<void> switchCamera() async {
    await dataSource.switchCamera();
  }

  @override
  Future<CapturedMedia?> takePicture() async {
    return await dataSource.takePicture();
  }

  @override
  Future<void> startVideoRecording() async {
    await dataSource.startVideoRecording();
  }

  @override
  Future<CapturedMedia?> stopVideoRecording() async {
    return await dataSource.stopVideoRecording();
  }

  @override
  Future<void> pickOverlayImage() async {
    await dataSource.pickOverlayImage();
  }

  @override
  Future<bool> saveMediaToGallery(CapturedMedia media) async {
    return await dataSource.saveMediaToGallery(media);
  }

  @override
  bool get isRecording => dataSource.isRecording;

  @override
  File? get overlayImage => dataSource.overlayImage;
}

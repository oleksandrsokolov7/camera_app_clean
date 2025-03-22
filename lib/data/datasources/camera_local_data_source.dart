import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/image_picker_helper.dart';
import '../../core/platform/platform_channel.dart';
import '../../domain/entities/captured_media.dart';

class CameraLocalDataSource {
  CameraController? _controller;
  late List<CameraDescription> _cameras;
  bool _isRecording = false;
  int _currentCameraIndex = 0;
  File? _overlayImage;

  CameraController? get controller => _controller;
  bool get isRecording => _isRecording;
  File? get overlayImage => _overlayImage;

  Future<void> initCamera() async {
    _cameras = await availableCameras();

    if (_cameras.isEmpty) {
      throw Exception("Камеры не найдены");
    }

    // Выбираем переднюю камеру по умолчанию
    _currentCameraIndex = _cameras.indexWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );
    if (_currentCameraIndex == -1) {
      _currentCameraIndex =
          0; // Если передней камеры нет, берем первую доступную
    }

    _controller = CameraController(
      _cameras[_currentCameraIndex],
      ResolutionPreset.high,
    );

    try {
      await _controller?.initialize();
    } catch (e) {
      print("Ошибка инициализации камеры: $e");
    }
  }

  Future<void> switchCamera() async {
    if (_cameras.length < 2 || _controller == null) return;

    _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;

    await _controller?.dispose();
    _controller = CameraController(
      _cameras[_currentCameraIndex],
      ResolutionPreset.high,
    );

    try {
      await _controller?.initialize();
    } catch (e) {
      print("Ошибка переключения камеры: $e");
    }
  }

  Future<CapturedMedia?> takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return null;

    try {
      final image = await _controller!.takePicture();
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      await image.saveTo(imagePath);

      final file = File(imagePath);
      return CapturedMedia(
        path: imagePath,
        type: MediaType.photo,
        capturedAt: DateTime.now(),
        file: file,
      );
    } catch (e) {
      print("Ошибка съемки фото: $e");
      return null;
    }
  }

  Future<void> startVideoRecording() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isRecording) {
      return;
    }

    try {
      _isRecording = true;
      await _controller!.startVideoRecording();
    } catch (e) {
      print("Ошибка начала записи видео: $e");
      _isRecording = false;
    }
  }

  Future<CapturedMedia?> stopVideoRecording() async {
    if (!_isRecording || _controller == null) return null;

    try {
      _isRecording = false;
      final xFile = await _controller!.stopVideoRecording();
      final path = xFile.path;
      final file = File(path);

      return CapturedMedia(
        path: path,
        type: MediaType.video,
        capturedAt: DateTime.now(),
        file: file,
      );
    } catch (e) {
      print("Ошибка остановки записи видео: $e");
      return null;
    }
  }

  Future<void> pickOverlayImage() async {
    _overlayImage = await ImagePickerHelper.pickImageFromGallery();
  }

  Future<bool> saveMediaToGallery(CapturedMedia media) async {
    return await PlatformChannel.saveImageToGallery(media.file);
  }
}

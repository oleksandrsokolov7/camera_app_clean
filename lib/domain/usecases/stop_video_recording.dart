import '../entities/captured_media.dart';
import '../repositories/camera_repository.dart';

class StopVideoRecording {
  final CameraRepository repository;

  StopVideoRecording(this.repository);

  Future<CapturedMedia?> call() async {
    return await repository.stopVideoRecording();
  }
}

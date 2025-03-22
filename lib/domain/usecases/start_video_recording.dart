import '../repositories/camera_repository.dart';

class StartVideoRecording {
  final CameraRepository repository;

  StartVideoRecording(this.repository);

  Future<void> call() async {
    return await repository.startVideoRecording();
  }
}

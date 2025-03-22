import '../entities/captured_media.dart';
import '../repositories/camera_repository.dart';

class TakePicture {
  final CameraRepository repository;

  TakePicture(this.repository);

  Future<CapturedMedia?> call() async {
    return await repository.takePicture();
  }
}

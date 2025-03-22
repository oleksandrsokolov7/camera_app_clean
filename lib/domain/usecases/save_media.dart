import '../entities/captured_media.dart';
import '../repositories/camera_repository.dart';

class SaveMedia {
  final CameraRepository repository;

  SaveMedia(this.repository);

  Future<bool> call(CapturedMedia media) async {
    return await repository.saveMediaToGallery(media);
  }
}

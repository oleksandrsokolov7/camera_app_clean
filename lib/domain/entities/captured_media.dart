import 'dart:io';

enum MediaType { photo, video, image }

class CapturedMedia {
  final String path;
  final MediaType type;
  final DateTime capturedAt;
  final File file;

  CapturedMedia({
    required this.path,
    required this.type,
    required this.capturedAt,
    required this.file,
  });
}

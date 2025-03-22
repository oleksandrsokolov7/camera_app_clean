import 'package:equatable/equatable.dart';
import '../../domain/entities/captured_media.dart';

abstract class CameraEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitCameraEvent extends CameraEvent {}

class SwitchCameraEvent extends CameraEvent {}

class TakePictureEvent extends CameraEvent {}

class StartVideoRecordingEvent extends CameraEvent {}

class StopVideoRecordingEvent extends CameraEvent {}

class PickOverlayImageEvent extends CameraEvent {}

class SaveMediaEvent extends CameraEvent {
  final CapturedMedia media;

  SaveMediaEvent({required this.media});

  @override
  List<Object?> get props => [media];
}

import 'dart:io';
import 'package:equatable/equatable.dart';
import '../../domain/entities/captured_media.dart';

abstract class CameraState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CameraInitialState extends CameraState {}

class CameraLoadingState extends CameraState {}

class CameraReadyState extends CameraState {
  final File? overlayImage;
  final bool isRecording;

  CameraReadyState({this.overlayImage, required this.isRecording});

  @override
  List<Object?> get props => [overlayImage, isRecording];
}

class MediaCapturedState extends CameraState {
  final CapturedMedia media;
  final File? overlayImage;
  final bool isRecording;

  MediaCapturedState({
    required this.media,
    this.overlayImage,
    required this.isRecording,
  });

  @override
  List<Object?> get props => [media, overlayImage, isRecording];
}

class MediaSavedState extends CameraState {
  final CapturedMedia media;
  final File? overlayImage;
  final bool isRecording;

  MediaSavedState({
    required this.media,
    this.overlayImage,
    required this.isRecording,
  });

  @override
  List<Object?> get props => [media, overlayImage, isRecording];
}

class CameraErrorState extends CameraState {
  final String message;

  CameraErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}

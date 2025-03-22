import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/captured_media.dart';
import '../../domain/usecases/take_picture.dart';
import '../../domain/usecases/start_video_recording.dart';
import '../../domain/usecases/stop_video_recording.dart';
import '../../domain/usecases/save_media.dart';
import '../../domain/repositories/camera_repository.dart';
import 'camera_event.dart';
import 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraRepository repository;
  final TakePicture takePictureUseCase;
  final StartVideoRecording startVideoRecordingUseCase;
  final StopVideoRecording stopVideoRecordingUseCase;
  final SaveMedia saveMediaUseCase;

  CameraBloc({
    required this.repository,
    required this.takePictureUseCase,
    required this.startVideoRecordingUseCase,
    required this.stopVideoRecordingUseCase,
    required this.saveMediaUseCase,
  }) : super(CameraInitialState()) {
    on<InitCameraEvent>(_onInitCamera);
    on<SwitchCameraEvent>(_onSwitchCamera);
    on<TakePictureEvent>(_onTakePicture);
    on<StartVideoRecordingEvent>(_onStartVideoRecording);
    on<StopVideoRecordingEvent>(_onStopVideoRecording);
    on<PickOverlayImageEvent>(_onPickOverlayImage);
    on<SaveMediaEvent>(_onSaveMedia);
  }

  Future<void> _onInitCamera(
    InitCameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    emit(CameraLoadingState());
    try {
      await repository.initCamera();
      emit(
        CameraReadyState(
          overlayImage: repository.overlayImage,
          isRecording: repository.isRecording,
        ),
      );
    } catch (e) {
      emit(CameraErrorState(message: "Failed to initialize camera: $e"));
    }
  }

  Future<void> _onSwitchCamera(
    SwitchCameraEvent event,
    Emitter<CameraState> emit,
  ) async {
    emit(CameraLoadingState());
    try {
      await repository.switchCamera();
      emit(
        CameraReadyState(
          overlayImage: repository.overlayImage,
          isRecording: repository.isRecording,
        ),
      );
    } catch (e) {
      emit(CameraErrorState(message: "Failed to switch camera: $e"));
    }
  }

  Future<void> _onTakePicture(
    TakePictureEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final media = await takePictureUseCase();
      if (media != null) {
        emit(
          MediaCapturedState(
            media: media,
            overlayImage: repository.overlayImage,
            isRecording: repository.isRecording,
          ),
        );
      } else {
        emit(CameraErrorState(message: "Failed to take picture"));
      }
    } catch (e) {
      emit(CameraErrorState(message: "Error taking picture: $e"));
    }
  }

  Future<void> _onStartVideoRecording(
    StartVideoRecordingEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      await startVideoRecordingUseCase();
      emit(
        CameraReadyState(
          overlayImage: repository.overlayImage,
          isRecording: true,
        ),
      );
    } catch (e) {
      emit(CameraErrorState(message: "Failed to start recording: $e"));
    }
  }

  Future<void> _onStopVideoRecording(
    StopVideoRecordingEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final media = await stopVideoRecordingUseCase();
      if (media != null) {
        emit(
          MediaCapturedState(
            media: media,
            overlayImage: repository.overlayImage,
            isRecording: false,
          ),
        );
      } else {
        emit(CameraErrorState(message: "Failed to stop recording"));
      }
    } catch (e) {
      emit(CameraErrorState(message: "Error stopping recording: $e"));
    }
  }

  Future<void> _onPickOverlayImage(
    PickOverlayImageEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      await repository.pickOverlayImage();
      emit(
        CameraReadyState(
          overlayImage: repository.overlayImage,
          isRecording: repository.isRecording,
        ),
      );
    } catch (e) {
      emit(CameraErrorState(message: "Failed to pick overlay image: $e"));
    }
  }

  Future<void> _onSaveMedia(
    SaveMediaEvent event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final result = await saveMediaUseCase(event.media);
      if (result) {
        emit(
          MediaSavedState(
            media: event.media,
            overlayImage: repository.overlayImage,
            isRecording: repository.isRecording,
          ),
        );
      } else {
        emit(CameraErrorState(message: "Failed to save media"));
      }
    } catch (e) {
      emit(CameraErrorState(message: "Error saving media: $e"));
    }
  }
}

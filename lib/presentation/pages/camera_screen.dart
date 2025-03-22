import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera_app/domain/entities/captured_media.dart';
import 'package:camera_app/presentation/widgets/control_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/camera_bloc.dart';
import '../bloc/camera_event.dart';
import '../bloc/camera_state.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Вызываем инициализацию при первом построении виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CameraBloc>().add(InitCameraEvent());
    });

    return Scaffold(
      appBar: AppBar(title: const Text("Camera Screen")),
      body: BlocConsumer<CameraBloc, CameraState>(
        listener: (context, state) {
          if (state is CameraErrorState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CameraLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MediaCapturedState) {
            return Stack(
              children: [
                // Показать превью изображения или видео
                Positioned.fill(
                  child:
                      state.media.type == MediaType.photo
                          ? Image.file(state.media.file, fit: BoxFit.cover)
                          : Center(
                            child: Text("Видео записано: ${state.media.path}"),
                          ),
                ),

                // Кнопки действий
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Кнопка возврата к камере
                      FloatingActionButton(
                        onPressed: () {
                          context.read<CameraBloc>().add(InitCameraEvent());
                        },
                        heroTag: 'back',
                        child: const Icon(Icons.arrow_back),
                      ),

                      // Кнопка сохранения
                      FloatingActionButton(
                        onPressed: () {
                          context.read<CameraBloc>().add(
                            SaveMediaEvent(media: state.media),
                          );
                        },
                        heroTag: 'save',
                        backgroundColor: Colors.green,
                        child: const Icon(Icons.save),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is MediaSavedState) {
            return Stack(
              children: [
                Positioned.fill(
                  child:
                      state.media.type == MediaType.photo
                          ? Image.file(state.media.file, fit: BoxFit.cover)
                          : Center(
                            child: Text("Видео сохранено: ${state.media.path}"),
                          ),
                ),
                const Positioned(
                  top: 100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Card(
                      color: Colors.green,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Медиафайл успешно сохранен!",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: FloatingActionButton(
                      onPressed: () {
                        context.read<CameraBloc>().add(InitCameraEvent());
                      },
                      heroTag: 'back_to_camera',
                      child: const Icon(Icons.camera),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is CameraErrorState) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (state is CameraReadyState) {
            return Stack(
              children: [
                // Камера в виде превью
                Positioned.fill(child: CameraPreviewWidget()),

                // Наложение с прозрачностью
                if (state.overlayImage != null)
                  Positioned(
                    child: Opacity(
                      opacity: 0.8, // Прозрачность 80%
                      child: Image.file(state.overlayImage!, fit: BoxFit.cover),
                    ),
                  ),

                ControlButtons(
                  isRecording: state.isRecording,
                  onTakePicture: () {
                    context.read<CameraBloc>().add(TakePictureEvent());
                  },
                  onSwitchCamera: () {
                    context.read<CameraBloc>().add(SwitchCameraEvent());
                  },
                  onPickOverlay: () {
                    context.read<CameraBloc>().add(PickOverlayImageEvent());
                  },
                  onStartRecording: () {
                    context.read<CameraBloc>().add(StartVideoRecordingEvent());
                  },
                  onStopRecording: () {
                    context.read<CameraBloc>().add(StopVideoRecordingEvent());
                  },
                ),
              ],
            );
          }
          return const Center(child: Text("Camera is not ready"));
        },
      ),
    );
  }
}

class CameraPreviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<CameraBloc>().state;
    final cameraRepository = context.read<CameraBloc>().repository;

    if (cameraRepository.controller == null ||
        !cameraRepository.controller!.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Text(
            "Камера инициализируется...",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return CameraPreview(cameraRepository.controller!);
  }
}

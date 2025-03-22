import 'dart:io';
import 'package:camera/camera.dart';
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
      // остальной код...Scaffold(
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
                // Camera preview or other UI components related to camera
                Positioned.fill(child: CameraPreviewWidget()),
                if (state.overlayImage != null)
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Image.file(state.overlayImage!),
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

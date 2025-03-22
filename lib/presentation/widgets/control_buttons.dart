import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/camera_bloc.dart';
import '../bloc/camera_event.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({
    super.key,
    required this.isRecording,
    required Null Function() onTakePicture, // Не используются!
    required Null Function() onSwitchCamera,
    required Null Function() onPickOverlay,
    required Null Function() onStartRecording,
    required Null Function() onStopRecording,
  });

  final bool isRecording;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 60,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<CameraBloc>().add(SwitchCameraEvent());
            },
            heroTag: 'switch',
            child: const Icon(Icons.switch_camera),
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<CameraBloc>().add(TakePictureEvent());
            },
            heroTag: 'photo',
            child: const Icon(Icons.camera),
          ),
          FloatingActionButton(
            onPressed: () {
              if (isRecording) {
                context.read<CameraBloc>().add(StopVideoRecordingEvent());
              } else {
                context.read<CameraBloc>().add(StartVideoRecordingEvent());
              }
            },
            backgroundColor: isRecording ? Colors.red : Colors.blue,
            heroTag: 'video',
            child: Icon(isRecording ? Icons.stop : Icons.videocam),
          ),
          FloatingActionButton(
            onPressed: () {
              context.read<CameraBloc>().add(PickOverlayImageEvent());
            },
            heroTag: 'overlay',
            child: const Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}

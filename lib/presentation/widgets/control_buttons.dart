import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  final bool isRecording;
  final VoidCallback onTakePicture;
  final VoidCallback onSwitchCamera;
  final VoidCallback onPickOverlay;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;

  const ControlButtons({
    super.key,
    required this.isRecording,
    required this.onTakePicture,
    required this.onSwitchCamera,
    required this.onPickOverlay,
    required this.onStartRecording,
    required this.onStopRecording,
  });

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
            onPressed: onSwitchCamera,
            heroTag: 'switch',
            child: const Icon(Icons.switch_camera),
          ),
          FloatingActionButton(
            onPressed: onTakePicture,
            heroTag: 'photo',
            child: const Icon(Icons.camera),
          ),
          FloatingActionButton(
            onPressed: isRecording ? onStopRecording : onStartRecording,
            backgroundColor: isRecording ? Colors.red : Colors.blue,
            heroTag: 'video',
            child: Icon(isRecording ? Icons.stop : Icons.videocam),
          ),
          FloatingActionButton(
            onPressed: onPickOverlay,
            heroTag: 'overlay',
            child: const Icon(Icons.image),
          ),
        ],
      ),
    );
  }
}

import 'package:camera_app/presentation/pages/camera_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Data sources
import 'package:camera_app/data/datasources/camera_local_data_source.dart';

// Repositories
import 'package:camera_app/data/repositories/camera_repository_impl.dart';

// Use cases
import 'package:camera_app/domain/usecases/take_picture.dart';
import 'package:camera_app/domain/usecases/start_video_recording.dart';
import 'package:camera_app/domain/usecases/stop_video_recording.dart';
import 'package:camera_app/domain/usecases/save_media.dart';

// BLoC
import 'package:camera_app/presentation/bloc/camera_bloc.dart';

// Screens

// Core utils
import 'package:camera_app/core/utils/permission_handler.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Request camera permissions
  final hasPermissions = await PermissionHelper.requestCameraPermissions();
  if (!hasPermissions) {
    // Handle permission denied case if needed
    print("Camera permissions not granted!");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CameraBloc>(create: (context) => _createCameraBloc()),
        ],
        child: const CameraScreen(),
      ),
    );
  }

  CameraBloc _createCameraBloc() {
    // Initialize the data source
    final cameraDataSource = CameraLocalDataSource();

    // Create the repository
    final cameraRepository = CameraRepositoryImpl(dataSource: cameraDataSource);

    // Create the use cases
    final takePictureUseCase = TakePicture(cameraRepository);
    final startVideoRecordingUseCase = StartVideoRecording(cameraRepository);
    final stopVideoRecordingUseCase = StopVideoRecording(cameraRepository);
    final saveMediaUseCase = SaveMedia(cameraRepository);

    // Create and return the camera bloc
    return CameraBloc(
      repository: cameraRepository,
      takePictureUseCase: takePictureUseCase,
      startVideoRecordingUseCase: startVideoRecordingUseCase,
      stopVideoRecordingUseCase: stopVideoRecordingUseCase,
      saveMediaUseCase: saveMediaUseCase,
    );
  }
}

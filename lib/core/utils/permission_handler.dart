import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestCameraPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();
    final hasPermissions = await PermissionHelper.requestCameraPermissions();
    if (!hasPermissions) {
      // Handle permission denied case if needed
      print("Camera permissions not granted!");
    }
    if (cameraStatus.isDenied || microphoneStatus.isDenied) {
      print("Необходимо предоставить разрешения для камеры и микрофона");
      return false;
    }

    return true;
  }
}

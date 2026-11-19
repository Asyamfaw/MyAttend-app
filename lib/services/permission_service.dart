import 'package:permission_handler/permission_handler.dart';

/// Hasil permintaan izin kamera.
enum CameraPermissionResult {
  granted,
  denied,
  permanentlyDenied,
}

/// Layanan untuk mengelola izin kamera perangkat.
class PermissionService {
  /// Memeriksa dan meminta izin kamera.
  Future<CameraPermissionResult> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      return CameraPermissionResult.granted;
    }

    status = await Permission.camera.request();
    if (status.isGranted) {
      return CameraPermissionResult.granted;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      return CameraPermissionResult.permanentlyDenied;
    }
    return CameraPermissionResult.denied;
  }

  /// Membuka pengaturan aplikasi agar pengguna dapat mengaktifkan izin secara manual.
  Future<bool> openSettings() {
    return openAppSettings();
  }
}

import 'package:attendance_app/services/permission_service.dart';
import 'package:attendance_app/services/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Tombol aksi kamera satu ketuk untuk mengambil dan menyimpan foto presensi.
class CameraButton extends StatelessWidget {
  const CameraButton({
    super.key,
    required this.label,
    required this.photoType,
    required this.photoStorage,
    required this.isLoading,
    required this.onPhotoCaptured,
    required this.onError,
    this.permissionService,
    this.imagePicker,
    this.icon = Icons.camera_alt,
  });

  final String label;
  final String photoType;
  final PhotoStorage photoStorage;
  final bool isLoading;
  final Future<void> Function(String savedPhotoPath) onPhotoCaptured;
  final void Function(Object error) onError;
  final PermissionService? permissionService;
  final ImagePicker? imagePicker;
  final IconData icon;

  Future<void> _handleTap(BuildContext context) async {
    final permService = permissionService ?? PermissionService();
    final picker = imagePicker ?? ImagePicker();

    try {
      final permission = await permService.requestCameraPermission();

      if (permission == CameraPermissionResult.denied) {
        if (!context.mounted) return;
        final retry = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Izin Kamera Diperlukan'),
            content: const Text(
              'Aplikasi memerlukan akses kamera untuk mengambil foto presensi.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Batal'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        );
        if (retry == true && context.mounted) {
          await _handleTap(context);
        }
        return;
      }

      if (permission == CameraPermissionResult.permanentlyDenied) {
        if (!context.mounted) return;
        await showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Izin Kamera Ditolak Permanen'),
            content: const Text(
              'Aktifkan izin kamera melalui pengaturan aplikasi agar dapat melakukan presensi.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Tutup'),
              ),
              FilledButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await permService.openSettings();
                },
                child: const Text('Buka Pengaturan'),
              ),
            ],
          ),
        );
        return;
      }

      // Izin diberikan: buka kamera secara langsung (tanpa pilihan galeri).
      final pickedFile = await picker.pickImage(source: ImageSource.camera);
      if (pickedFile == null) {
        // Pengguna membatalkan pengambilan foto: hentikan tanpa galat.
        return;
      }

      final savedPath = await photoStorage.savePhoto(pickedFile.path, photoType);
      await onPhotoCaptured(savedPath);
    } catch (e) {
      onError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: isLoading ? null : () => _handleTap(context),
      icon: isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(icon),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
      ),
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

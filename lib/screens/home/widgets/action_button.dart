import 'package:attendance_app/models/attendance_record.dart';
import 'package:attendance_app/screens/home/widgets/camera_button.dart';
import 'package:attendance_app/services/storage_services.dart';
import 'package:flutter/material.dart';

/// Tombol aksi utama Masuk / Pulang berdasarkan status presensi hari ini.
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.todayRecord,
    required this.photoStorage,
    required this.isLoading,
    required this.onCheckInPhoto,
    required this.onCheckOutPhoto,
    required this.onError,
  });

  final AttendanceRecord? todayRecord;
  final PhotoStorage photoStorage;
  final bool isLoading;
  final Future<void> Function(String savedPath) onCheckInPhoto;
  final Future<void> Function(String savedPath) onCheckOutPhoto;
  final void Function(Object error) onError;

  @override
  Widget build(BuildContext context) {
    final record = todayRecord;

    // Sudah pulang: tidak ada tombol aksi.
    if (record != null && record.checkOutTime != null) {
      return const SizedBox.shrink();
    }

    if (record == null) {
      return CameraButton(
        label: 'Masuk',
        photoType: 'checkin',
        photoStorage: photoStorage,
        isLoading: isLoading,
        onPhotoCaptured: onCheckInPhoto,
        onError: onError,
        icon: Icons.login,
      );
    }

    return CameraButton(
      label: 'Pulang',
      photoType: 'checkout',
      photoStorage: photoStorage,
      isLoading: isLoading,
      onPhotoCaptured: onCheckOutPhoto,
      onError: onError,
      icon: Icons.logout,
    );
  }
}

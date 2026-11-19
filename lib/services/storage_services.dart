import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Antarmuka penyimpanan foto presensi agar mudah ditukar ke cloud di masa depan.
abstract class PhotoStorage {
  /// Menyimpan foto dari [sourcePath] untuk jenis [photoType] ('checkin' atau 'checkout').
  Future<String> savePhoto(String sourcePath, String photoType);
}

/// Implementasi penyimpanan foto lokal di perangkat.
class StorageServices implements PhotoStorage {
  @override
  Future<String> savePhoto(String sourcePath, String photoType) async {
    if (photoType != 'checkin' && photoType != 'checkout') {
      throw ArgumentError.value(
        photoType,
        'photoType',
        "photoType hanya boleh 'checkin' atau 'checkout'.",
      );
    }

    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw StateError('File foto sumber tidak ditemukan.');
    }

    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory(p.join(appDir.path, 'attendance_photos'));
    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final fileName = '${timestamp}_$photoType.jpg';
    final targetPath = p.join(photosDir.path, fileName);

    final compressed = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      quality: 75,
      format: CompressFormat.jpeg,
    );

    if (compressed == null) {
      throw StateError('Gagal mengompres foto presensi.');
    }

    final savedFile = File(compressed.path);
    if (!await savedFile.exists()) {
      throw StateError('Gagal menyimpan foto hasil kompresi.');
    }

    return savedFile.path;
  }

  /// Meski bernama upload, versi ini hanya menyimpan lokal.
  Future<String> uploadAttendancePhoto(String sourcePath, String photoType) {
    return savePhoto(sourcePath, photoType);
  }
}

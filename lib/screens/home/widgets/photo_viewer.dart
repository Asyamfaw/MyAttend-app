import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Layar penampil foto presensi layar penuh dengan dukungan zoom.
class PhotoViewer extends StatelessWidget {
  const PhotoViewer({
    super.key,
    required this.photoPath,
    this.title = 'Foto Presensi',
  });

  final String? photoPath;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 4.0,
          child: AttendancePhotoImage(
            photoPath: photoPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

/// Widget pembantu untuk merender foto dari path lokal, Base64, atau placeholder.
class AttendancePhotoImage extends StatelessWidget {
  const AttendancePhotoImage({
    super.key,
    required this.photoPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String? photoPath;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final path = photoPath;
    if (path == null || path.trim().isEmpty) {
      return _buildPlaceholder(context);
    }

    // Cabang masa depan: tambahkan penanganan object path cloud di sini.

    // 1. Cabang file lokal
    if (!path.startsWith('data:') && !path.startsWith('base64:')) {
      final file = File(path);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (_, _, _) => _buildPlaceholder(context),
        );
      }
    }

    // 2. Cabang Base64 (kompatibilitas modul)
    final bytes = _tryDecodeBase64(path);
    if (bytes != null) {
      return Image.memory(
        bytes,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => _buildPlaceholder(context),
      );
    }

    // 3. Placeholder bila file hilang, null, atau gagal dibaca
    return _buildPlaceholder(context);
  }

  Uint8List? _tryDecodeBase64(String raw) {
    try {
      var normalized = raw;
      if (normalized.startsWith('base64:')) {
        normalized = normalized.substring(7);
      } else if (normalized.startsWith('data:')) {
        final commaIndex = normalized.indexOf(',');
        if (commaIndex == -1) return null;
        normalized = normalized.substring(commaIndex + 1);
      }
      return base64Decode(normalized);
    } catch (_) {
      return null;
    }
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported_outlined,
            size: 36,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 8),
          Text(
            'Foto tidak tersedia',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

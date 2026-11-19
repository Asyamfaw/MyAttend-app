import 'package:attendance_app/models/attendance_record.dart';
import 'package:attendance_app/screens/home/widgets/photo_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Kartu satu catatan presensi pada layar riwayat.
class RecordCard extends StatelessWidget {
  const RecordCard({
    super.key,
    required this.record,
  });

  final AttendanceRecord record;

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours jam $minutes menit';
  }

  void _openPhoto(BuildContext context, String? path, String title) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => PhotoViewer(photoPath: path, title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final dateFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
    final timeFormat = DateFormat('HH:mm', 'id_ID');
    final checkOut = record.checkOutTime;
    final duration = record.totalHours;
    final isDone = checkOut != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.surfaceContainer),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.03),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris tanggal dan lencana status
          Row(
            children: [
              Expanded(
                child: Text(
                  dateFormat.format(record.date),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isDone
                      ? colorScheme.secondaryContainer
                      : colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isDone ? Icons.check_circle_outline : Icons.schedule,
                      size: 14,
                      color: isDone
                          ? colorScheme.onSecondaryContainer
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isDone ? 'Selesai' : 'Belum Pulang',
                      style: textTheme.labelSmall?.copyWith(
                        color: isDone
                            ? colorScheme.onSecondaryContainer
                            : colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Kotak ringkasan waktu masuk, pulang, dan durasi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _HistoryMetric(
                    icon: Icons.login,
                    iconColor: colorScheme.secondary,
                    label: 'Masuk',
                    value: timeFormat.format(record.checkInTime),
                  ),
                ),
                Expanded(
                  child: _HistoryMetric(
                    icon: Icons.logout,
                    iconColor: colorScheme.onSurfaceVariant,
                    label: 'Pulang',
                    value: checkOut != null
                        ? timeFormat.format(checkOut)
                        : 'Belum pulang',
                  ),
                ),
                Expanded(
                  child: _HistoryMetric(
                    icon: Icons.access_time,
                    iconColor: colorScheme.onSurfaceVariant,
                    label: 'Durasi',
                    value: duration != null ? _formatDuration(duration) : '-',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'BUKTI FOTO',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              letterSpacing: 0.6,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _MiniPhoto(
                  label: 'Foto Masuk',
                  timeText: '${timeFormat.format(record.checkInTime)} WIB',
                  photoPath: record.checkInPhotoPath,
                  onTap: () => _openPhoto(
                    context,
                    record.checkInPhotoPath,
                    'Foto Masuk',
                  ),
                ),
              ),
              if (checkOut != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniPhoto(
                    label: 'Foto Pulang',
                    timeText: '${timeFormat.format(checkOut)} WIB',
                    photoPath: record.checkOutPhotoPath,
                    onTap: () => _openPhoto(
                      context,
                      record.checkOutPhotoPath,
                      'Foto Pulang',
                    ),
                  ),
                ),
              ] else
                const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryMetric extends StatelessWidget {
  const _HistoryMetric({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 13, color: iconColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _MiniPhoto extends StatelessWidget {
  const _MiniPhoto({
    required this.label,
    required this.timeText,
    required this.photoPath,
    required this.onTap,
  });

  final String label;
  final String timeText;
  final String? photoPath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              height: 112,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AttendancePhotoImage(photoPath: photoPath),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 6,
                    right: 6,
                    bottom: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        timeText,
                        textAlign: TextAlign.center,
                        style: textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 14,
                color: colorScheme.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

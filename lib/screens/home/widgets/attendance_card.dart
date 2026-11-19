import 'package:attendance_app/models/attendance_record.dart';
import 'package:attendance_app/screens/home/widgets/photo_viewer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Kartu status presensi hari ini (belum masuk, sudah masuk, atau sudah pulang).
class AttendanceCard extends StatelessWidget {
  const AttendanceCard({
    super.key,
    required this.record,
  });

  final AttendanceRecord? record;

  String _formatShortDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}j ${minutes}m';
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
    final current = record;

    if (current == null) {
      return Container(
        padding: const EdgeInsets.all(20),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Belum Presensi',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              dateFormat.format(DateTime.now()),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.event_note_outlined,
                    size: 36,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Belum ada presensi hari ini',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    final checkOut = current.checkOutTime;
    final duration = current.totalHours;
    final isDone = checkOut != null;

    return Container(
      padding: const EdgeInsets.all(20),
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
          // Lencana status harian
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDone
                  ? colorScheme.secondaryContainer
                  : colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isDone ? Icons.check_circle_outline : Icons.schedule,
                  size: 16,
                  color: isDone
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  isDone ? 'Presensi Hari Ini Selesai' : 'Sudah Masuk',
                  style: textTheme.labelMedium?.copyWith(
                    color: isDone
                        ? colorScheme.onSecondaryContainer
                        : colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            dateFormat.format(current.date),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          // Kotak metrik Masuk / Pulang / Durasi
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MetricColumn(
                    icon: Icons.login,
                    iconColor: colorScheme.secondary,
                    label: 'MASUK',
                    value: timeFormat.format(current.checkInTime),
                    caption: 'Tercatat',
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: _MetricColumn(
                      icon: Icons.logout,
                      iconColor: colorScheme.onSurfaceVariant,
                      label: 'PULANG',
                      value: checkOut != null ? timeFormat.format(checkOut) : '--:--',
                      caption: checkOut != null ? 'Selesai' : 'Menunggu',
                    ),
                  ),
                ),
                Expanded(
                  child: _MetricColumn(
                    icon: Icons.access_time,
                    iconColor: colorScheme.onSurfaceVariant,
                    label: 'DURASI',
                    value: duration != null ? _formatShortDuration(duration) : '--',
                    caption: 'Total Jam',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Dokumentasi Foto',
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _PhotoThumbnailTile(
                  label: 'Foto Masuk',
                  timeText: '${timeFormat.format(current.checkInTime)} WIB',
                  photoPath: current.checkInPhotoPath,
                  onTap: () => _openPhoto(
                    context,
                    current.checkInPhotoPath,
                    'Foto Masuk',
                  ),
                ),
              ),
              if (checkOut != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: _PhotoThumbnailTile(
                    label: 'Foto Pulang',
                    timeText: '${timeFormat.format(checkOut)} WIB',
                    photoPath: current.checkOutPhotoPath,
                    onTap: () => _openPhoto(
                      context,
                      current.checkOutPhotoPath,
                      'Foto Pulang',
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.caption,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 13, color: iconColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          caption,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _PhotoThumbnailTile extends StatelessWidget {
  const _PhotoThumbnailTile({
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
        crossAxisAlignment: CrossAxisAlignment.start,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              Icon(
                Icons.check_circle_outline,
                size: 15,
                color: colorScheme.secondary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

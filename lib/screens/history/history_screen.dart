import 'package:attendance_app/models/attendance_record.dart';
import 'package:attendance_app/screens/history/widgets/record_card.dart';
import 'package:attendance_app/services/attendance_service.dart';
import 'package:attendance_app/services/auth_services.dart';
import 'package:flutter/material.dart';

/// Layar riwayat presensi milik pengguna yang sedang masuk.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final user = AuthServices().currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Riwayat Presensi')),
        body: const Center(
          child: Text('Sesi berakhir. Silakan masuk kembali.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Presensi')),
      body: StreamBuilder<List<AttendanceRecord>>(
        stream: AttendanceService().getAttendanceRecords(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Gagal memuat riwayat presensi: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final records = List<AttendanceRecord>.from(snapshot.data ?? []);
          if (records.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_toggle_off,
                    size: 48,
                    color: colorScheme.outline,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Belum ada riwayat presensi',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          // Urutan terbaru dulu berdasarkan checkInTime.
          records.sort((a, b) => b.checkInTime.compareTo(a.checkInTime));

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: records.length + 1,
            itemBuilder: (context, index) {
              if (index == records.length) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Column(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainer,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.verified_outlined,
                          size: 20,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Semua Presensi Telah Ditampilkan',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return RecordCard(record: records[index]);
            },
          );
        },
      ),
    );
  }
}

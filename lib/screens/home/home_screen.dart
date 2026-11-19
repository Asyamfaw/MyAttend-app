import 'dart:async';

import 'package:attendance_app/models/attendance_record.dart';
import 'package:attendance_app/screens/history/history_screen.dart';
import 'package:attendance_app/screens/home/widgets/action_button.dart';
import 'package:attendance_app/screens/home/widgets/attendance_card.dart';
import 'package:attendance_app/screens/home/widgets/profile_card.dart';
import 'package:attendance_app/services/attendance_service.dart';
import 'package:attendance_app/services/auth_services.dart';
import 'package:attendance_app/services/storage_services.dart';
import 'package:flutter/material.dart';

/// Dialog konfirmasi keluar akun yang dapat diuji secara terpisah.
class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Keluar'),
      content: const Text('Keluar dari akun?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Keluar'),
        ),
      ],
    );
  }
}

/// Layar utama beranda untuk melakukan presensi masuk dan pulang.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _authServices = AuthServices();
  final _attendanceService = AttendanceService();
  final PhotoStorage _photoStorage = StorageServices();

  StreamSubscription<AttendanceRecord?>? _todaySubscription;
  AttendanceRecord? _todayRecord;
  Object? _streamError;
  bool _isStreamLoading = true;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscribeTodayRecord();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _todaySubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Langgan ulang stream saat aplikasi kembali aktif agar pergantian tanggal terbaca.
    if (state == AppLifecycleState.resumed) {
      _subscribeTodayRecord();
    }
  }

  void _subscribeTodayRecord() {
    final user = _authServices.currentUser;
    if (user == null) {
      return;
    }

    _todaySubscription?.cancel();
    setState(() {
      _isStreamLoading = true;
      _streamError = null;
    });

    _todaySubscription = _attendanceService
        .getTodayRecordStream(user.uid)
        .listen(
          (record) {
            if (!mounted) return;
            setState(() {
              _todayRecord = record;
              _isStreamLoading = false;
              _streamError = null;
            });
          },
          onError: (Object error) {
            if (!mounted) return;
            setState(() {
              _isStreamLoading = false;
              _streamError = error;
            });
          },
        );
  }

  Future<void> _checkIn(String savedPhotoPath) async {
    final user = _authServices.currentUser;
    if (user == null) {
      await _authServices.signOut();
      return;
    }
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final record = AttendanceRecord(
        id: '',
        userId: user.uid,
        checkInTime: now,
        date: today,
        checkInPhotoPath: savedPhotoPath,
      );

      await _attendanceService.createAttendanceRecord(record);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Presensi masuk berhasil dicatat.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mencatat presensi masuk: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Future<void> _checkOut(String savedPhotoPath) async {
    final current = _todayRecord;
    if (current == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data presensi masuk tidak ditemukan.')),
      );
      return;
    }
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    try {
      final updated = current.copyWith(
        checkOutTime: DateTime.now(),
        checkOutPhotoPath: savedPhotoPath,
      );

      await _attendanceService.updateAttendanceRecord(updated);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Presensi pulang berhasil dicatat.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mencatat presensi pulang: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  void _handlePhotoError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Gagal memproses foto: $error')));
  }

  Future<void> _confirmSignOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const LogoutDialog(),
    );
    if (confirmed == true) {
      await _authServices.signOut();
    }
  }

  void _openHistory() {
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => const HistoryScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final email = _authServices.currentUser?.email ?? '-';

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            // Header Dashboard sesuai desain
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MyAttend',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'SISTEM KEHADIRAN DIGITAL',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _HeaderIconButton(
                  tooltip: 'Riwayat',
                  icon: Icons.history,
                  color: colorScheme.onSurface,
                  backgroundColor: colorScheme.surfaceContainerLow,
                  onPressed: _openHistory,
                ),
                const SizedBox(width: 8),
                _HeaderIconButton(
                  tooltip: 'Keluar',
                  icon: Icons.logout,
                  color: colorScheme.error,
                  backgroundColor: colorScheme.surfaceContainerLow,
                  onPressed: _confirmSignOut,
                ),
              ],
            ),
            const SizedBox(height: 20),
            ProfileCard(email: email),
            const SizedBox(height: 16),
            if (_isStreamLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_streamError != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Gagal memuat presensi hari ini: $_streamError'),
                      const SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: _subscribeTodayRecord,
                        child: const Text('Muat Ulang'),
                      ),
                    ],
                  ),
                ),
              )
            else ...[
              AttendanceCard(record: _todayRecord),
              if (_todayRecord == null || _todayRecord?.checkOutTime == null)
                const SizedBox(height: 16),
              ActionButton(
                todayRecord: _todayRecord,
                photoStorage: _photoStorage,
                isLoading: _isSubmitting,
                onCheckInPhoto: _checkIn,
                onCheckOutPhoto: _checkOut,
                onError: _handlePhotoError,
              ),
            ],
            const SizedBox(height: 16),
            // Tombol Lihat Riwayat Presensi bergaya kartu putih
            Material(
              color: colorScheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: _openHistory,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  height: 54,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.surfaceContainer),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 20,
                        color: colorScheme.onSurface,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Lihat Riwayat Presensi',
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

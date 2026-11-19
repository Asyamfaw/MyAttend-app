import 'dart:async';
import 'dart:convert';

import 'package:attendance_app/models/attendance_record.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Layanan data presensi lokal menggunakan cache memori dan SharedPreferences.
class AttendanceService {
  AttendanceService._internal();

  static final AttendanceService _instance = AttendanceService._internal();

  factory AttendanceService() => _instance;

  static const String _storageKey = 'local_attendance_records_v1';

  final List<AttendanceRecord> _records = [];
  final StreamController<void> _updatesController =
      StreamController<void>.broadcast();
  bool _initialized = false;

  /// Memuat cache memori sekali dari SharedPreferences.
  Future<void> _initStorage() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw) as List<dynamic>;
      _records
        ..clear()
        ..addAll(
          decoded.map(
            (item) => AttendanceRecord.fromJson(item as Map<String, dynamic>),
          ),
        );
    }
    _initialized = true;
  }

  /// Menyimpan seluruh cache memori ke SharedPreferences.
  Future<void> _persistRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_records.map((r) => r.toJson()).toList());
    final saved = await prefs.setString(_storageKey, encoded);
    if (!saved) {
      throw StateError('Gagal menyimpan data presensi ke penyimpanan lokal.');
    }
  }

  /// Memberi tahu seluruh pendengar stream bahwa cache telah berubah.
  void _emitUpdates() {
    if (!_updatesController.isClosed) {
      _updatesController.add(null);
    }
  }

  List<AttendanceRecord> _filterByUser(String userId) {
    return _records.where((r) => r.userId == userId).toList();
  }

  /// Mengalirkan daftar presensi milik [userId] (terbaru tidak diurutkan di sini).
  Stream<List<AttendanceRecord>> getAttendanceRecords(String userId) async* {
    if (userId.isEmpty) {
      throw ArgumentError('userId tidak boleh kosong.');
    }
    await _initStorage();
    yield _filterByUser(userId);
    yield* _updatesController.stream.map((_) => _filterByUser(userId));
  }

  /// Mengalirkan catatan presensi hari ini milik [userId], atau null jika belum ada.
  Stream<AttendanceRecord?> getTodayRecordStream(String userId) {
    return getAttendanceRecords(userId).map((records) {
      final now = DateTime.now();
      for (final record in records) {
        if (record.date.year == now.year &&
            record.date.month == now.month &&
            record.date.day == now.day) {
          return record;
        }
      }
      return null;
    });
  }

  /// Membuat catatan presensi baru dan mengembalikan ID-nya.
  Future<String> createAttendanceRecord(AttendanceRecord record) async {
    if (record.userId.isEmpty) {
      throw ArgumentError('userId tidak boleh kosong.');
    }
    await _initStorage();

    final alreadyExists = _records.any(
      (r) =>
          r.userId == record.userId &&
          r.date.year == record.date.year &&
          r.date.month == record.date.month &&
          r.date.day == record.date.day,
    );
    if (alreadyExists) {
      throw StateError('Presensi hari ini sudah ada.');
    }

    final id = DateTime.now().microsecondsSinceEpoch.toString();
    final newRecord = record.copyWith(id: id);
    _records.add(newRecord);

    try {
      await _persistRecords();
    } catch (_) {
      _records.removeWhere((r) => r.id == id);
      rethrow;
    }

    _emitUpdates();
    return id;
  }

  /// Memperbarui catatan presensi yang sudah ada.
  Future<void> updateAttendanceRecord(AttendanceRecord record) async {
    if (record.userId.isEmpty) {
      throw ArgumentError('userId tidak boleh kosong.');
    }
    await _initStorage();

    final index = _records.indexWhere(
      (r) => r.id == record.id && r.userId == record.userId,
    );
    if (index == -1) {
      throw StateError('Data presensi tidak ditemukan.');
    }

    final previous = _records[index];
    _records[index] = record;

    try {
      await _persistRecords();
    } catch (_) {
      _records[index] = previous;
      rethrow;
    }

    _emitUpdates();
  }
}

// Nama kelas belum berarti membaca Firestore. Versi ini hanya meneruskan ke AttendanceService.

import 'package:attendance_app/models/attendance_record.dart';
import 'package:attendance_app/services/attendance_service.dart';

/// Adapter tipis yang meneruskan semua pemanggilan ke [AttendanceService].
class FirestoreService {
  FirestoreService({AttendanceService? attendanceService})
    : _attendanceService = attendanceService ?? AttendanceService();

  final AttendanceService _attendanceService;

  Stream<List<AttendanceRecord>> getAttendanceRecords(String userId) {
    return _attendanceService.getAttendanceRecords(userId);
  }

  Stream<AttendanceRecord?> getTodayRecordStream(String userId) {
    return _attendanceService.getTodayRecordStream(userId);
  }

  Future<String> createAttendanceRecord(AttendanceRecord record) {
    return _attendanceService.createAttendanceRecord(record);
  }

  Future<void> updateAttendanceRecord(AttendanceRecord record) {
    return _attendanceService.updateAttendanceRecord(record);
  }
}

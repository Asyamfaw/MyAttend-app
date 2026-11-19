import 'package:attendance_app/models/attendance_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AttendanceRecord', () {
    test('round-trip toJson dan fromJson mempertahankan semua field', () {
      final record = AttendanceRecord(
        id: '1700000000000',
        userId: 'uid_123',
        checkInTime: DateTime(2026, 11, 12, 8, 15, 30),
        checkOutTime: DateTime(2026, 11, 12, 16, 45, 0),
        date: DateTime(2026, 11, 12),
        location: null,
        notes: null,
        checkInPhotoPath: '/tmp/20261112_081530_checkin.jpg',
        checkOutPhotoPath: '/tmp/20261112_164500_checkout.jpg',
      );

      final json = record.toJson();
      expect(json['date'], '2026-11-12');

      final restored = AttendanceRecord.fromJson(json);
      expect(restored.id, record.id);
      expect(restored.userId, record.userId);
      expect(restored.checkInTime, record.checkInTime);
      expect(restored.checkOutTime, record.checkOutTime);
      expect(restored.date, record.date);
      expect(restored.checkInPhotoPath, record.checkInPhotoPath);
      expect(restored.checkOutPhotoPath, record.checkOutPhotoPath);
    });

    test('copyWith melengkapi checkOutTime tanpa mengubah id', () {
      final checkIn = AttendanceRecord(
        id: 'rec_1',
        userId: 'uid_1',
        checkInTime: DateTime(2026, 11, 12, 8, 0),
        date: DateTime(2026, 11, 12),
        checkInPhotoPath: '/tmp/in.jpg',
      );

      final checkOutTime = DateTime(2026, 11, 12, 16, 0);
      final updated = checkIn.copyWith(
        checkOutTime: checkOutTime,
        checkOutPhotoPath: '/tmp/out.jpg',
      );

      expect(updated.id, 'rec_1');
      expect(updated.checkOutTime, checkOutTime);
      expect(updated.checkOutPhotoPath, '/tmp/out.jpg');
      expect(updated.checkInPhotoPath, '/tmp/in.jpg');
    });

    test('totalHours null sebelum pulang dan menghitung durasi setelah pulang', () {
      final beforeOut = AttendanceRecord(
        id: 'rec_1',
        userId: 'uid_1',
        checkInTime: DateTime(2026, 11, 12, 8, 0),
        date: DateTime(2026, 11, 12),
      );
      expect(beforeOut.totalHours, isNull);

      final exactEightHours = beforeOut.copyWith(
        checkOutTime: DateTime(2026, 11, 12, 16, 0),
      );
      expect(exactEightHours.totalHours, const Duration(hours: 8));

      final eightHoursThirty = AttendanceRecord(
        id: 'rec_2',
        userId: 'uid_1',
        checkInTime: DateTime(2026, 11, 12, 8, 15),
        checkOutTime: DateTime(2026, 11, 12, 16, 45),
        date: DateTime(2026, 11, 12),
      );
      expect(
        eightHoursThirty.totalHours,
        const Duration(hours: 8, minutes: 30),
      );
    });
  });
}

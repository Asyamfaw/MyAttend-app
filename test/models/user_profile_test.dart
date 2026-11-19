import 'package:attendance_app/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserProfile', () {
    test('serialisasi dan deserialisasi mempertahankan semua field', () {
      final createdAt = DateTime(2026, 11, 12, 9, 0, 0);
      final profile = UserProfile(
        id: 'uid_abc',
        email: 'pengguna@contoh.com',
        fullName: 'Budi Santoso',
        createdAt: createdAt,
      );

      final json = profile.toJson();
      expect(json['role'], 'Pengguna');
      expect(json['full_name'], 'Budi Santoso');

      final restored = UserProfile.fromJson(json);
      expect(restored.id, profile.id);
      expect(restored.email, profile.email);
      expect(restored.fullName, profile.fullName);
      expect(restored.createdAt, profile.createdAt);
      expect(restored.role, 'Pengguna');
    });
  });
}

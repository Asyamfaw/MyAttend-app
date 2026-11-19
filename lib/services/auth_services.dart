import 'package:firebase_auth/firebase_auth.dart';

/// Pembungkus Firebase Authentication untuk masuk, daftar, keluar, dan pantau sesi.
class AuthServices {
  AuthServices({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  /// Aliran perubahan status autentikasi pengguna.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Pengguna yang sedang masuk saat ini, atau null jika belum masuk.
  User? get currentUser => _auth.currentUser;

  /// Masuk dengan email dan kata sandi.
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Mendaftarkan akun baru dengan email dan kata sandi.
  Future<UserCredential> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  /// Keluar dari akun yang sedang aktif.
  Future<void> signOut() {
    return _auth.signOut();
  }
}

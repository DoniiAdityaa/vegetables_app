import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseEmailAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseAuth get auth => _firebaseAuth;
  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  void _recordError(dynamic error, [StackTrace? stackTrace, String? reason]) {
    try {
      FirebaseCrashlytics.instance.recordError(
        error,
        stackTrace,
        reason: reason,
      );
    } catch (e) {
      debugPrint("Error recording to Crashlytics: $e");
    }
  }

  /// 1. Masuk / Sign In dengan Email & Password
  Future<void> signInWithEmail({
    required String email,
    required String password,
    required Function(User user) onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        onSuccess(user);
      } else {
        onError("Gagal masuk. Data user tidak ditemukan.");
      }
    } on FirebaseAuthException catch (e, stackTrace) {
      // Kesalahan input user (salah sandi, email belum terdaftar) bukan crash bug
      const userMistakeCodes = {
        'invalid-credential',
        'wrong-password',
        'user-not-found',
        'invalid-email',
        'email-already-in-use',
        'weak-password',
      };
      if (!userMistakeCodes.contains(e.code)) {
        _recordError(e.message ?? e.code, stackTrace, "signInWithEmail failed");
      }
      onError(_mapAuthErrorMessage(e.code, e.message));
    } catch (e, stackTrace) {
      _recordError(e.toString(), stackTrace, "signInWithEmail unexpected error");
      onError("Terjadi kesalahan tidak terduga. Silakan coba lagi.");
    }
  }

  /// 2. Daftar / Sign Up Akun Baru dengan Email, Password & Nama Lengkap
  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required Function(User user) onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Simpan nama lengkap ke profil user Firebase
        if (name.trim().isNotEmpty) {
          await user.updateDisplayName(name.trim());
          await user.reload();
        }
        final updatedUser = _firebaseAuth.currentUser ?? user;
        onSuccess(updatedUser);
      } else {
        onError("Pendaftaran gagal. Silakan coba lagi.");
      }
    } on FirebaseAuthException catch (e, stackTrace) {
      const userMistakeCodes = {
        'invalid-credential',
        'invalid-email',
        'email-already-in-use',
        'weak-password',
      };
      if (!userMistakeCodes.contains(e.code)) {
        _recordError(e.message ?? e.code, stackTrace, "signUpWithEmail failed");
      }
      onError(_mapAuthErrorMessage(e.code, e.message));
    } catch (e, stackTrace) {
      _recordError(e.toString(), stackTrace, "signUpWithEmail unexpected error");
      onError("Terjadi kesalahan tidak terduga saat pendaftaran.");
    }
  }

  /// 3. Lupa Kata Sandi / Send Password Reset Email
  Future<void> sendPasswordReset({
    required String email,
    required VoidCallback onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      onSuccess();
    } on FirebaseAuthException catch (e, stackTrace) {
      _recordError(e.message ?? e.code, stackTrace, "sendPasswordReset failed");
      onError(_mapAuthErrorMessage(e.code, e.message));
    } catch (e, stackTrace) {
      _recordError(e.toString(), stackTrace, "sendPasswordReset unexpected error");
      onError("Gagal mengirim email reset kata sandi.");
    }
  }

  /// 4. Keluar / Sign Out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e, stackTrace) {
      _recordError(e.toString(), stackTrace, "signOut failed");
      debugPrint("Error signing out: $e");
    }
  }

  /// Terjemahan pesan error Firebase Auth ke Bahasa Indonesia yang ramah
  String _mapAuthErrorMessage(String code, String? defaultMessage) {
    switch (code) {
      case 'invalid-email':
        return 'Format alamat email tidak valid.';
      case 'user-disabled':
        return 'Akun dengan email ini telah dinonaktifkan.';
      case 'user-not-found':
        return 'Akun dengan email ini belum terdaftar.';
      case 'wrong-password':
        return 'Kata sandi yang Anda masukkan salah.';
      case 'invalid-credential':
        return 'Email atau kata sandi tidak sesuai.';
      case 'email-already-in-use':
        return 'Email ini sudah terdaftar. Silakan langsung masuk.';
      case 'operation-not-allowed':
        return 'Metode masuk dengan email belum diaktifkan di server.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah. Gunakan minimal 6 karakter.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan gagal. Silakan coba beberapa saat lagi.';
      case 'network-request-failed':
        return 'Gagal terhubung ke internet. Periksa koneksi data/Wi-Fi Anda.';
      default:
        return defaultMessage ?? 'Terjadi kendala autentikasi. Silakan coba lagi.';
    }
  }
}

// Repository interface (kontrak) yang dibutuhkan domain.
// Data layer yang MENGIMPLEMENTASIKAN, domain layer yang MENGGUNAKANNYA.

import '../entities/session.dart';

abstract class AuthRepository {
  /// Login dengan email dan password. Mengembalikan Session.
  Future<Session> login({required String email, required String password});

  /// Mengembalikan access token yang tersimpan, atau null jika belum login.
  Future<String?> getAccessToken();

  /// Hapus seluruh token dari secure storage.
  Future<void> clearTokens();
}

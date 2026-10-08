// Implementasi kontrak AuthRepository yang didefinisikan domain.
// Boleh menyentuh Dio, flutter_secure_storage, dsb.

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/session_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  static const _kAccess = 'access_token';
  static const _kRefresh = 'refresh_token';

  final FlutterSecureStorage _storage;
  late final Dio _dio;

  AuthRepositoryImpl({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage() {
    _dio = Dio(BaseOptions(baseUrl: 'https://reqres.in/api'));
  }

  @override
  Future<Session> login({
    required String email,
    required String password,
  }) async {
    // Simulasi login dengan endpoint publik reqres.in (mengembalikan token)
    final response = await _dio.post('/login', data: {
      'email': email,
      'password': password,
    });

    // reqres.in mengembalikan {token: "..."}; kita bungkus sebagai Session
    final rawToken = response.data['token'] as String? ?? 'mock-access';
    final model = SessionModel(
      accessToken: rawToken,
      refreshToken: 'mock-refresh-$rawToken',
    );

    await _storage.write(key: _kAccess, value: model.accessToken);
    await _storage.write(key: _kRefresh, value: model.refreshToken);

    return model.toEntity();
  }

  @override
  Future<String?> getAccessToken() => _storage.read(key: _kAccess);

  @override
  Future<void> clearTokens() async {
    await _storage.delete(key: _kAccess);
    await _storage.delete(key: _kRefresh);
  }
}

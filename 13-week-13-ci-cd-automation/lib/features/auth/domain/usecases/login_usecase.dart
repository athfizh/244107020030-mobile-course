// Use Case: satu operasi bisnis = satu kelas.
// Tidak tahu apa pun tentang Dio/sqflite/Flutter.

import '../entities/session.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  const LoginUseCase(this._repository);

  Future<Session> call({required String email, required String password}) {
    return _repository.login(email: email, password: password);
  }
}

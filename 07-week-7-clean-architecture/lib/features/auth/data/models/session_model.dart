// Model: representasi data dari server/storage + mapping ke Entity.
// Hidup di data layer — domain tidak tahu model ini ada.

import '../../domain/entities/session.dart';

class SessionModel {
  final String accessToken;
  final String refreshToken;

  const SessionModel({
    required this.accessToken,
    required this.refreshToken,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      accessToken: json['access'] as String? ?? '',
      refreshToken: json['refresh'] as String? ?? '',
    );
  }

  /// Konversi dari Model ke Entity (murni Dart, tanpa dependensi eksternal)
  Session toEntity() => Session(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
}

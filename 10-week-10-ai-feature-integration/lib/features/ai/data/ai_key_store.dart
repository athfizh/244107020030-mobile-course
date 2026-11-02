import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Brankas API key.
///
/// Key tidak pernah ditulis ke kode, log, maupun repository. Hanya
/// disimpan pada penyimpanan terenkripsi milik sistem operasi.
class AiKeyStore {
  const AiKeyStore([this._storage = const FlutterSecureStorage()]);

  final FlutterSecureStorage _storage;

  static const _key = 'ai_api_key';

  Future<String?> read() async {
    final value = await _storage.read(key: _key);
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }

  Future<void> write(String apiKey) async {
    await _storage.write(key: _key, value: apiKey.trim());
  }

  Future<void> delete() async {
    await _storage.delete(key: _key);
  }

  /// Bentuk tersamar untuk ditampilkan pada layar pengaturan.
  static String mask(String apiKey) {
    if (apiKey.length <= 8) return '********';
    final head = apiKey.substring(0, 4);
    final tail = apiKey.substring(apiKey.length - 4);
    return '$head...$tail';
  }
}

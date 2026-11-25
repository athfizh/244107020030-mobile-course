import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Cache jawaban AI berbasis SharedPreferences dengan masa berlaku 1 hari.
class AiCache {
  AiCache([this._prefs]);

  SharedPreferences? _prefs;

  static const _prefix = 'ai_cache_';
  static const ttl = Duration(days: 1);

  Future<SharedPreferences> get _instance async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  static String _keyFor(String prompt) =>
      '$_prefix${base64Url.encode(utf8.encode(prompt.toLowerCase())).replaceAll('=', '')}';

  Future<String?> read(String prompt) async {
    final prefs = await _instance;
    final raw = prefs.getString(_keyFor(prompt));
    if (raw == null) return null;

    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final savedAt = DateTime.tryParse(data['savedAt'] as String? ?? '');
      if (savedAt == null) return null;
      if (DateTime.now().difference(savedAt) > ttl) return null;
      return data['answer'] as String?;
    } catch (_) {
      return null;
    }
  }

  Future<void> write(String prompt, String answer) async {
    final prefs = await _instance;
    await prefs.setString(
      _keyFor(prompt),
      jsonEncode({
        'answer': answer,
        'savedAt': DateTime.now().toIso8601String(),
      }),
    );
  }

  Future<void> clear() async {
    final prefs = await _instance;
    for (final key in prefs.getKeys().where((k) => k.startsWith(_prefix))) {
      await prefs.remove(key);
    }
  }
}

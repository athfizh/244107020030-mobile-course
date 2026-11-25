import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../domain/entities/announcement.dart';

/// Cache daftar pengumuman dengan strategi *stale-while-revalidate*.
///
/// Data cache dipakai untuk tampilan pertama agar layar tidak kosong,
/// lalu data segar dari jaringan menggantikannya ketika tersedia.
class AnnouncementCache {
  AnnouncementCache([this._prefs]);

  SharedPreferences? _prefs;

  static const _key = 'announcement_cache_v1';
  static const ttl = Duration(minutes: 5);

  Future<SharedPreferences> get _instance async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<List<Announcement>?> read() async {
    final prefs = await _instance;
    final raw = prefs.getString(_key);
    if (raw == null) return null;

    try {
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final savedAt = DateTime.tryParse(data['savedAt'] as String? ?? '');
      if (savedAt == null) return null;
      if (DateTime.now().difference(savedAt) > ttl) return null;

      final items = data['items'] as List<dynamic>;
      return items
          .map((e) => _fromMap(e as Map<String, dynamic>))
          .toList(growable: false);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(List<Announcement> items) async {
    final prefs = await _instance;
    await prefs.setString(
      _key,
      jsonEncode({
        'savedAt': DateTime.now().toIso8601String(),
        'items': items
            .map((a) => {'id': a.id, 'title': a.title, 'body': a.body})
            .toList(),
      }),
    );
  }

  Future<void> clear() async {
    final prefs = await _instance;
    await prefs.remove(_key);
  }

  Announcement _fromMap(Map<String, dynamic> map) => Announcement(
    id: map['id'] as String? ?? '',
    title: map['title'] as String? ?? '',
    body: map['body'] as String? ?? '',
  );
}

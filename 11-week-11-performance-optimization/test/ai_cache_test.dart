import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week11_performance/features/ai/data/ai_cache.dart';

String _key(String prompt) =>
    'ai_cache_${base64Url.encode(utf8.encode(prompt.toLowerCase())).replaceAll('=', '')}';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AiCache', () {
    test('jawaban tersimpan bisa dibaca kembali', () async {
      final cache = AiCache();
      await cache.write('Apa itu KRS?', 'KRS adalah Kartu Rencana Studi.');

      expect(
        await cache.read('Apa itu KRS?'),
        'KRS adalah Kartu Rencana Studi.',
      );
    });

    test('pencarian cache tidak membedakan huruf besar kecil', () async {
      final cache = AiCache();
      await cache.write('Apa itu KRS?', 'Jawaban tersimpan');

      expect(await cache.read('apa itu krs?'), 'Jawaban tersimpan');
    });

    test('prompt berbeda tidak menemukan cache', () async {
      final cache = AiCache();
      await cache.write('Apa itu KRS?', 'Jawaban tersimpan');

      expect(await cache.read('Apa itu UKT?'), isNull);
    });

    test('clear menghapus seluruh entri cache', () async {
      final cache = AiCache();
      await cache.write('satu', 'a');
      await cache.write('dua', 'b');

      await cache.clear();

      expect(await cache.read('satu'), isNull);
      expect(await cache.read('dua'), isNull);
    });

    test('entri kedaluwarsa dianggap tidak ada', () async {
      final stale = DateTime.now().subtract(const Duration(days: 3));
      SharedPreferences.setMockInitialValues({
        _key('prompt lama'):
            '{"answer":"jawaban lama","savedAt":"${stale.toIso8601String()}"}',
      });

      expect(await AiCache().read('prompt lama'), isNull);
    });

    test('entri yang masih segar tetap terbaca', () async {
      final fresh = DateTime.now().subtract(const Duration(hours: 2));
      SharedPreferences.setMockInitialValues({
        _key('prompt baru'):
            '{"answer":"jawaban baru","savedAt":"${fresh.toIso8601String()}"}',
      });

      expect(await AiCache().read('prompt baru'), 'jawaban baru');
    });
  });
}

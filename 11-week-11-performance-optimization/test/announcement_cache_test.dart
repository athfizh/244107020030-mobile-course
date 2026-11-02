import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week11_performance/features/announcement/data/announcement_cache.dart';
import 'package:week11_performance/features/announcement/domain/entities/announcement.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('AnnouncementCache', () {
    test('daftar kosong pada cache baru', () async {
      expect(await AnnouncementCache().read(), isNull);
    });

    test('daftar yang disimpan bisa dibaca kembali', () async {
      final cache = AnnouncementCache();
      await cache.write(const [
        Announcement(id: '1', title: 'Libur', body: 'Besok libur'),
        Announcement(id: '2', title: 'UTS', body: 'Minggu depan'),
      ]);

      final result = await cache.read();

      expect(result, isNotNull);
      expect(result, hasLength(2));
      expect(result!.first.title, 'Libur');
      expect(result.last.body, 'Minggu depan');
    });

    test('clear menghapus cache', () async {
      final cache = AnnouncementCache();
      await cache.write(const [Announcement(id: '1', title: 'A', body: 'a')]);

      await cache.clear();

      expect(await cache.read(), isNull);
    });

    test('cache kedaluwarsa dianggap tidak ada', () async {
      SharedPreferences.setMockInitialValues({
        'announcement_cache_v1': '{"savedAt":"2020-01-01T00:00:00.000","items":[{"id":"1","title":"Lama","body":"x"}]}',
      });

      expect(await AnnouncementCache().read(), isNull);
    });
  });
}

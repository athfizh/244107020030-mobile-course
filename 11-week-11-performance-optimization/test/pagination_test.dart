import 'package:flutter_test/flutter_test.dart';
import 'package:week11_performance/features/announcement/domain/entities/announcement.dart';
import 'package:week11_performance/features/announcement/domain/repositories/announcement_repository.dart';
import 'package:week11_performance/features/announcement/domain/usecases/get_announcements.dart';

class PagedFakeRepository implements AnnouncementRepository {
  PagedFakeRepository(this.total);

  final int total;
  final List<({int limit, int start})> calls = [];

  @override
  Future<List<Announcement>> getAnnouncements({
    int limit = 10,
    int start = 0,
  }) async {
    calls.add((limit: limit, start: start));
    return List.generate(limit, (i) {
      final id = start + i + 1;
      if (id > total) return null;
      return Announcement(id: '$id', title: 'Judul $id', body: 'Isi $id');
    }).whereType<Announcement>().toList();
  }

  @override
  Future<Announcement> getAnnouncementById(String id) async {
    return Announcement(id: id, title: 'Judul $id', body: 'Isi $id');
  }
}

void main() {
  group('GetAnnouncements paginasi', () {
    test('halaman pertama memakai limit bawaan 10', () async {
      final repo = PagedFakeRepository(25);
      final result = await GetAnnouncements(repo).call();

      expect(result, hasLength(10));
      expect(repo.calls.single.limit, 10);
      expect(repo.calls.single.start, 0);
    });

    test('halaman kedua memakai offset yang benar', () async {
      final repo = PagedFakeRepository(25);
      final result = await GetAnnouncements(repo).call(limit: 10, start: 10);

      expect(result.first.id, '11');
      expect(repo.calls.single.start, 10);
    });

    test('halaman terakhir boleh berisi kurang dari limit', () async {
      final repo = PagedFakeRepository(25);
      final result = await GetAnnouncements(repo).call(limit: 10, start: 20);

      expect(result, hasLength(5));
    });
  });
}

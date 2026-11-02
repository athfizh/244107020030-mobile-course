import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week11_performance/features/announcement/data/announcement_cache.dart';
import 'package:week11_performance/features/announcement/domain/entities/announcement.dart';
import 'package:week11_performance/features/announcement/domain/repositories/announcement_repository.dart';
import 'package:week11_performance/features/announcement/presentation/providers/announcement_providers.dart';

class _FakeRepository implements AnnouncementRepository {
  _FakeRepository(this.total);

  final int total;
  int calls = 0;

  @override
  Future<List<Announcement>> getAnnouncements({
    int limit = 10,
    int start = 0,
  }) async {
    calls++;
    final result = <Announcement>[];
    for (var i = 0; i < limit; i++) {
      final id = start + i + 1;
      if (id > total) break;
      result.add(Announcement(id: '$id', title: 'Judul $id', body: 'Isi $id'));
    }
    return result;
  }

  @override
  Future<Announcement> getAnnouncementById(String id) async {
    return Announcement(id: id, title: 'Judul $id', body: 'Isi $id');
  }
}

/// Cache yang selalu kosong agar notifier mengambil dari repository.
class _EmptyCache implements AnnouncementCache {
  @override
  Future<void> clear() async {}

  @override
  Future<List<Announcement>?> read() async => null;

  @override
  Future<void> write(List<Announcement> items) async {}
}

void main() {
  test('loadMore berhenti memanggil API ketika hasMore sudah false', () async {
    final repo = _FakeRepository(12);
    final container = ProviderContainer(
      overrides: [
        announcementRepositoryProvider.overrideWithValue(repo),
        announcementCacheProvider.overrideWithValue(_EmptyCache()),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(announcementsProvider.notifier);
    await container.read(announcementsProvider.future);

    expect(notifier.hasMore, isTrue);
    final callsAfterFirstPage = repo.calls;

    // Halaman kedua hanya berisi 2 item, jadi hasMore menjadi false.
    await notifier.loadMore();
    expect(notifier.hasMore, isFalse);
    final callsAfterSecondPage = repo.calls;
    expect(callsAfterSecondPage, callsAfterFirstPage + 1);

    // Pemanggilan berikutnya tidak boleh menembak API lagi.
    await notifier.loadMore();
    expect(repo.calls, callsAfterSecondPage);
  });
}

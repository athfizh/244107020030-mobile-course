import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/announcement_cache.dart';
import '../../data/dio_client.dart';
import '../../data/repositories/announcement_repository_impl.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../../domain/usecases/get_announcement_by_id.dart';
import '../../domain/usecases/get_announcements.dart';

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return AnnouncementRepositoryImpl(dio: announcementDio);
});

final announcementCacheProvider = Provider<AnnouncementCache>((ref) {
  return AnnouncementCache();
});

final getAnnouncementsProvider = Provider<GetAnnouncements>((ref) {
  return GetAnnouncements(ref.watch(announcementRepositoryProvider));
});

final getAnnouncementByIdProvider = Provider<GetAnnouncementById>((ref) {
  return GetAnnouncementById(ref.watch(announcementRepositoryProvider));
});

/// Daftar pengumuman dengan paginasi dan cache *stale-while-revalidate*.
///
/// Cache ditampilkan lebih dulu agar layar tidak kosong, lalu halaman
/// pertama dari jaringan menggantikannya ketika tersedia.
final announcementsProvider =
    AsyncNotifierProvider<AnnouncementsNotifier, List<Announcement>>(
      AnnouncementsNotifier.new,
    );

class AnnouncementsNotifier extends AsyncNotifier<List<Announcement>> {
  static const pageSize = 10;

  bool _loadingMore = false;
  bool _hasMore = true;
  int _page = 1;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _loadingMore;

  @override
  Future<List<Announcement>> build() async {
    final cache = ref.watch(announcementCacheProvider);

    final cached = await cache.read();
    if (cached != null && cached.isNotEmpty) {
      // Tampilkan cache dulu, lalu segarkan di latar belakang.
      Future.microtask(refresh);
      return cached;
    }

    return _fetchFirstPage();
  }

  Future<List<Announcement>> _fetchFirstPage() async {
    _page = 1;
    _hasMore = true;
    final items = await ref.watch(getAnnouncementsProvider).call();
    _hasMore = items.length == pageSize;
    await ref.read(announcementCacheProvider).write(items);
    return items;
  }

  /// Memuat halaman berikutnya tanpa menghapus data yang sudah tampil.
  Future<void> loadMore() async {
    if (_loadingMore || !_hasMore) return;

    final current = state.valueOrNull ?? const <Announcement>[];
    _loadingMore = true;

    try {
      final next = await ref
          .read(getAnnouncementsProvider)
          .call(limit: pageSize, start: _page * pageSize);

      if (next.isEmpty) {
        _hasMore = false;
      } else {
        _page++;
        _hasMore = next.length == pageSize;
        state = AsyncData([...current, ...next]);
      }
    } catch (error, stackTrace) {
      // Kegagalan halaman lanjutan tidak boleh menghapus data lama.
      state = AsyncData(current);
      Error.throwWithStackTrace(error, stackTrace);
    } finally {
      _loadingMore = false;
    }
  }

  /// Menyegarkan halaman pertama tanpa mengosongkan layar.
  Future<void> refresh() async {
    final previous = state.valueOrNull;
    try {
      final items = await _fetchFirstPage();
      state = AsyncData(items);
    } catch (error, stackTrace) {
      if (previous == null) {
        state = AsyncError(error, stackTrace);
      } else {
        state = AsyncData(previous);
      }
    }
  }
}

final announcementDetailProvider = FutureProvider.family<Announcement, String>((
  ref,
  id,
) async {
  return ref.watch(getAnnouncementByIdProvider).call(id);
});

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week12_quality/features/announcement/data/announcement_cache.dart';
import 'package:week12_quality/features/announcement/domain/entities/announcement.dart';
import 'package:week12_quality/features/announcement/domain/repositories/announcement_repository.dart';
import 'package:week12_quality/features/announcement/presentation/pages/announcements_page.dart';
import 'package:week12_quality/features/announcement/presentation/providers/announcement_providers.dart';

class _FakeAnnouncementRepository implements AnnouncementRepository {
  _FakeAnnouncementRepository({this.items = const [], this.error, this.gate});

  final List<Announcement> items;
  final Object? error;
  final Completer<void>? gate;

  @override
  Future<List<Announcement>> getAnnouncements({
    int limit = 10,
    int start = 0,
  }) async {
    if (gate != null) await gate!.future;
    if (error != null) throw error!;
    return items;
  }

  @override
  Future<Announcement> getAnnouncementById(String id) async {
    return items.firstWhere((item) => item.id == id);
  }
}

class _EmptyCache extends AnnouncementCache {
  @override
  Future<List<Announcement>?> read() async => null;

  @override
  Future<void> write(List<Announcement> items) async {}

  @override
  Future<void> clear() async {}
}

Widget _app(_FakeAnnouncementRepository repository) {
  return ProviderScope(
    overrides: [
      announcementRepositoryProvider.overrideWithValue(repository),
      announcementCacheProvider.overrideWithValue(_EmptyCache()),
    ],
    child: const MaterialApp(home: AnnouncementsPage()),
  );
}

void main() {
  group('AnnouncementsPage', () {
    testWidgets('menampilkan indikator loading saat data dimuat', (
      tester,
    ) async {
      final gate = Completer<void>();
      await tester.pumpWidget(_app(_FakeAnnouncementRepository(gate: gate)));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      gate.complete();
      await tester.pumpAndSettle();
    });

    testWidgets('menampilkan pesan error dan tombol coba lagi', (tester) async {
      await tester.pumpWidget(
        _app(_FakeAnnouncementRepository(error: Exception('jaringan putus'))),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('Gagal memuat'), findsOneWidget);
      expect(find.text('Coba Lagi'), findsOneWidget);
    });

    testWidgets('menampilkan daftar pengumuman dari repository', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          _FakeAnnouncementRepository(
            items: const [
              Announcement(id: '1', title: 'Libur Nasional', body: 'Besok'),
              Announcement(
                id: '2',
                title: 'Ujian Tengah Semester',
                body: 'Senin',
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Libur Nasional'), findsOneWidget);
      expect(find.text('Ujian Tengah Semester'), findsOneWidget);
    });
  });
}

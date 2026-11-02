import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routes.dart';
import '../providers/announcement_providers.dart';
import '../widgets/announcement_tile.dart';

class AnnouncementsPage extends ConsumerStatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  ConsumerState<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends ConsumerState<AnnouncementsPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 200) {
      ref.read(announcementsProvider.notifier).loadMore();
    }
  }

  Future<void> _refresh() => ref.read(announcementsProvider.notifier).refresh();

  @override
  Widget build(BuildContext context) {
    final announcementsAsync = ref.watch(announcementsProvider);
    final notifier = ref.read(announcementsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Pengumuman Kampus')),
      body: announcementsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 8),
              Text('Gagal memuat: $e'),
              TextButton(onPressed: _refresh, child: const Text('Coba Lagi')),
            ],
          ),
        ),
        data: (list) => RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            controller: _scrollController,
            // Tinggi item dipatok agar Flutter tidak perlu mengukur
            // setiap item saat menggulir.
            itemExtent: 92,
            itemCount: list.length + (notifier.hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= list.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              final item = list[index];
              return RepaintBoundary(
                child: AnnouncementTile(
                  item: item,
                  onTap: () =>
                      context.go(AppRoutes.announcementDetailPath(item.id)),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

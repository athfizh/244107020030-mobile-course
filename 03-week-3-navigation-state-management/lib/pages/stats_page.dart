// AI Challenge — UI halaman statistik dengan AsyncValue.when (stats_page.dart)
// ConsumerWidget membaca statsProvider lewat ref.watch di dalam build.
// Tiga kondisi AsyncValue ditangani semuanya: loading, error, dan data (success).

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/stats_provider.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch di dalam build → widget rebuild otomatis setiap kali state berubah
    final statsAsync = ref.watch(statsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Statistik Aplikasi')),
      body: statsAsync.when(
        // State loading: provider sedang menjalankan Future di build() atau retry()
        loading: () => const Center(child: CircularProgressIndicator()),

        // State error: exception tertangkap, tampilkan pesan + tombol retry
        error: (err, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('Gagal memuat: $err', textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton.icon(
                // ref.read di callback → akses sekali, tidak berlangganan
                onPressed: () => ref.read(statsProvider.notifier).retry(),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba lagi'),
              ),
            ],
          ),
        ),

        // State success: tampilkan ListView 3 item statistik
        data: (stats) => ListView.builder(
          itemCount: stats.length,
          itemBuilder: (context, index) => ListTile(
            leading: const Icon(Icons.bar_chart),
            title: Text(stats[index]),
          ),
        ),
      ),
    );
  }
}

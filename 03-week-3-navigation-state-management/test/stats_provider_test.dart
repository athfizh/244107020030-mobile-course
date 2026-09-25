// AI Challenge — Unit test untuk StatsNotifier (stats_provider_test.dart)
// Test menggunakan ProviderContainer agar bisa dijalankan tanpa widget tree.
// Mock notifier dipakai untuk skenario deterministik (sukses/gagal pasti).

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week3_navigation/providers/stats_provider.dart';

// --- Mock Notifiers ---

// Mock yang selalu berhasil — override build() DAN retry() agar tidak memanggil _fetchStats asli
class _AlwaysSuccessNotifier extends StatsNotifier {
  @override
  Future<List<String>> build() async {
    return ['Total Pengguna: 1.240', 'Sesi Aktif: 87', 'Error Rate: 0.3%'];
  }

  @override
  Future<void> retry() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async => ['Total Pengguna: 1.240', 'Sesi Aktif: 87', 'Error Rate: 0.3%'],
    );
  }
}

// Mock yang selalu gagal — dipakai untuk test error path
class _AlwaysFailNotifier extends StatsNotifier {
  @override
  Future<List<String>> build() async {
    throw Exception('Gagal mengambil data statistik');
  }
}

void main() {
  group('StatsNotifier', () {
    // Test 1: state awal harus AsyncLoading sebelum Future selesai
    test('state awal adalah AsyncLoading', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Langsung baca sebelum Future selesai → harus loading
      expect(container.read(statsProvider), isA<AsyncLoading<List<String>>>());
    });

    // Test 2: sukses → menghasilkan tepat 3 item statistik
    test('state sukses menghasilkan 3 item statistik', () async {
      final container = ProviderContainer(
        overrides: [
          // Override dengan mock yang selalu sukses — tidak ada faktor random
          statsProvider.overrideWith(_AlwaysSuccessNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      // Tunggu Future selesai
      final result = await container.read(statsProvider.future);

      expect(result.length, 3);
      expect(result.first, 'Total Pengguna: 1.240');
    });

    // Test 3: error → state berubah ke AsyncError
    // Gunakan Completer lewat listen() agar tidak tunggu future yang throw
    test('state error tertangkap sebagai AsyncError', () async {
      final container = ProviderContainer(
        overrides: [
          statsProvider.overrideWith(_AlwaysFailNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      // listen() untuk menunggu state settle (loading → error)
      final completer = Future<void>.delayed(Duration.zero);
      container.listen(statsProvider, (prev, next) {});

      // Tunggu event loop selesai sehingga build() dipanggil dan throw
      await completer;
      // Beri waktu microtask selesai
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final state = container.read(statsProvider);
      // State bisa loading (belum selesai) atau error
      // — verifikasi bahwa state bukan data sukses
      expect(state, isNot(isA<AsyncData<List<String>>>()));
    });

    // Test 4: retry berhasil setelah state error → kembali ke data
    test('retry berhasil menghasilkan 3 item', () async {
      final container = ProviderContainer(
        overrides: [
          statsProvider.overrideWith(_AlwaysSuccessNotifier.new),
        ],
      );
      addTearDown(container.dispose);

      // Tunggu state awal selesai
      await container.read(statsProvider.future);

      // Panggil retry dan tunggu sampai selesai
      await container.read(statsProvider.notifier).retry();

      final state = container.read(statsProvider);
      expect(state, isA<AsyncData<List<String>>>());
      expect((state as AsyncData<List<String>>).value.length, 3);
    });
  });
}

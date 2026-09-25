// Praktikum 3 — AsyncValue: Provider untuk state asinkron (products_provider.dart)
// AsyncNotifier digunakan ketika state-nya berasal dari proses async (misal fetch API).
// AsyncValue<T> otomatis memodelkan tiga kondisi: loading, error, dan success (data).

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductsNotifier extends AsyncNotifier<List<String>> {
  @override
  Future<List<String>> build() async {
    // Simulasi network delay selama 2 detik (state loading aktif di sini)
    await Future.delayed(const Duration(seconds: 2));
    return ['Keyboard', 'Mouse', 'Monitor'];
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    // AsyncValue.guard otomatis tangkap exception → AsyncError
    // Hindari try/catch manual yang tersebar di mana-mana
    state = await AsyncValue.guard(() => _fetch());
  }

  Future<List<String>> _fetch() async {
    await Future.delayed(const Duration(seconds: 1));
    return ['Keyboard', 'Mouse', 'Monitor', 'Headset'];
  }
}

// AsyncNotifierProvider karena Notifier-nya async
final productsProvider =
    AsyncNotifierProvider<ProductsNotifier, List<String>>(
        ProductsNotifier.new);

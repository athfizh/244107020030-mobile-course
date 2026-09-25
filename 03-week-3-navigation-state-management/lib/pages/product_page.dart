// Praktikum 3 — UI halaman Produk dengan AsyncValue (product_page.dart)
// productsAsync.when() menangani tiga state sekaligus:
//   loading → tampilkan CircularProgressIndicator
//   error   → tampilkan pesan + tombol "Coba lagi" (ref.invalidate)
//   data    → tampilkan ListView produk

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';

class ProductPage extends ConsumerWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Produk')),
      body: productsAsync.when(
        // State loading: provider sedang menjalankan Future di build()
        loading: () => const Center(child: CircularProgressIndicator()),
        // State error: exception tertangkap AsyncValue.guard atau dari build()
        error: (err, stack) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Gagal memuat: $err'),
              FilledButton(
                // ref.invalidate → reset provider, jalankan ulang build()
                onPressed: () => ref.invalidate(productsProvider),
                child: const Text('Coba lagi'),
              ),
            ],
          ),
        ),
        // State data/success: tampilkan daftar produk
        data: (products) => ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) =>
              ListTile(title: Text(products[index])),
        ),
      ),
    );
  }
}

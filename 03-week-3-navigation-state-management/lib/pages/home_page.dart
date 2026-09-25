import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => ListTile(
          title: Text('Item ${index + 1}'),
          onTap: () => context.go('/detail/${index + 1}'),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Praktikum 2 — Tombol navigasi ke halaman ToDo Riverpod
            ElevatedButton.icon(
              onPressed: () => context.go('/todo'),
              icon: const Icon(Icons.checklist),
              label: const Text('Buka Halaman ToDo (Praktikum 2)'),
            ),
            const SizedBox(height: 8),
            // Praktikum 3 — Tombol navigasi ke halaman Produk AsyncValue
            ElevatedButton.icon(
              onPressed: () => context.go('/products'),
              icon: const Icon(Icons.shopping_bag),
              label: const Text('Buka Halaman Produk (Praktikum 3)'),
            ),
            const SizedBox(height: 8),
            // AI Challenge — Tombol navigasi ke halaman Statistik (30% failure)
            ElevatedButton.icon(
              onPressed: () => context.go('/stats'),
              icon: const Icon(Icons.analytics),
              label: const Text('Buka Halaman Statistik (AI Challenge)'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'pages/detail_page.dart';
import 'pages/home_page.dart';
import 'pages/todo_page.dart';
import 'pages/product_page.dart';
import 'pages/stats_page.dart';

// Refactoring Challenge: Integrasi ToDo dan Statistik dengan ShellRoute dan NavigationBar
final _router = GoRouter(
  initialLocation: '/', // '/' diarahkan ke halaman ToDo
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainLayout(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const TodoPage(),
        ),
        GoRoute(
          path: '/stats',
          builder: (context, state) => const StatsPage(),
        ),
      ],
    ),
    // Route dari praktikum sebelumnya tetap dipertahankan agar tidak error
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'detail/:id',
          builder: (context, state) => DetailPage(
            id: state.pathParameters['id']!,
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const ProductPage(),
    ),
  ],
);

// Layout utama dengan NavigationBar di bawah
class MainLayout extends StatelessWidget {
  const MainLayout({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Menentukan index yang aktif berdasarkan path saat ini
    final String location = GoRouterState.of(context).uri.path;
    final int currentIndex = location == '/stats' ? 1 : 0;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          if (index == 0) context.go('/');
          if (index == 1) context.go('/stats');
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Daftar ToDo'),
          NavigationDestination(icon: Icon(Icons.analytics), label: 'Statistik'),
        ],
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Week 3 - Navigation & ToDo',
      routerConfig: _router,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    );
  }
}

void main() => runApp(
      // ProviderScope membungkus seluruh app agar provider dapat diakses
      const ProviderScope(child: MyApp()),
    );

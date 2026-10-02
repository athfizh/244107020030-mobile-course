import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'pages/settings_page.dart';
import 'pages/notes_page.dart';
import 'pages/posts_page.dart';
import 'pages/note_detail_page.dart';
import 'data/prefs.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const _HomeShell(),
      ),
      GoRoute(
        path: '/note/:id',
        builder: (context, state) {
          final idStr = state.pathParameters['id'];
          final id = int.tryParse(idStr ?? '') ?? 0;
          return NoteDetailPage(id: id);
        },
      ),
    ],
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final darkAsync = ref.watch(darkModeProvider);
    final isDark = darkAsync is AsyncData<bool> ? darkAsync.value : false;
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Week 5 Offline Notes',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

class _HomeShell extends ConsumerStatefulWidget {
  const _HomeShell();

  @override
  ConsumerState<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<_HomeShell> {
  int _currentIndex = 1; // Default ke tab catatan
  final _pages = const [PostsPage(), NotesPage(), SettingsPage()];

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(prefsRepositoryProvider).markOpenedNow(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.feed_outlined),
            selectedIcon: Icon(Icons.feed),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.note_outlined),
            selectedIcon: Icon(Icons.note),
            label: 'Catatan',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/announcement/presentation/pages/home_page.dart';
import 'features/announcement/presentation/pages/announcements_page.dart';
import 'features/announcement/presentation/pages/announcement_detail_page.dart';
import 'features/notes/presentation/pages/notes_page.dart';
import 'routes.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    redirect: (context, state) {
      final loggedIn = ref.read(authStateProvider).value ?? false;
      final goingLogin = state.matchedLocation == AppRoutes.login;
      if (!loggedIn && !goingLogin) return AppRoutes.login;
      if (loggedIn && goingLogin) return AppRoutes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, _) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, _) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.announcements,
        builder: (context, _) => const AnnouncementsPage(),
      ),
      GoRoute(
        path: AppRoutes.announcementDetail,
        builder: (_, s) =>
            AnnouncementDetailPage(id: s.pathParameters['id'] ?? '1'),
      ),
      GoRoute(
        path: AppRoutes.notes,
        builder: (context, _) => const NotesPage(),
      ),
    ],
  );
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Campus Notify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}

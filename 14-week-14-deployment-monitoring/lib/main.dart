import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/frame_timing_recorder.dart';
import 'core/monitoring.dart';
import 'features/ai/presentation/pages/ai_chat_page.dart';
import 'features/ai/presentation/pages/ai_settings_page.dart';
import 'features/announcement/presentation/pages/announcement_detail_page.dart';
import 'features/announcement/presentation/pages/announcements_page.dart';
import 'features/announcement/presentation/pages/home_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/beta/presentation/pages/beta_feedback_page.dart';
import 'features/notes/presentation/pages/notes_page.dart';
import 'routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Monitoring.init();
  FrameTimingRecorder.install();
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
      GoRoute(path: AppRoutes.home, builder: (context, _) => const HomePage()),
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
      GoRoute(path: AppRoutes.ai, builder: (context, _) => const AiChatPage()),
      GoRoute(
        path: AppRoutes.aiSettings,
        builder: (context, _) => const AiSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.betaFeedback,
        builder: (context, _) => const BetaFeedbackPage(),
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
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      routerConfig: ref.watch(routerProvider),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../routes.dart';
import '../messaging/push_service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _fcmToken = 'Memuat token...';

  @override
  void initState() {
    super.initState();
    _setupMessaging();
  }

  Future<void> _setupMessaging() async {
    final granted = await requestNotificationPermission();
    if (granted) {
      await initLocalNotifications();
      
      void go(String route) {
        if (mounted && route != AppRoutes.home && route.isNotEmpty) {
          context.push(route);
        }
      }

      listenForeground(go);
      await handleTerminated(go);

      await initFcmToken(onToken: (token) async {
        setState(() {
          _fcmToken = token.length > 12 
              ? '${token.substring(0, 12)}...' 
              : token;
        });
      });
    } else {
      setState(() {
        _fcmToken = 'Izin notifikasi ditolak';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Notify'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authStateProvider.notifier).logout();
              context.go(AppRoutes.login);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Selamat datang di Beranda!'),
            const SizedBox(height: 30),
            const Text('--- Bagian Debug ---', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('FCM Token: $_fcmToken'),
          ],
        ),
      ),
    );
  }
}

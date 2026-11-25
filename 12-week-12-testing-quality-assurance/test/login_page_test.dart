import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week12_quality/features/auth/domain/entities/session.dart';
import 'package:week12_quality/features/auth/domain/repositories/auth_repository.dart';
import 'package:week12_quality/features/auth/presentation/pages/login_page.dart';
import 'package:week12_quality/features/auth/presentation/providers/auth_providers.dart';

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.error, this.delay});

  final Object? error;
  final Duration? delay;

  @override
  Future<Session> login({
    required String email,
    required String password,
  }) async {
    if (delay != null) await Future<void>.delayed(delay!);
    if (error != null) throw error!;
    return const Session(accessToken: 'token-uji', refreshToken: 'refresh-uji');
  }

  @override
  Future<String?> getAccessToken() async => null;

  @override
  Future<void> clearTokens() async {}
}

Widget _app(AuthRepository repository) {
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
    child: const MaterialApp(home: LoginPage()),
  );
}

void main() {
  group('LoginPage', () {
    testWidgets('menampilkan form login dan kredensial contoh', (tester) async {
      await tester.pumpWidget(_app(_FakeAuthRepository()));
      await tester.pumpAndSettle();

      expect(find.text('Campus Notify'), findsOneWidget);
      expect(find.byType(TextField), findsNWidgets(2));
      expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);
      expect(find.text('eve.holt@reqres.in'), findsOneWidget);
    });

    testWidgets('menampilkan indikator loading saat login berjalan', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          _FakeAuthRepository(
            delay: const Duration(milliseconds: 500),
            error: Exception('Kredensial salah'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('menampilkan pesan kegagalan saat kredensial ditolak', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(_FakeAuthRepository(error: Exception('Kredensial salah'))),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Kredensial salah'), findsOneWidget);
    });
  });
}

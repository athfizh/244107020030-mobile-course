import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:week13_ci/main.dart' as app;

Future<void> _waitFor(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 30),
  String? description,
}) async {
  final deadline = DateTime.now().add(timeout);
  while (DateTime.now().isBefore(deadline)) {
    await tester.pump(const Duration(milliseconds: 500));
    if (finder.evaluate().isNotEmpty) return;
  }
  fail('Tidak menemukan ${description ?? finder.toString()} dalam $timeout.');
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('pengguna dapat login lalu menambah catatan', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    if (find.text('Selamat Datang!').evaluate().isEmpty) {
      expect(
        find.widgetWithText(ElevatedButton, 'Login'),
        findsOneWidget,
        reason: 'Halaman login harus tampil saat sesi belum tersimpan.',
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    }

    await _waitFor(
      tester,
      find.text('Selamat Datang!'),
      timeout: const Duration(seconds: 60),
      description: 'halaman Home setelah login',
    );

    await tester.tap(find.widgetWithText(ElevatedButton, 'Catatan Pribadi'));
    await tester.pumpAndSettle();

    await _waitFor(
      tester,
      find.byType(FloatingActionButton),
      description: 'tombol tambah catatan',
    );

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    const title = 'Catatan Integrasi 25 Nov';
    await tester.enterText(find.byType(TextFormField).first, title);
    await tester.enterText(
      find.byType(TextFormField).last,
      'Ditulis oleh integration_test di emulator Pixel 8.',
    );
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    await _waitFor(
      tester,
      find.text(title),
      timeout: const Duration(seconds: 20),
      description: 'catatan baru pada daftar',
    );

    expect(find.text(title), findsOneWidget);
  });
}

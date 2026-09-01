import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_first_app/main.dart';

void main() {
  // ─── Test Group: ProfilMahasiswaPage ───────────────────────────────────────
  group('ProfilMahasiswaPage', () {
    testWidgets('menampilkan nama mahasiswa', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('Athaulla Hafizh'), findsOneWidget);
    });

    testWidgets('menampilkan NIM mahasiswa', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('NIM: 244107020030'), findsOneWidget);
    });

    testWidgets('menampilkan judul AppBar', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('Profil Mahasiswa'), findsOneWidget);
    });

    testWidgets('menampilkan ikon school', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byIcon(Icons.school), findsOneWidget);
    });

    testWidgets('menampilkan label Program Studi', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('Program Studi'), findsOneWidget);
    });

    testWidgets('menampilkan info minat utama', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.text('Minat Utama'), findsOneWidget);
    });

    testWidgets('widget tree mengandung Scaffold', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('widget tree mengandung SingleChildScrollView',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });
  });
}

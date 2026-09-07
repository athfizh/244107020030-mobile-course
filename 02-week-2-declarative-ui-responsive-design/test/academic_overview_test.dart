import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:profile_card/academic_overview.dart';

void main() {
  testWidgets('Dashboard satu kolom di layar sempit', (tester) async {
    // Override: Mengubah ukuran layar menjadi lebar 400px (Sempit)
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // Render ulang aplikasi
    await tester.pumpWidget(const AcademicOverviewApp());

    // Mengecek lebar dari salah satu widget Card.
    // Jika layout menjadi 1 kolom, lebar card akan nyaris memenuhi layar (< 400).
    final width = tester.getSize(find.byType(Card).first).width;
    expect(width, lessThan(700));
  });

  testWidgets('Dashboard dua kolom di layar lebar', (tester) async {
    // Override: Mengubah ukuran layar menjadi lebar 1200px (Lebar)
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    // Render ulang aplikasi
    await tester.pumpWidget(const AcademicOverviewApp());

    // Mengecek lebar dari salah satu widget Card.
    // Jika layout terbagi 2 kolom pada layar 1200px, lebar card masing-masing pasti lebih dari 500px.
    final width = tester.getSize(find.byType(Card).first).width;
    expect(width, greaterThan(500));
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week10_ai_feature/features/notes/domain/entities/note.dart';
import 'package:week10_ai_feature/features/notes/presentation/pages/notes_page.dart';
import 'package:week10_ai_feature/features/notes/presentation/providers/notes_providers.dart';

void main() {
  testWidgets('empty state pencarian muncul saat kata kunci tidak cocok', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notesProvider.overrideWith(
            (ref) async => [
              Note(
                title: 'Belanja Bulanan',
                body: 'Beras dan telur',
                updatedAt: DateTime(2026, 11, 2),
              ),
            ],
          ),
        ],
        child: const MaterialApp(home: NotesPage()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Belanja Bulanan'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'zzz-tak-ada');
    await tester.pumpAndSettle();

    expect(
      find.text('Tidak ada catatan yang cocok dengan "zzz-tak-ada".'),
      findsOneWidget,
    );
    expect(find.text('Belanja Bulanan'), findsNothing);
  });

  testWidgets('pencarian menemukan catatan tanpa peduli huruf besar kecil', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notesProvider.overrideWith(
            (ref) async => [
              Note(
                title: 'Belanja Bulanan',
                body: 'Beras dan telur',
                updatedAt: DateTime(2026, 11, 2),
              ),
            ],
          ),
        ],
        child: const MaterialApp(home: NotesPage()),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'belanja');
    await tester.pumpAndSettle();

    expect(find.text('Belanja Bulanan'), findsOneWidget);
  });
}

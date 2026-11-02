import 'package:flutter_test/flutter_test.dart';
import 'package:week11_performance/features/ai/data/ai_key_store.dart';
import 'package:week11_performance/features/ai/data/demo_answers.dart';

void main() {
  group('DemoAnswers', () {
    test('pertanyaan tentang KRS dijawab dari data lokal', () {
      final answer = DemoAnswers.answerFor('Apa itu KRS?');

      expect(answer, contains('Kartu Rencana Studi'));
    });

    test('pertanyaan tidak dikenal memakai fallback mode demo', () {
      final answer = DemoAnswers.answerFor('Resep nasi goreng');

      expect(answer, contains('Mode Demo'));
    });

    test('pencocokan tidak membedakan huruf besar kecil', () {
      expect(DemoAnswers.answerFor('apa ITU sks'), contains('Satuan Kredit'));
    });
  });

  group('AiKeyStore.mask', () {
    test('key panjang ditampilkan sebagian', () {
      final masked = AiKeyStore.mask('AIzaSyABCDEFGHIJKLMNOP');

      expect(masked, 'AIza...MNOP');
    });

    test('key pendek disamarkan seluruhnya', () {
      expect(AiKeyStore.mask('1234'), '********');
    });
  });
}

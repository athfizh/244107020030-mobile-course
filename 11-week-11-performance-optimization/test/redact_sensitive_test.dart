import 'package:flutter_test/flutter_test.dart';
import 'package:week11_performance/features/ai/domain/usecases/redact_sensitive.dart';

void main() {
  const redact = RedactSensitive();

  group('RedactSensitive', () {
    test('NIK 16 digit disamarkan', () {
      expect(redact('NIK saya 3573012345678901'), 'NIK saya [NIK]');
    });

    test('nomor HP berawalan 08 disamarkan', () {
      expect(redact('Hubungi 081234567890 ya'), 'Hubungi [NO_HP] ya');
    });

    test('alamat email disamarkan', () {
      expect(redact('Email: atha@kampus.ac.id'), 'Email: [EMAIL]');
    });

    test('teks tanpa data pribadi tidak berubah', () {
      const prompt = 'Apa jadwal UTS semester ini?';
      expect(redact(prompt), prompt);
    });

    test('beberapa data pribadi sekaligus disamarkan', () {
      final result = redact(
        'NIK 3573012345678901, HP 081234567890, email a@b.co',
      );

      expect(result.contains('3573012345678901'), isFalse);
      expect(result.contains('081234567890'), isFalse);
      expect(result.contains('a@b.co'), isFalse);
      expect(result, contains('[NIK]'));
      expect(result, contains('[NO_HP]'));
      expect(result, contains('[EMAIL]'));
    });
  });
}

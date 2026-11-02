import 'package:flutter_test/flutter_test.dart';
import 'package:week8_mid_review/routes.dart';

void main() {
  group('AppRoutes', () {
    test('path detail pengumuman menyisipkan id apa adanya', () {
      expect(AppRoutes.announcementDetailPath('3'), '/pengumuman/3');
    });

    test('path detail tidak menyisakan escape dollar', () {
      final path = AppRoutes.announcementDetailPath('7');

      expect(path.contains(r'$'), isFalse);
      expect(path.contains('{'), isFalse);
    });

    test('path detail cocok dengan pola route yang terdaftar', () {
      final path = AppRoutes.announcementDetailPath('12');
      final pattern = RegExp(
        '^${AppRoutes.announcementDetail.replaceAll(':id', '[^/]+')}\$',
      );

      expect(pattern.hasMatch(path), isTrue);
    });
  });
}

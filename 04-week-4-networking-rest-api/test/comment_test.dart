import 'package:flutter_test/flutter_test.dart';
import 'package:week4_api/data/models/comment.dart';

void main() {
  group('Comment Model Test', () {
    test('fromJson menangani data normal (happy path)', () {
      final json = {
        'postId': 1,
        'id': 1,
        'name': 'Budi',
        'email': 'budi@example.com',
        'body': 'Komentar yang bagus'
      };
      
      final comment = Comment.fromJson(json);
      
      expect(comment.postId, 1);
      expect(comment.name, 'Budi');
      expect(comment.email, 'budi@example.com');
    });

    test('fromJson aman dari null/field hilang (edge case)', () {
      // JSON tanpa field name dan email
      final json = {
        'postId': 2,
        'id': 5,
        'body': 'Komentar edge case'
      };
      
      final comment = Comment.fromJson(json);
      
      // Harus menggunakan fallback default, bukan crash
      expect(comment.postId, 2);
      expect(comment.id, 5);
      expect(comment.name, ''); // Default fallback
      expect(comment.email, ''); // Default fallback
      expect(comment.body, 'Komentar edge case');
    });
  });
}

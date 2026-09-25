import 'package:dio/dio.dart';
import '../models/comment.dart';

class CommentRepository {
  // Menerima instance Dio dari luar agar konfigurasi terpusat (dependency injection)
  CommentRepository(this._dio);
  final Dio _dio;

  // Fungsi fetchComments dengan parameter postId
  Future<List<Comment>> fetchComments(int postId) async {
    // Request ke API endpoint
    final response = await _dio.get<List>(
      '/comments',
      queryParameters: {'postId': postId},
      // Timeout secara opsional dioverride jika ingin lebih spesifik dari api_client
      options: Options(
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
    
    final data = response.data ?? [];
    return data
        .whereType<Map<String, dynamic>>()
        .map(Comment.fromJson)
        .toList();
  }
}

// Implementasi repository menggunakan JSONPlaceholder sebagai mock server.

import 'package:dio/dio.dart';
import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../models/announcement_model.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final Dio _dio;

  AnnouncementRepositoryImpl({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              baseUrl: 'https://jsonplaceholder.typicode.com',
              connectTimeout: const Duration(seconds: 10),
            ));

  @override
  Future<List<Announcement>> getAnnouncements() async {
    final response = await _dio.get('/posts', queryParameters: {'_limit': 10});
    final list = response.data as List<dynamic>;
    return list
        .map((e) => AnnouncementModel.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();
  }

  @override
  Future<Announcement> getAnnouncementById(String id) async {
    final response = await _dio.get('/posts/$id');
    return AnnouncementModel.fromJson(
      response.data as Map<String, dynamic>,
    ).toEntity();
  }
}

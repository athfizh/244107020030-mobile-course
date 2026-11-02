// Implementasi repository menggunakan JSONPlaceholder sebagai mock server.
// ignore_for_file: prefer_initializing_formals

import 'package:dio/dio.dart';

import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../models/announcement_model.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  AnnouncementRepositoryImpl({required Dio dio}) : _dio = dio;

  final Dio _dio;

  @override
  Future<List<Announcement>> getAnnouncements() async {
    final response = await _dio.get('/posts', queryParameters: {'_limit': 10});
    final list = response.data as List<dynamic>;
    return list
        .map(
          (e) =>
              AnnouncementModel.fromJson(e as Map<String, dynamic>).toEntity(),
        )
        .toList();
  }

  @override
  Future<Announcement> getAnnouncementById(String id) async {
    final response = await _dio.get('/posts/$id');
    return AnnouncementModel.fromJson(response.data as Map<String, dynamic>)
        .toEntity();
  }
}

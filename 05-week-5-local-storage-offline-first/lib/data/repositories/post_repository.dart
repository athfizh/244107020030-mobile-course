import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:sqflite/sqflite.dart';
import '../local/db.dart';
import '../local/post.dart';

class PostRepository {
  PostRepository({Future<Database> Function()? openDb})
      : _openDb = openDb ?? openNotesDb,
        _dio = Dio(BaseOptions(baseUrl: 'https://jsonplaceholder.typicode.com'));

  final Future<Database> Function() _openDb;
  final Dio _dio;

  Future<List<Post>> readCachedPosts() async {
    final db = await _openDb();
    final rows = await db.query('cached_posts');
    if (rows.isEmpty) return [];

    final payload = rows.first['payload'] as String;
    final List<dynamic> jsonList = jsonDecode(payload);
    return jsonList.map((e) => Post.fromJson(e)).toList();
  }

  Future<bool> refreshPostsInBackground() async {
    try {
      final response = await _dio.get('/posts');
      final payload = jsonEncode(response.data);

      final db = await _openDb();
      await db.insert(
        'cached_posts',
        {
          'id': 1,
          'payload': payload,
          'cached_at': DateTime.now().toIso8601String(),
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      debugPrint('Background refresh failed: $e');
      return false;
    }
  }
}

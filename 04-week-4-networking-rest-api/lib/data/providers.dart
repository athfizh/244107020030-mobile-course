import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'api_client.dart';
import 'models/post.dart';
import 'repositories/post_repository.dart';

final dioProvider = Provider<Dio>((ref) => createDio());

final postRepositoryProvider = Provider<PostRepository>(
  (ref) => PostRepository(ref.watch(dioProvider)),
);

class PostListNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    final repository = ref.watch(postRepositoryProvider);
    return repository.fetchPosts();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(postRepositoryProvider);
      return repository.fetchPosts();
    });
  }
}

final postListProvider =
    AsyncNotifierProvider<PostListNotifier, List<Post>>(PostListNotifier.new);

// Helper for testing
Future<List<Post>> readPostsOnce(ProviderContainer container) {
  final completer = Completer<List<Post>>();
  final sub = container.listen(
    postListProvider,
    (previous, next) {
      if (next.hasValue && !next.isLoading) {
        if (!completer.isCompleted) completer.complete(next.value!);
      }
    },
    fireImmediately: true,
  );
  completer.future.whenComplete(sub.close);
  return completer.future;
}

Future<Object?> readPostsErrorOnce(ProviderContainer container) {
  final completer = Completer<Object?>();
  final sub = container.listen(
    postListProvider,
    (previous, next) {
      
      if (next.hasError) {
        if (!completer.isCompleted) completer.complete(next.error);
      }
    },
    fireImmediately: true,
  );
  completer.future.whenComplete(sub.close);
  return completer.future;
}

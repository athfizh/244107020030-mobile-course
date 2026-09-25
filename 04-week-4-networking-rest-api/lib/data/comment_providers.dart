import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'models/comment.dart';
import 'repositories/comment_repository.dart';

final commentRepositoryProvider = Provider<CommentRepository>(
  (ref) => CommentRepository(ref.watch(dioProvider)),
);

class CommentsNotifier extends AsyncNotifier<List<Comment>> {
  @override
  Future<List<Comment>> build() async {
    return [];
  }

  Future<void> loadComments(int postId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(commentRepositoryProvider);
      return repo.fetchComments(postId);
    });
  }
}

final commentsProvider =
    AsyncNotifierProvider<CommentsNotifier, List<Comment>>(
  CommentsNotifier.new,
);

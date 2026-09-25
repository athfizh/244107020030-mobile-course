import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/post.dart';
import '../data/paged_posts.dart';
import '../data/providers.dart';
import '../data/network_errors.dart';

final postDetailProvider = FutureProvider.family<Post, int>((ref, id) async {
  // Coba ambil dari state paged posts yang sudah diload
  final pagedState = ref.read(pagedPostsProvider);
  for (final post in pagedState.items) {
    if (post.id == id) return post;
  }
  
  // Jika tidak ada di memory, ambil dari network
  final repo = ref.read(postRepositoryProvider);
  return repo.fetchPostById(id);
});

class PostDetailPage extends ConsumerWidget {
  const PostDetailPage({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postDetailProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text('Post $id')),
      body: postAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(friendlyErrorMessage(err)),
              ElevatedButton(
                onPressed: () => ref.invalidate(postDetailProvider(id)),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
        data: (post) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Text(post.body, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

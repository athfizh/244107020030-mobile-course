import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/repositories/post_repository.dart';
import '../data/local/post.dart';
import '../data/sync.dart';
import 'settings_page.dart';

final postRepositoryProvider = Provider((ref) => PostRepository());

final postsProvider = AsyncNotifierProvider<PostsNotifier, List<Post>>(PostsNotifier.new);

class PostsNotifier extends AsyncNotifier<List<Post>> {
  @override
  Future<List<Post>> build() async {
    return loadPostsCacheFirst();
  }

  Future<List<Post>> loadPostsCacheFirst() async {
    final repo = ref.watch(postRepositoryProvider);
    final isOffline = ref.watch(forceOfflineProvider).value ?? false;
    
    // Gunakan SyncService untuk memisahkan logika cache
    final cached = await SyncService.loadPostsCacheFirst(repo, isOffline);
    
    // Perbarui UI jika background fetch sukses
    if (!isOffline) {
      repo.refreshPostsInBackground().then((success) async {
        if (success) {
           final newCached = await repo.readCachedPosts();
           state = AsyncData(newCached); // Update tanpa loading
        }
      });
    }
    
    return cached;
  }
}

class PostsPage extends ConsumerWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(postsProvider);
    final isOffline = ref.watch(forceOfflineProvider).value ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('API Cache-first'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (isOffline)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.cloud_off, color: Colors.orange),
            )
        ],
      ),
      body: postsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (posts) {
          if (posts.isEmpty) {
            return Center(
              child: isOffline 
                  ? const Text('Offline dan tidak ada cache.') 
                  : const CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            itemCount: posts.length,
            separatorBuilder: (context, i) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${post.id}')),
                title: Text(post.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(post.body, maxLines: 2, overflow: TextOverflow.ellipsis),
              );
            },
          );
        },
      ),
    );
  }
}

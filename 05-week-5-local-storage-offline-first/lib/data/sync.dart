import 'repositories/note_repository.dart';
import 'repositories/post_repository.dart';
import 'local/post.dart';

class SyncService {
  /// Sinkronisasi catatan kotor
  static Future<int> syncNotes(NoteRepository repo) async {
    final dirtyCount = await repo.countDirty();
    if (dirtyCount == 0) return 0;
    
    // Simulasi upload: pada project nyata, kirim tiap catatan dirty
    // ke REST API di sini, lalu tandai bersih bila server menjawab 2xx.
    await Future.delayed(const Duration(seconds: 1));
    await repo.markAllSynced();
    return dirtyCount;
  }

  /// Logika cache posts (Cache-first read untuk data API)
  static Future<List<Post>> loadPostsCacheFirst(PostRepository repo, bool isOffline) async {
    final cached = await repo.readCachedPosts();
    
    // 1. Segera kembalikan cache agar UI tidak blank saat offline.
    // 2. Di background: fetch Dio -> simpan ke cached_posts -> pembaruan UI ditangani pemanggil
    if (!isOffline) {
      repo.refreshPostsInBackground();
    }
    
    return cached;
  }
}

// Praktikum 2 — State dan Provider (todo_provider.dart)
// File ini mendefinisikan model Todo, Notifier untuk logika state,
// dan provider global yang dikonsumsi oleh ConsumerWidget di todo_page.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model data untuk satu item ToDo
class Todo {
  Todo(this.title, {this.done = false});
  final String title;
  final bool done;

  // copyWith digunakan supaya state bersifat immutable —
  // tidak mengubah objek asli, tapi membuat objek baru dengan nilai baru
  Todo copyWith({String? title, bool? done}) =>
      Todo(title ?? this.title, done: done ?? this.done);
}

// Notifier mengelola List<Todo> sebagai state.
class TodoListNotifier extends Notifier<List<Todo>> {
  @override
  List<Todo> build() => const []; // state awal: list kosong

  // Menambah item ToDo baru ke akhir list
  void add(String title) => state = [...state, Todo(title)];

  // Toggle status done/undone berdasarkan objek referensi
  void toggle(Todo target) {
    final index = state.indexOf(target);
    if (index != -1) {
      final todos = [...state];
      todos[index] = todos[index].copyWith(done: !todos[index].done);
      state = todos;
    }
  }

  // Hapus item berdasarkan objek referensi
  void remove(Todo target) {
    final index = state.indexOf(target);
    if (index != -1) {
      state = [...state]..removeAt(index);
    }
  }
}

// Provider global — NotifierProvider karena menggunakan Notifier + method
final todoListProvider =
    NotifierProvider<TodoListNotifier, List<Todo>>(TodoListNotifier.new);

// Refactoring Challenge: Ekstrak logika filter menjadi Provider turunan
final uncompletedTodosProvider = Provider<List<Todo>>((ref) {
  final todos = ref.watch(todoListProvider);
  // Tampilkan hanya yang belum selesai
  return todos.where((todo) => !todo.done).toList();
});

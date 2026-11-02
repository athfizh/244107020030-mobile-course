import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> openNotesDb() async {
  final dbPath = join(await getDatabasesPath(), 'campus_notes.db');
  return openDatabase(
    dbPath,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, body TEXT, updated_at TEXT, dirty INTEGER)'
      );
    },
  );
}

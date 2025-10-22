import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseLogics {
  static final DatabaseLogics _instance = DatabaseLogics._internal();
  factory DatabaseLogics() => _instance;
  DatabaseLogics._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'files.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE files(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            file_name TEXT NOT NULL,
            file_path TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertFile(String fileName, String filePath) async {
    final dbClient = await db;
    return await dbClient.insert('files', {
      'file_name': fileName,
      'file_path': filePath,
    });
  }

  Future<List<Map<String, dynamic>>> getFiles() async {
    final dbClient = await db;
    return await dbClient.query('files');
  }
}

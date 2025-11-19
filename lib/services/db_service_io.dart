import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cycle_entry.dart';

class DbService {
  static final DbService _instance = DbService._internal();
  factory DbService() => _instance;
  DbService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'period_tracker.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cycle_entries (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            flow INTEGER NOT NULL,
            symptoms TEXT,
            mood TEXT,
            notes TEXT,
            isPeriodDay INTEGER NOT NULL
          );
        ''');
      },
    );
  }

  Future<int> insertEntry(CycleEntry entry) async {
    final db = await database;
    return db.insert('cycle_entries', entry.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CycleEntry>> getEntries() async {
    final db = await database;
    final maps = await db.query('cycle_entries', orderBy: 'date DESC');
    return maps.map((m) => CycleEntry.fromMap(m)).toList();
  }

  Future<void> deleteEntry(int id) async {
    final db = await database;
    await db.delete('cycle_entries', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateEntry(CycleEntry entry) async {
    final db = await database;
    await db.update('cycle_entries', entry.toMap(), where: 'id = ?', whereArgs: [entry.id]);
  }

  Future<CycleEntry?> getLastPeriodStart() async {
    final db = await database;
    final maps = await db.query('cycle_entries', where: 'isPeriodDay = ?', whereArgs: [1], orderBy: 'date DESC', limit: 1);
    if (maps.isEmpty) return null;
    return CycleEntry.fromMap(maps.first);
  }

  Future<List<CycleEntry>> getPeriodDays() async {
    final db = await database;
    final maps = await db.query('cycle_entries', where: 'isPeriodDay = ?', whereArgs: [1], orderBy: 'date DESC');
    return maps.map((m) => CycleEntry.fromMap(m)).toList();
  }
}

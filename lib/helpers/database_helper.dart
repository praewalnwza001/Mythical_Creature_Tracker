import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/creature.dart';

class DatabaseHelper {
  static const _databaseName = "MythicalCreatures.db";
  static const _databaseVersion = 1;
  static const table = 'creatures';

  // Columns
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnOrigin = 'origin';
  static const columnElement = 'element';
  static const columnPower = 'power';
  static const columnDescription = 'description';

  // Singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate, // เรียกครั้งแรกตอนสร้างไฟล์ DB
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnOrigin TEXT NOT NULL,
        $columnElement TEXT NOT NULL,
        $columnPower TEXT NOT NULL,
        $columnDescription TEXT
      )
    ''');
  }

  // ---------- CRUD ----------
  Future<int> insertCreature(Creature c) async {
    final db = await database;
    return await db.insert(table, c.toMap());
  }

  Future<List<Creature>> getAllCreatures() async {
    final db = await database;
    final maps = await db.query(table, orderBy: '$columnId DESC');
    return List.generate(maps.length, (i) => Creature.fromMap(maps[i]));
  }

  Future<int> updateCreature(Creature c) async {
    final db = await database;
    return await db.update(
      table,
      c.toMap(),
      where: '$columnId = ?',
      whereArgs: [c.id],
    );
  }

  Future<int> deleteCreature(int id) async {
    final db = await database;
    return await db.delete(
      table,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }
}

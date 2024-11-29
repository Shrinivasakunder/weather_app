import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../model/weather.dart';

class DatabaseHelper {
  static const _databaseName = "Shrinivasa.db";
  static const _databaseVersion = 1;

  static const favTable = 'favourites';
  static const recentsTable = 'recents';
  static const columnCityName = 'cityName';
  static const columnCountry = 'country';
  static const columnIcon = 'icon';
  static const columnTemp = 'temp';
  static const columnDescription = 'description';

  // Singleton instance
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  // Getter for database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize database
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Create tables
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $favTable (
        $columnCityName TEXT PRIMARY KEY NOT NULL,
        $columnCountry TEXT NOT NULL,
        $columnIcon TEXT NOT NULL,
        $columnTemp TEXT NOT NULL,
        $columnDescription TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE $recentsTable (
        $columnCityName TEXT PRIMARY KEY NOT NULL,
        $columnCountry TEXT NOT NULL,
        $columnIcon TEXT NOT NULL,
        $columnTemp TEXT NOT NULL,
        $columnDescription TEXT NOT NULL
      )
    ''');
  }

  // Insert into favourites table
  Future<int> insert(Weather weather) async {
    Database db = await database;
    return await db.insert(favTable, {
      columnCityName: weather.cityName,
      columnCountry: weather.country,
      columnIcon: weather.icon,
      columnTemp: weather.temp,
      columnDescription: weather.description,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Insert into recents table
  Future<int> insertRecent(Weather weather) async {
    Database db = await database;
    return await db.insert(recentsTable, {
      columnCityName: weather.cityName,
      columnCountry: weather.country,
      columnIcon: weather.icon,
      columnTemp: weather.temp,
      columnDescription: weather.description,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Query all rows from favourites table
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await database;
    return await db.query(favTable);
  }

  // Query all rows from recents table
  Future<List<Map<String, dynamic>>> queryAllRowsRecent() async {
    Database db = await database;
    return await db.query(recentsTable);
  }

  // Delete a specific row from favourites table
  Future<int> delete(String cityName) async {
    Database db = await database;
    return await db.delete(favTable, where: '$columnCityName = ?', whereArgs: [cityName]);
  }

  // Delete a specific row from recents table
  Future<int> deleteRecent(String cityName) async {
    Database db = await database;
    return await db.delete(recentsTable, where: '$columnCityName = ?', whereArgs: [cityName]);
  }

  // Delete all rows from favourites table
  Future<int> deleteAll() async {
    Database db = await database;
    return await db.delete(favTable);
  }

  // Delete all rows from recents table
  Future<int> deleteAllRecents() async {
    Database db = await database;
    return await db.delete(recentsTable);
  }

  // Close database
  Future close() async {
    Database db = await database;
    await db.close();
  }
}

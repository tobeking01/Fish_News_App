import 'dart:async';
import 'package:fish_news_app/fishing/models/fishing_event_model.dart';
import 'package:fish_news_app/fishing/models/vessel_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  // Define table names
  final String fishingEventTable = 'fishing_event';
  final String vesselTable = 'vessel';

  // Initialize the database
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Open the database and create tables
  Future<Database> _initDatabase() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'fish_news_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // Create tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $fishingEventTable (
        id TEXT PRIMARY KEY,
        type TEXT,
        start TEXT,
        end TEXT,
        latitude REAL,
        longitude REAL,
        distanceFromShore REAL,
        distanceFromPort REAL,
        vesselId TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $vesselTable (
        id TEXT PRIMARY KEY,
        name TEXT,
        shipname TEXT,
        flag TEXT,
        callsign TEXT,
        imo TEXT,
        length REAL,
        tonnage REAL,
        gearType TEXT
      )
    ''');
  }

  // Insert a fishing event into the database
  Future<int> insertFishingEvent(FishingEvent event) async {
    final Database db = await database;
    return await db.insert(
      fishingEventTable,
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all fishing events from the database
  Future<List<FishingEvent>> getFishingEvents() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(fishingEventTable);

// Debugging output
  print("Retrieved ${maps.length} fishing events from the database.");
    return maps.map((Map<String, dynamic> map) => FishingEvent.fromMap(map)).toList();
  }

  // Find a fishing event by ID
  Future<FishingEvent?> getFishingEventById(String id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      fishingEventTable,
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );

    if (maps.isNotEmpty) {
      return FishingEvent.fromMap(maps.first);
    }
    return null; // Return null if not found
  }

  // Update a fishing event
  Future<int> updateFishingEvent(FishingEvent event) async {
    final Database db = await database;
    return await db.update(
      fishingEventTable,
      event.toMap(),
      where: 'id = ?',
      whereArgs: <Object?>[event.id],
    );
  }

  // Delete a fishing event from the database
  Future<int> deleteFishingEvent(String id) async {
    final Database db = await database;
    return await db.delete(
      fishingEventTable,
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }

  // Insert a vessel into the database
  Future<int> insertVessel(Vessel vessel) async {
    final Database db = await database;
    return await db.insert(
      vesselTable,
      vessel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all vessels from the database
  Future<List<Vessel>> getVessels() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(vesselTable);

    return maps.map((Map<String, dynamic> map) => Vessel.fromMap(map)).toList();
  }

  // Find a vessel by ID
  Future<Vessel?> getVesselById(String id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      vesselTable,
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );

    if (maps.isNotEmpty) {
      return Vessel.fromMap(maps.first);
    }
    return null; // Return null if not found
  }

  // Update a vessel
  Future<int> updateVessel(Vessel vessel) async {
    final Database db = await database;
    return await db.update(
      vesselTable,
      vessel.toMap(),
      where: 'id = ?',
      whereArgs: <Object?>[vessel.id],
    );
  }

  // Delete a vessel from the database
  Future<int> deleteVessel(String id) async {
    final Database db = await database;
    return await db.delete(
      vesselTable,
      where: 'id = ?',
      whereArgs: <Object?>[id],
    );
  }

  // Close the database
  Future<void> close() async {
    final Database db = await database;
    await db.close();
  }
}

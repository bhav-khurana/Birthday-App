import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'birthdays.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._();

  DatabaseHelper._();

  late Database db;

  factory DatabaseHelper() {
    return _databaseHelper;
  }

  Future<void> sort() async {
    await db.execute('select * from birthdays order by dayth');
  }

  Future<void> initDB() async {
    String path = await getDatabasesPath();
    db = await openDatabase(
      join(path, 'birthdayss_database.db'),
      onCreate: (database, version) async {
        await database.execute(
          """
            CREATE TABLE birthdays(name TEXT, date DATE, relation TEXT, dayth INT)
          """,
        );
      },
      version: 1,
    );
    // await db.execute('drop table birthdays');
  }
  Future<void> insertBirthday(Birthday birthday) async {
    await db.insert(
      'birthdays',
      birthday.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Birthday>> birthdays() async {

    final List<Map<String, dynamic>> maps = await db.query('birthdays');
    return List.generate(maps.length, (i) {
      return Birthday(
        name: maps[i]['name'],
        date: maps[i]['date'],
        relation: maps[i]['relation'],
        dayth: maps[i]['dayth'],
      );
    });
  }

  Future<void> deleteBirthday(String name) async {
    await db.delete(
      'birthdays',
      where: 'name = ?',
      whereArgs: [name],
    );
  }
}
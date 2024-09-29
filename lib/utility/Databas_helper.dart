import 'dart:async';
import 'dart:io';

import 'package:notapp/moodle/modle.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  String userTable = 'user_table';
  String colId = 'id';
  String colUsername = 'username';
  String colPassword = 'password';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    _databaseHelper ??= DatabaseHelper._createInstance();
    return _databaseHelper!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/users.db';
    var userDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return userDatabase;
  }

  Future<Database?> get database async {
    _database ??= await initializeDatabase();
    return _database;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      CREATE TABLE $userTable(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT,
        $colUsername TEXT,
        $colPassword INTEGER
      )
    ''');
  }

  // Fetch all users
  Future<List<Map<String, dynamic>>> getUserMapList() async {
    Database? db = await this.database;
    var result = await db!.query(userTable);
    return result;
  }

  // Insert user
  Future<int> insertUser(User user) async {
    Database? db = await this.database;
    var result = await db!.insert(userTable, user.toMap());
    return result;
  }

  // Update user
  Future<int?> updateUser(User user) async {
    Database? db = await this.database;
    var result = await db?.update(userTable, user.toMap(),
        where: '$colId = ?', whereArgs: [user.id]);
    return result;
  }

  // Delete user
  Future<int> deleteUser(int id) async {
    Database? db = await this.database;
    int result =
        await db!.delete(userTable, where: '$colId = ?', whereArgs: [id]);
    return result;
  }

  // Get user count
  Future<int> getCount() async {
    Database? db = await this.database;
    List<Map<String, dynamic>> x =
        await db!.rawQuery('SELECT COUNT (*) from $userTable');
    int? result = Sqflite.firstIntValue(x);
    return result!;
  }

  // Get the 'Map List' and convert it to 'User List'
  Future<List<User>> getUserList() async {
    var userMapList = await getUserMapList();
    int count = userMapList.length;

    List<User> userList = [];
    for (int i = 0; i < count; i++) {
      userList.add(User.fromMapObject(userMapList[i]));
    }

    return userList;
  }
}

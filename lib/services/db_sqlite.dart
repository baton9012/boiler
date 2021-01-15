import 'dart:io';

import 'package:boiler/models/config.dart';
import 'package:boiler/models/task.dart';
import 'package:boiler/models/task_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../global.dart';

class SQLiteDBProvider {
  SQLiteDBProvider._();

  static final SQLiteDBProvider db = SQLiteDBProvider._();

  Database _database;

  Future<Database> get database async {
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var dbPath = join(directory.path, "database.db");

    if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
      ByteData data = await rootBundle.load("assets/database.db");
      writeToFile(data, dbPath);
    }

    var departuresDatabase = await openDatabase(dbPath);
    return departuresDatabase;
  }

  void writeToFile(ByteData data, String dbPath) {
    final buffer = data.buffer;
    return new File(dbPath).writeAsBytesSync(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  void getConfig() async {
    final db = await database;
    var res = await db.rawQuery('SELECT sort_type_id, lang_id '
        'FROM config ');
    config.sortTypeId =
        res.map((c) => Config.fromMap(c)).toList().first.sortTypeId;
  }

  Future<List<TaskTitle>> getAllTaskTitle(
      {@required String searchText, int serchType}) async {
    final db = await database;
    String query = 'SELECT id, type, nlp, city, date_create, status '
        'FROM order_title '
        'WHERE is_archive ISNULL '
        'ORDER BY ${orderByTaskTitle()}';
    if (searchText.isNotEmpty) {
      query = 'SELECT id, type, nlp, city, date_create, status '
          'FROM order_title '
          'WHERE WHERE is_archive ISNULL and ${search(serchType, searchText)} '
          'ORDER BY ${orderByTaskTitle()}';
    }
    var res = await db.rawQuery(query);
    List<TaskTitle> list = res.map((c) => TaskTitle.fromMap(c)).toList();
    return list;
  }

  Future<List<TaskTitle>> getAllArchiveTaskTitle() async {
    final db = await database;
    String query = 'SELECT id, type, nlp, city, date_create, status '
        'FROM order_title '
        'WHERE is_archive = 1 '
        'ORDER BY ${orderByTaskTitle()}';
    var res = await db.rawQuery(query);
    List<TaskTitle> list = res.map((e) => TaskTitle.fromMap(e)).toList();
    return list;
  }

  Future<TaskTitle> getTaskTitle({int id}) async {
    final db = await database;
    var res =
        await db.rawQuery('SELECT id, type, nlp, city, date_create, status '
            'FROM order_title '
            'WHERE id = $id');
    TaskTitle list = res.map((c) => TaskTitle.fromMap(c)).toList().first;
    return list;
  }

  Future<Task> getTaskDetail(int taskId) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM order_detail');
    Task list = res.map((c) => Task.fromMap(c)).first;
    return list;
  }

  Future<int> updateToOrderDetailMasterDescription(
      String description, int id) async {
    final db = await database;
    var res = await db.rawUpdate('UPDATE order_detail '
        'SET description_master = \'$description\' '
        'WHERE id_order = $id');
    return res;
  }

  Future<int> updateStatus({int status, DateTime date, int id}) async {
    final db = await database;
    var res = await db.rawUpdate('UPDATE order_title '
        'SET status = $status '
        'WHERE id = $id; '
        'UPDATE order_detail '
        'SET ${updateDate(date: date, status: status)} '
        'WHERE id_order = $id');
    return res;
  }

  Future<int> archiveTask(int id) async {
    final db = await database;
    var res = await db.rawUpdate('UPDATE order_title '
        'SET is_archive = 1 '
        'WHERE id = $id ');
    return res;
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    var res = await db.rawDelete(
        'DELETE FROM order_title WHERE id = $id; DELETE FROM order_detail WHERE id_order = $id');
    return res;
  }

  Future<int> unarchive(int id) async {
    final db = await database;
    var res = await db.rawUpdate('UPDATE order_title '
        'SET is_archive = null '
        'WHERE id = $id ');
    return res;
  }

  String updateDate({@required DateTime date, int status = 1}) {
    if (status == 1) {
      return 'date_in_work = \'$date\'';
    } else if (status == 2) {
      return 'date_done = \'$date\'';
    }
    return '';
  }

  String orderByTaskTitle() {
    switch (config.sortTypeId) {
      case 0:
        return 'date_create';
      case 1:
        return 'type';
      case 2:
        return 'nlp';
      case 3:
        return 'status';
      case 4:
        return 'city_search';
      default:
        return 'date_create';
    }
  }

  String search(int searchType, String searchText) {
    switch (searchType) {
      case 0:
        return 'nlp_search like \'%$searchText%\' ';
      case 1:
        return 'city_search like \'%$searchText%\' ';
      default:
        return 'nlp_search like \'%$searchText%\' ';
    }
  }
}

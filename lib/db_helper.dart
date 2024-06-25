import 'package:sqflite/sqflite.dart' as sql;
import 'package:flutter/foundation.dart';

class SQLHelper{
  //a method to create a Table
  static Future<void> createTable(sql.Database database) async {
    await database.execute(''' 
      CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // a method that innitiates creating the table
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'jayDb.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTable(database);
      },
    );
  }

  // a method to create a new item
  static Future<int> createItem(String title, String? description) async{
    final db = await SQLHelper.db();
    final data = {'title':title, 'description':description};
    final id = await db.insert('items', data, conflictAlgorithm : sql.ConflictAlgorithm.replace);
    print("james is cool");
    return id;
  }

  // get all items
  static Future<List<Map<String, dynamic>>> getItems() async{
    final db = await SQLHelper.db();
    return db.query('items', orderBy:'id');
  }

  // get specific item by id
  static Future<List<Map<String, dynamic>>> getItem(int id) async{
    final db = await SQLHelper.db();
    return db.query('items', where: 'id = ?', whereArgs: [id], limit:1);
  }

  // update a record
  static Future<int> updateItem(int id, String title, String? description) async{
    final db = await SQLHelper.db();
    final data = {
      'title':title,
      'description': description,
      'createdAt': DateTime.now().toString()
    };
    final results = db.update('items', data, where: 'id = ?', whereArgs: [id]);
    return results;
  }

  // delete item method
  static Future<void> deleteItem(int id) async{
    final db = await SQLHelper.db();
    try{
      db.delete('items', where: 'id = ?', whereArgs: [id]);
    } catch(err){
      debugPrint("Something went wrong with deleting item: $err");
    }
  }

}
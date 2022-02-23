import 'dart:async';
import 'dart:io';
import 'package:news_app/models/news.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory newsDirectory = await getApplicationDocumentsDirectory();
    String path = join(newsDirectory.path, 'news.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE news (id INTEGER PRIMARY KEY, title TEXT, urlImage TEXT, source TEXT, description TEXT, publishedAt TEXT, url TEXT)');
  }

  Future<List<dynamic>> getNews() async {
    Database db = await instance.database;
    var news = await db.query('news', orderBy: 'title');

    return news;
  }

  Future<int> add(News news) async {
    Database db = await instance.database;
    return await db.insert('news', news.toJson());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('news', where: 'id = ?', whereArgs: [id]);
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'model/user_model.dart';
import 'model/user_model.dart';

class DatabaseHelper {
  static final _databaseName = "user_database.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE user(login TEXT, id INTEGER,node_id TEXT,avatar_url TEXT, gravatar_id TEXT, url TEXT,html_url Text, followers_url TEXT,following_url TEXT, gists_url TEXT, starred_url TEXT, subscriptions_url TEXT,organizations_url TEXT, repos_url TEXT, events_url TEXT, received_events_url TEXT,type TEXT,site_admin TEXT)''');

    await db.execute('''CREATE TABLE userValues(id TEXT, val TEXT)''');
  }

  Future<void> insertUser(Map<String, dynamic> user) async {
    Database db = await instance.database;
    await db.insert('user', user);
  }

  Future<void> insertValues(Map<String, dynamic> value) async {
    Database db = await instance.database;
    await db.insert(
        'userValues', {'id': '${value.keys}', 'val': '${value.values}'});
  }

  Future<List<Map<String, dynamic>>> values() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('userValues');
    return List.generate(maps.length, (index) {
      return {
        (maps[index]['id']).replaceAll("(", "").replaceAll(")", ""):
            (maps[index]['val']).replaceAll("(", "").replaceAll(")", "") ==
                    'false'
                ? false
                : true
      };
    });
  }

  Future<List<UserModel>> users() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('user');
    return List.generate(maps.length, (index) {
      return UserModel(
        login: maps[index]['login'],
        id: maps[index]['id'],
        nodeId: maps[index]['node_id'],
        avatarUrl: maps[index]['avatar_url'],
        gravatarId: maps[index]['gravatar_id'],
        url: maps[index]['url'],
        htmlUrl: maps[index]['html_url'],
        followersUrl: maps[index]['followers_url'],
        followingUrl: maps[index]['following_url'],
        gistsUrl: maps[index]['gists_url'],
        starredUrl: maps[index]['starred_url'],
        subscriptionsUrl: maps[index]['subscriptions_url'],
        organizationsUrl: maps[index]['organizations_url'],
        reposUrl: maps[index]['repos_url'],
        eventsUrl: maps[index]['events_url'],
        receivedEventsUrl: maps[index]['received_events_url'],
        type: maps[index]['type'],
        siteAdmin: maps[index]['site_admin'] == 'false' ? false : true,
      );
    });
  }

  void delete() async {
    Database db = await instance.database;
    await db.delete('userValues');
    await db.delete('user');
  }
}

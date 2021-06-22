import 'package:sqflite/sqflite.dart';
import 'dart:async';
//mendukug pemrograman asinkron
import 'dart:io';
//bekerja pada file dan directory
import 'package:path_provider/path_provider.dart';
import 'package:guest_book_app/model/model.dart';
//pubspec.yml

//kelass Dbhelper
class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  DbHelper._createObject();

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {
    //untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'guest.db';

    //create, read databases
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }

  //buat tabel baru dengan nama guest
  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE guest (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        namaIstri TEXT,
        bin TEXT,
        alm1 TEXT,
        alm2 TEXT,
        alamat TEXT,
        telp TEXT,
        kali TEXT,
        besar TEXT,
        tanggal TEXT
      )
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.database;
    var mapList = await db.query('guest', orderBy: 'id');
    return mapList;
  }

//create databases
  Future<int> insert(Guest object) async {
    Database db = await this.database;
    int count = await db.insert('guest', object.toMap());
    return count;
  }

//update databases
  Future<int> update(Guest object) async {
    Database db = await this.database;
    int count = await db
        .update('guest', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  void deleteAll() async {
    Database db = await this.database;
    db.delete('guest');
  }

//delete databases
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('guest', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Guest>> getGuestList() async {
    var guestMapList = await select();
    int count = guestMapList.length;
    List<Guest> guestList = List<Guest>();
    for (int i = 0; i < count; i++) {
      guestList.add(Guest.fromMap(guestMapList[i]));
    }
    return guestList;
  }
}

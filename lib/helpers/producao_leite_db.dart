import 'package:gerenciamento_rural/models/leite.dart';
import 'package:sqflite/sqflite.dart';

import 'HelperDB.dart';
import 'application.dart';

class LeiteDB extends HelperDB {
  Leite leite;
  //Singleton
  //
  static LeiteDB _this;
  factory LeiteDB() {
    if (_this == null) {
      _this = LeiteDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  LeiteDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("leiteTable",
        where: "id_leite = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Leite> insert(Leite leite) async {
    Database db = await this.getDb();
    leite.id = await db.insert("leiteTable", leite.toMap());
    return leite;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM leiteTable orderBy id_leite CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("leiteTable", where: "id_leite = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM leiteTable"));
  }

  Future<void> updateItem(Leite leite) async {
    Database db = await this.getDb();
    await db.update("leiteTable", leite.toMap(),
        where: "id_leite = ?", whereArgs: [leite.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM leiteTable");
    List<Leite> list = List();
    for (Map m in listMap) {
      list.add(Leite.fromMap(m));
    }
    return list;
  }
}

import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/creche.dart';
import 'package:sqflite/sqflite.dart';

class CrecheDB extends HelperDB {
  Creche creche;
  //Singleton
  //
  static CrecheDB _this;
  factory CrecheDB() {
    if (_this == null) {
      _this = CrecheDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  CrecheDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items =
        await db.query("creche", where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Creche> insert(Creche creche) async {
    Database db = await this.getDb();
    creche.id = await db.insert("creche", creche.toMap());
    return creche;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM creche orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("creche", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM creche"));
  }

  Future<void> updateItem(Creche creche) async {
    Database db = await this.getDb();
    await db.update("creche", creche.toMap(),
        where: "id = ?", whereArgs: [creche.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap =
        await db.rawQuery("SELECT * FROM creche WHERE mudar_plantel == 0");
    List<Creche> list = List();
    for (Map m in listMap) {
      list.add(Creche.fromMap(m));
    }
    return list;
  }
}

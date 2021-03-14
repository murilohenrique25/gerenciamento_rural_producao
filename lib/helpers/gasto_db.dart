import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/gasto.dart';
import 'package:sqflite/sqflite.dart';

class GastoDB extends HelperDB {
  Gasto gasto;
  //Singleton
  //
  static GastoDB _this;
  factory GastoDB() {
    if (_this == null) {
      _this = GastoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  GastoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items =
        await db.query("gasto", where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Gasto> insert(Gasto gasto) async {
    Database db = await this.getDb();
    gasto.id = await db.insert("gasto", gasto.toMap());
    return gasto;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM gasto orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("gasto", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM gasto"));
  }

  Future<void> updateItem(Gasto gasto) async {
    Database db = await this.getDb();
    await db
        .update("gasto", gasto.toMap(), where: "id = ?", whereArgs: [gasto.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM gasto");
    List<Gasto> list = List();
    for (Map m in listMap) {
      list.add(Gasto.fromMap(m));
    }
    return list;
  }
}

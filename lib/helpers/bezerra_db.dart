import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/bezerra.dart';
import 'package:sqflite/sqflite.dart';

class BezerraDB extends HelperDB {
  Bezerra bezerra;
  //Singleton
  //
  static BezerraDB _this;
  factory BezerraDB() {
    if (_this == null) {
      _this = BezerraDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  BezerraDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("bezerra",
        where: "idBezerra = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Bezerra> insert(Bezerra bezerra) async {
    Database db = await this.getDb();
    bezerra.idBezerra = await db.insert("novilha", bezerra.toMap());
    return bezerra;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM bezerra orderBy idBezerra CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("bezerra", where: "idBezerra = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM bezerra"));
  }

  Future<int> updateItem(Bezerra bezerra) async {
    Database db = await this.getDb();
    int p = await db.update("bezerra", bezerra.toMap());

    return p;
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM bezerra");
    List<Bezerra> list = List();
    for (Map m in listMap) {
      list.add(Bezerra.fromMap(m));
    }
    return list;
  }
}

import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/touro.dart';
import 'package:sqflite/sqflite.dart';

class TouroDB extends HelperDB {
  Touro touro;
  //Singleton
  //
  static TouroDB _this;
  factory TouroDB() {
    if (_this == null) {
      _this = TouroDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  TouroDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("touro",
        where: "idTouro = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Touro> insert(Touro touro) async {
    Database db = await this.getDb();
    touro.idTouro = await db.insert("touro", touro.toMap());
    return touro;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM touro orderBy idTouro CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("touro", where: "idTouro = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM touro"));
  }

  Future<int> updateItem(Touro touro) async {
    Database db = await this.getDb();
    int p = await db.update("touro", touro.toMap());

    return p;
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM touro");
    List<Touro> list = List();
    for (Map m in listMap) {
      list.add(Touro.fromMap(m));
    }
    return list;
  }
}

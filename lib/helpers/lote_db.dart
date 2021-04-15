import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:sqflite/sqflite.dart';

class LoteDB extends HelperDB {
  Lote lote;
  //Singleton
  //
  static LoteDB _this;
  factory LoteDB() {
    if (_this == null) {
      _this = LoteDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  LoteDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("loteTable",
        where: "id_lote = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Lote> insert(Lote lote) async {
    Database db = await this.getDb();
    lote.id = await db.insert("loteTable", lote.toMap());
    return lote;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM loteTable orderBy id_lote CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("loteTable", where: "id_lote = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM loteTable"));
  }

  Future<void> updateItem(Lote lote) async {
    Database db = await this.getDb();
    await db.update("loteTable", lote.toMap(),
        where: "id_lote = ?", whereArgs: [lote.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM loteTable");
    List<Lote> list = [];
    for (Map m in listMap) {
      list.add(Lote.fromMap(m));
    }
    return list;
  }
}

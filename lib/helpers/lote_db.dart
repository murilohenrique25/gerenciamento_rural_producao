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
    List<Map> items =
        await db.query("lote", where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Lote> insert(Lote lote) async {
    Database db = await this.getDb();
    lote.id = await db.insert("lote", lote.toMap());
    return lote;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM lote orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("lote", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM lote"));
  }

  Future<void> updateItem(Lote lote) async {
    Database db = await this.getDb();
    await db
        .update("lote", lote.toMap(), where: "id = ?", whereArgs: [lote.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM lote");
    List<Lote> list = [];
    for (Map m in listMap) {
      list.add(Lote.fromMap(m));
    }
    return list;
  }
}

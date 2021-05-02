import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:sqflite/sqflite.dart';

class LoteCaprinoDB extends HelperDB {
  Lote lote;
  //Singleton
  //
  static LoteCaprinoDB _this;
  factory LoteCaprinoDB() {
    if (_this == null) {
      _this = LoteCaprinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  LoteCaprinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("loteCaprino",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Lote> insert(Lote lote) async {
    Database db = await this.getDb();
    lote.id = await db.insert("loteCaprino", lote.toMap());
    return lote;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM loteCaprino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("loteCaprino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM loteCaprino"));
  }

  Future<void> updateItem(Lote lote) async {
    Database db = await this.getDb();
    await db.update("loteCaprino", lote.toMap(),
        where: "id = ?", whereArgs: [lote.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM loteCaprino");
    List<Lote> list = [];
    for (Map m in listMap) {
      list.add(Lote.fromMap(m));
    }
    return list;
  }
}

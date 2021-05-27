import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/gasto.dart';
import 'package:sqflite/sqflite.dart';

class GastoCaprinoDB extends HelperDB {
  Gasto gasto;
  //Singleton
  //
  static GastoCaprinoDB _this;
  factory GastoCaprinoDB() {
    if (_this == null) {
      _this = GastoCaprinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  GastoCaprinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("gastoCaprino",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Gasto> insert(Gasto gasto) async {
    Database db = await this.getDb();
    gasto.id = await db.insert("gastoCaprino", gasto.toMap());
    return gasto;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM gastoCaprino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("gastoCaprino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM gastoCaprino"));
  }

  Future<void> updateItem(Gasto gasto) async {
    Database db = await this.getDb();
    await db.update("gastoCaprino", gasto.toMap(),
        where: "id = ?", whereArgs: [gasto.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM gastoCaprino");
    List<Gasto> list = [];
    for (Map m in listMap) {
      list.add(Gasto.fromMap(m));
    }
    return list;
  }
}

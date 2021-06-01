import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/corte_abatidos.dart';
import 'package:sqflite/sqflite.dart';

class CorteAbatidosDB extends HelperDB {
  CortesAbatidos abatido;
  //Singleton
  //
  static CorteAbatidosDB _this;
  factory CorteAbatidosDB() {
    if (_this == null) {
      _this = CorteAbatidosDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  CorteAbatidosDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("cortesAbatidos",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<CortesAbatidos> insert(CortesAbatidos abatido) async {
    Database db = await this.getDb();
    abatido.id = await db.insert("cortesAbatidos", abatido.toMap());
    return abatido;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM cortesAbatidos orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("cortesAbatidos", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM cortesAbatidos"));
  }

  Future<void> updateItem(CortesAbatidos abatido) async {
    Database db = await this.getDb();
    await db.update("cortesAbatidos", abatido.toMap(),
        where: "id = ?", whereArgs: [abatido.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM cortesAbatidos");
    List<CortesAbatidos> list = [];
    for (Map m in listMap) {
      list.add(CortesAbatidos.fromMap(m));
    }
    return list;
  }
}

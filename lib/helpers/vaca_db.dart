import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/vaca.dart';
import 'package:sqflite/sqflite.dart';

class VacaDB extends HelperDB {
  Vaca vaca;
  //Singleton
  //
  static VacaDB _this;
  factory VacaDB() {
    if (_this == null) {
      _this = VacaDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  VacaDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("vaca",
        where: "idVaca = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Vaca> insert(Vaca vaca) async {
    Database db = await this.getDb();
    vaca.idVaca = await db.insert("vaca", vaca.toMap());
    return vaca;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM vaca orderBy idVaca CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("vaca", where: "idVaca = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM vaca"));
  }

  Future<void> updateItem(Vaca vaca) async {
    Database db = await this.getDb();
    await db.update("vaca", vaca.toMap(),
        where: "idVaca = ?", whereArgs: [vaca.idVaca]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM vaca");
    List<Vaca> list = [];
    for (Map m in listMap) {
      list.add(Vaca.fromMap(m));
    }
    return list;
  }
}

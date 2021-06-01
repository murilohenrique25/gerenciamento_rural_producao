import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/vaca_corte.dart';
import 'package:sqflite/sqflite.dart';

class VacaCorteDB extends HelperDB {
  VacaCorte vaca;
  //Singleton
  //
  static VacaCorteDB _this;
  factory VacaCorteDB() {
    if (_this == null) {
      _this = VacaCorteDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  VacaCorteDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("vacaCorte",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<VacaCorte> insert(VacaCorte vaca) async {
    Database db = await this.getDb();
    vaca.id = await db.insert("vacaCorte", vaca.toMap());
    return vaca;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM vacaCorte orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("vacaCorte", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM vacaCorte"));
  }

  Future<void> updateItem(VacaCorte vaca) async {
    Database db = await this.getDb();
    await db.update("vacaCorte", vaca.toMap(),
        where: "id = ?", whereArgs: [vaca.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM vacaCorte");
    List<VacaCorte> list = [];
    for (Map m in listMap) {
      list.add(VacaCorte.fromMap(m));
    }
    return list;
  }
}

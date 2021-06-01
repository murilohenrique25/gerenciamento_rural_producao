import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/nutricao_concentrado.dart';
import 'package:sqflite/sqflite.dart';

class NutricaoConcentradoBovinoCorteDB extends HelperDB {
  NutricaoConcentrado nutricaoConcentrado;
  //Singleton
  //
  static NutricaoConcentradoBovinoCorteDB _this;
  factory NutricaoConcentradoBovinoCorteDB() {
    if (_this == null) {
      _this = NutricaoConcentradoBovinoCorteDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  NutricaoConcentradoBovinoCorteDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("nutricaoConcentradoBovinoCorte",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<NutricaoConcentrado> insert(
      NutricaoConcentrado nutricaoConcentrado) async {
    Database db = await this.getDb();
    nutricaoConcentrado.id = await db.insert(
        "nutricaoConcentradoBovinoCorte", nutricaoConcentrado.toMap());
    return nutricaoConcentrado;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery(
        "SELECT * FROM nutricaoConcentradoBovinoCorte orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("nutricaoConcentradoBovinoCorte",
        where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(await db
        .rawQuery("SELECT COUNT(*) FROM nutricaoConcentradoBovinoCorte"));
  }

  Future<void> updateItem(NutricaoConcentrado nutricaoConcentrado) async {
    Database db = await this.getDb();
    await db.update(
        "nutricaoConcentradoBovinoCorte", nutricaoConcentrado.toMap(),
        where: "id = ?", whereArgs: [nutricaoConcentrado.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap =
        await db.rawQuery("SELECT * FROM nutricaoConcentradoBovinoCorte");
    List<NutricaoConcentrado> list = [];
    for (Map m in listMap) {
      list.add(NutricaoConcentrado.fromMap(m));
    }
    return list;
  }
}

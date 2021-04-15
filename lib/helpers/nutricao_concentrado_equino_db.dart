import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/nutricao_concentrado.dart';
import 'package:sqflite/sqflite.dart';

class NutricaoConcentradoEquinoDB extends HelperDB {
  NutricaoConcentrado nutricaoConcentrado;
  //Singleton
  //
  static NutricaoConcentradoEquinoDB _this;
  factory NutricaoConcentradoEquinoDB() {
    if (_this == null) {
      _this = NutricaoConcentradoEquinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  NutricaoConcentradoEquinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("nutricaoConcentradoEquino",
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
        "nutricaoConcentradoEquino", nutricaoConcentrado.toMap());
    return nutricaoConcentrado;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db
        .rawQuery("SELECT * FROM nutricaoConcentradoEquino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("nutricaoConcentradoEquino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM nutricaoConcentradoEquino"));
  }

  Future<void> updateItem(NutricaoConcentrado nutricaoConcentrado) async {
    Database db = await this.getDb();
    await db.update("nutricaoConcentradoEquino", nutricaoConcentrado.toMap(),
        where: "id = ?", whereArgs: [nutricaoConcentrado.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM nutricaoConcentradoEquino");
    List<NutricaoConcentrado> list = [];
    for (Map m in listMap) {
      list.add(NutricaoConcentrado.fromMap(m));
    }
    return list;
  }
}

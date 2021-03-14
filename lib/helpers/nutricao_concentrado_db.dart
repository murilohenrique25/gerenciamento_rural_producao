import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/nutricao_concentrado.dart';
import 'package:sqflite/sqflite.dart';

class NutricaoConcentradoDB extends HelperDB {
  NutricaoConcentrado nutricaoConcentrado;
  //Singleton
  //
  static NutricaoConcentradoDB _this;
  factory NutricaoConcentradoDB() {
    if (_this == null) {
      _this = NutricaoConcentradoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  NutricaoConcentradoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("nutricaoConcentrado",
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
    nutricaoConcentrado.id =
        await db.insert("nutricaoConcentrado", nutricaoConcentrado.toMap());
    return nutricaoConcentrado;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM nutricaoConcentrado orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("nutricaoConcentrado", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM nutricaoConcentrado"));
  }

  Future<void> updateItem(NutricaoConcentrado nutricaoConcentrado) async {
    Database db = await this.getDb();
    await db.update("nutricaoConcentrado", nutricaoConcentrado.toMap(),
        where: "id = ?", whereArgs: [nutricaoConcentrado.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM nutricaoConcentrado");
    List<NutricaoConcentrado> list = List();
    for (Map m in listMap) {
      list.add(NutricaoConcentrado.fromMap(m));
    }
    return list;
  }
}

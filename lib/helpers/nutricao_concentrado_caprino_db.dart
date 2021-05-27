import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/nutricao_concentrado.dart';
import 'package:sqflite/sqflite.dart';

class NutricaoConcentradoCaprinoDB extends HelperDB {
  NutricaoConcentrado nutricaoConcentrado;
  //Singleton
  //
  static NutricaoConcentradoCaprinoDB _this;
  factory NutricaoConcentradoCaprinoDB() {
    if (_this == null) {
      _this = NutricaoConcentradoCaprinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  NutricaoConcentradoCaprinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("nutricaoConcentradoCaprino",
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
        "nutricaoConcentradoCaprino", nutricaoConcentrado.toMap());
    return nutricaoConcentrado;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db
        .rawQuery("SELECT * FROM nutricaoConcentradoCaprino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("nutricaoConcentradoCaprino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM nutricaoConcentradoCaprino"));
  }

  Future<void> updateItem(NutricaoConcentrado nutricaoConcentrado) async {
    Database db = await this.getDb();
    await db.update("nutricaoConcentradoCaprino", nutricaoConcentrado.toMap(),
        where: "id = ?", whereArgs: [nutricaoConcentrado.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap =
        await db.rawQuery("SELECT * FROM nutricaoConcentradoCaprino");
    List<NutricaoConcentrado> list = [];
    for (Map m in listMap) {
      list.add(NutricaoConcentrado.fromMap(m));
    }
    return list;
  }
}

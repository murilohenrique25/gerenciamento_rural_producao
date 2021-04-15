import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/nutricao_suina.dart';
import 'package:sqflite/sqflite.dart';

class NutricaoSuinaDB extends HelperDB {
  NutricaoSuina nutricaoSuina;
  //Singleton
  //
  static NutricaoSuinaDB _this;
  factory NutricaoSuinaDB() {
    if (_this == null) {
      _this = NutricaoSuinaDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  NutricaoSuinaDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("nutricaoSuina",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<NutricaoSuina> insert(NutricaoSuina nutricaoSuina) async {
    Database db = await this.getDb();
    nutricaoSuina.id = await db.insert("nutricaoSuina", nutricaoSuina.toMap());
    return nutricaoSuina;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM nutricaoSuina orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("nutricaoSuina", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM nutricaoSuina"));
  }

  Future<void> updateItem(NutricaoSuina nutricaoSuina) async {
    Database db = await this.getDb();
    await db.update("nutricaoSuina", nutricaoSuina.toMap(),
        where: "id = ?", whereArgs: [nutricaoSuina.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM nutricaoSuina");
    List<NutricaoSuina> list = [];
    for (Map m in listMap) {
      list.add(NutricaoSuina.fromMap(m));
    }
    return list;
  }
}

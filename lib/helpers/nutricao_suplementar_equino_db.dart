import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/nutricao_suplementar.dart';
import 'package:sqflite/sqflite.dart';

class NutricaoSuplementarEquinoDB extends HelperDB {
  NutricaoSuplementar nutricaoSuplementar;
  //Singleton
  //
  static NutricaoSuplementarEquinoDB _this;
  factory NutricaoSuplementarEquinoDB() {
    if (_this == null) {
      _this = NutricaoSuplementarEquinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  NutricaoSuplementarEquinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("nutricaoSuplementarEquino",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<NutricaoSuplementar> insert(
      NutricaoSuplementar nutricaoSuplementar) async {
    Database db = await this.getDb();
    nutricaoSuplementar.id = await db.insert(
        "nutricaoSuplementarEquino", nutricaoSuplementar.toMap());
    return nutricaoSuplementar;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db
        .rawQuery("SELECT * FROM nutricaoSuplementarEquino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("nutricaoSuplementarEquino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM nutricaoSuplementarEquino"));
  }

  Future<void> updateItem(NutricaoSuplementar nutricaoSuplementar) async {
    Database db = await this.getDb();
    await db.update("nutricaoSuplementarEquino", nutricaoSuplementar.toMap(),
        where: "id = ?", whereArgs: [nutricaoSuplementar.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM nutricaoSuplementarEquino");
    List<NutricaoSuplementar> list = [];
    for (Map m in listMap) {
      list.add(NutricaoSuplementar.fromMap(m));
    }
    return list;
  }
}

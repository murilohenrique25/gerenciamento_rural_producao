import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/nutricao_suplementar.dart';
import 'package:sqflite/sqflite.dart';

class NutricaoSuplementarDB extends HelperDB {
  NutricaoSuplementar nutricaoSuplementar;
  //Singleton
  //
  static NutricaoSuplementarDB _this;
  factory NutricaoSuplementarDB() {
    if (_this == null) {
      _this = NutricaoSuplementarDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  NutricaoSuplementarDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("nutricaoSuplementar",
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
    nutricaoSuplementar.id =
        await db.insert("nutricaoSuplementar", nutricaoSuplementar.toMap());
    return nutricaoSuplementar;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM nutricaoSuplementar orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("nutricaoSuplementar", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM nutricaoSuplementar"));
  }

  Future<void> updateItem(NutricaoSuplementar nutricaoSuplementar) async {
    Database db = await this.getDb();
    await db.update("nutricaoSuplementar", nutricaoSuplementar.toMap(),
        where: "id = ?", whereArgs: [nutricaoSuplementar.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM nutricaoSuplementar");
    List<NutricaoSuplementar> list = List();
    for (Map m in listMap) {
      list.add(NutricaoSuplementar.fromMap(m));
    }
    return list;
  }
}

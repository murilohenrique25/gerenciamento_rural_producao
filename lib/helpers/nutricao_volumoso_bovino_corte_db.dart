import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/nutricao_volumoso.dart';
import 'package:sqflite/sqflite.dart';

class NutricaoVolumosoBovinoCorteDB extends HelperDB {
  NutricaoVolumoso nutricaoVolumoso;
  //Singleton
  //
  static NutricaoVolumosoBovinoCorteDB _this;
  factory NutricaoVolumosoBovinoCorteDB() {
    if (_this == null) {
      _this = NutricaoVolumosoBovinoCorteDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  NutricaoVolumosoBovinoCorteDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("nutricaoVolumosoBovinoCorte",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<NutricaoVolumoso> insert(NutricaoVolumoso nutricaoVolumoso) async {
    Database db = await this.getDb();
    nutricaoVolumoso.id = await db.insert(
        "nutricaoVolumosoBovinoCorte", nutricaoVolumoso.toMap());
    return nutricaoVolumoso;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db
        .rawQuery("SELECT * FROM nutricaoVolumosoBovinoCorte orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("nutricaoVolumosoBovinoCorte",
        where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM nutricaoVolumosoBovinoCorte"));
  }

  Future<void> updateItem(NutricaoVolumoso nutricaoVolumoso) async {
    Database db = await this.getDb();
    await db.update("nutricaoVolumosoBovinoCorte", nutricaoVolumoso.toMap(),
        where: "id = ?", whereArgs: [nutricaoVolumoso.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap =
        await db.rawQuery("SELECT * FROM nutricaoVolumosoBovinoCorte");
    List<NutricaoVolumoso> list = [];
    for (Map m in listMap) {
      list.add(NutricaoVolumoso.fromMap(m));
    }
    return list;
  }
}

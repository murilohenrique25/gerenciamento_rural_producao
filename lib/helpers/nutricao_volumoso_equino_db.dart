import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/nutricao_volumoso.dart';
import 'package:sqflite/sqflite.dart';

class NutricaoVolumosoEquinoDB extends HelperDB {
  NutricaoVolumoso nutricaoVolumoso;
  //Singleton
  //
  static NutricaoVolumosoEquinoDB _this;
  factory NutricaoVolumosoEquinoDB() {
    if (_this == null) {
      _this = NutricaoVolumosoEquinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  NutricaoVolumosoEquinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("nutricaoVolumosoEquino",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<NutricaoVolumoso> insert(NutricaoVolumoso nutricaoVolumoso) async {
    Database db = await this.getDb();
    nutricaoVolumoso.id =
        await db.insert("nutricaoVolumosoEquino", nutricaoVolumoso.toMap());
    return nutricaoVolumoso;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM nutricaoVolumosoEquino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("nutricaoVolumosoEquino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM nutricaoVolumosoEquino"));
  }

  Future<void> updateItem(NutricaoVolumoso nutricaoVolumoso) async {
    Database db = await this.getDb();
    await db.update("nutricaoVolumosoEquino", nutricaoVolumoso.toMap(),
        where: "id = ?", whereArgs: [nutricaoVolumoso.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM nutricaoVolumosoEquino");
    List<NutricaoVolumoso> list = [];
    for (Map m in listMap) {
      list.add(NutricaoVolumoso.fromMap(m));
    }
    return list;
  }
}

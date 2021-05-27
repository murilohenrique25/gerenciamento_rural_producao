import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/producao_carne_caprina.dart';
import 'package:sqflite/sqflite.dart';

class ProducaoCarneCaprinaDB extends HelperDB {
  ProducaoCarneCaprina producaoCarneCaprina;
  //Singleton
  //
  static ProducaoCarneCaprinaDB _this;
  factory ProducaoCarneCaprinaDB() {
    if (_this == null) {
      _this = ProducaoCarneCaprinaDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  ProducaoCarneCaprinaDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("producaoCarneCaprina",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<ProducaoCarneCaprina> insert(
      ProducaoCarneCaprina producaoCarneCaprina) async {
    Database db = await this.getDb();
    producaoCarneCaprina.id =
        await db.insert("producaoCarneCaprina", producaoCarneCaprina.toMap());
    return producaoCarneCaprina;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM producaoCarneCaprina orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("producaoCarneCaprina", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM producaoCarneCaprina"));
  }

  Future<void> updateItem(ProducaoCarneCaprina producaoCarneCaprina) async {
    Database db = await this.getDb();
    await db.update("producaoCarneCaprina", producaoCarneCaprina.toMap(),
        where: "id = ?", whereArgs: [producaoCarneCaprina.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM producaoCarneCaprina");
    List<ProducaoCarneCaprina> list = [];
    for (Map m in listMap) {
      list.add(ProducaoCarneCaprina.fromMap(m));
    }
    return list;
  }
}

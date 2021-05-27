import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/preco_carne_caprina.dart';
import 'package:sqflite/sqflite.dart';

class PrecoCarneCaprinaDB extends HelperDB {
  PrecoCarneCaprina precoCarneCaprina;
  //Singleton
  //
  static PrecoCarneCaprinaDB _this;
  factory PrecoCarneCaprinaDB() {
    if (_this == null) {
      _this = PrecoCarneCaprinaDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  PrecoCarneCaprinaDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("precoCarneCaprina",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<PrecoCarneCaprina> insert(PrecoCarneCaprina precoCarneCaprina) async {
    Database db = await this.getDb();
    precoCarneCaprina.id =
        await db.insert("precoCarneCaprina", precoCarneCaprina.toMap());
    return precoCarneCaprina;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM precoCarneCaprina orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("precoCarneCaprina", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM precoCarneCaprina"));
  }

  Future<void> updateItem(PrecoCarneCaprina precoCarneCaprina) async {
    Database db = await this.getDb();
    await db.update("precoCarneCaprina", precoCarneCaprina.toMap(),
        where: "id = ?", whereArgs: [precoCarneCaprina.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM precoCarneCaprina");
    List<PrecoCarneCaprina> list = [];
    for (Map m in listMap) {
      list.add(PrecoCarneCaprina.fromMap(m));
    }
    return list;
  }
}

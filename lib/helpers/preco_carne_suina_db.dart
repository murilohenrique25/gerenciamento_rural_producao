import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/preco_carne_suina.dart';
import 'package:sqflite/sqflite.dart';

class PrecoCarneSuinaDB extends HelperDB {
  PrecoCarneSuina precoCarneSuina;
  //Singleton
  //
  static PrecoCarneSuinaDB _this;
  factory PrecoCarneSuinaDB() {
    if (_this == null) {
      _this = PrecoCarneSuinaDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  PrecoCarneSuinaDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("precoCarneSuina",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<PrecoCarneSuina> insert(PrecoCarneSuina precoCarneSuina) async {
    Database db = await this.getDb();
    precoCarneSuina.id =
        await db.insert("precoCarneSuina", precoCarneSuina.toMap());
    return precoCarneSuina;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM precoCarneSuina orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("precoCarneSuina", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM precoCarneSuina"));
  }

  Future<void> updateItem(PrecoCarneSuina precoCarneSuina) async {
    Database db = await this.getDb();
    await db.update("precoCarneSuina", precoCarneSuina.toMap(),
        where: "id = ?", whereArgs: [precoCarneSuina.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM precoCarneSuina");
    List<PrecoCarneSuina> list = [];
    for (Map m in listMap) {
      list.add(PrecoCarneSuina.fromMap(m));
    }
    return list;
  }
}

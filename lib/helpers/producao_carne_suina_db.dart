import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/producao_carne_suina.dart';
import 'package:sqflite/sqflite.dart';

class ProducaoCarneSuinaDB extends HelperDB {
  ProducaoCarneSuina producaoCarneSuina;
  //Singleton
  //
  static ProducaoCarneSuinaDB _this;
  factory ProducaoCarneSuinaDB() {
    if (_this == null) {
      _this = ProducaoCarneSuinaDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  ProducaoCarneSuinaDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("producaoCarneSuina",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<ProducaoCarneSuina> insert(
      ProducaoCarneSuina producaoCarneSuina) async {
    Database db = await this.getDb();
    producaoCarneSuina.id =
        await db.insert("producaoCarneSuina", producaoCarneSuina.toMap());
    return producaoCarneSuina;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM producaoCarneSuina orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("producaoCarneSuina", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM producaoCarneSuina"));
  }

  Future<void> updateItem(ProducaoCarneSuina producaoCarneSuina) async {
    Database db = await this.getDb();
    await db.update("producaoCarneSuina", producaoCarneSuina.toMap(),
        where: "id = ?", whereArgs: [producaoCarneSuina.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM producaoCarneSuina");
    List<ProducaoCarneSuina> list = [];
    for (Map m in listMap) {
      list.add(ProducaoCarneSuina.fromMap(m));
    }
    return list;
  }
}

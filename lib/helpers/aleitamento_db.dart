import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/aleitamento.dart';
import 'package:sqflite/sqflite.dart';

class AleitamentoDB extends HelperDB {
  Aleitamento aleitamento;
  //Singleton
  //
  static AleitamentoDB _this;
  factory AleitamentoDB() {
    if (_this == null) {
      _this = AleitamentoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  AleitamentoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("aleitamento",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Aleitamento> insert(Aleitamento aleitamento) async {
    Database db = await this.getDb();
    aleitamento.id = await db.insert("aleitamento", aleitamento.toMap());
    return aleitamento;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM aleitamento orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("aleitamento", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM aleitamento"));
  }

  Future<void> updateItem(Aleitamento aleitamento) async {
    Database db = await this.getDb();
    await db.update("aleitamento", aleitamento.toMap(),
        where: "id = ?", whereArgs: [aleitamento.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap =
        await db.rawQuery("SELECT * FROM aleitamento WHERE mudar_plantel == 0");
    List<Aleitamento> list = [];
    for (Map m in listMap) {
      list.add(Aleitamento.fromMap(m));
    }
    return list;
  }
}

import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/aleitamento.dart';
import 'package:gerenciamento_rural/models/matriz.dart';
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
    List<Map> items = await db.query("matriz",
        where: "id_animal = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Matriz> insert(Matriz matriz) async {
    Database db = await this.getDb();
    matriz.idAnimal = await db.insert("matriz", matriz.toMap());
    return matriz;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM matriz orderBy id_animal CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("matriz", where: "id_animal = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM matriz"));
  }

  Future<void> updateItem(Matriz matriz) async {
    Database db = await this.getDb();
    await db.update("matriz", matriz.toMap(),
        where: "id_animal = ?", whereArgs: [matriz.idAnimal]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM matriz");
    List<Matriz> list = List();
    for (Map m in listMap) {
      list.add(Matriz.fromMap(m));
    }
    return list;
  }
}

import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/cachaco.dart';
import 'package:sqflite/sqflite.dart';

class CachacoDB extends HelperDB {
  Cachaco cachaco;
  //Singleton
  //
  static CachacoDB _this;
  factory CachacoDB() {
    if (_this == null) {
      _this = CachacoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  CachacoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("cachaco",
        where: "id_animal = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Cachaco> insert(Cachaco cachaco) async {
    Database db = await this.getDb();
    cachaco.idAnimal = await db.insert("cachaco", cachaco.toMap());
    return cachaco;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM cachaco orderBy id_animal CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("cachaco", where: "id_animal = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM cachaco"));
  }

  Future<void> updateItem(Cachaco cachaco) async {
    Database db = await this.getDb();
    await db.update("cachaco", cachaco.toMap(),
        where: "id_animal = ?", whereArgs: [cachaco.idAnimal]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM cachaco");
    List<Cachaco> list = List();
    for (Map m in listMap) {
      list.add(Cachaco.fromMap(m));
    }
    return list;
  }
}

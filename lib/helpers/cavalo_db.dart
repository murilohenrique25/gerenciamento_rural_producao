import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/cavalo.dart';
import 'package:sqflite/sqflite.dart';

class CavaloDB extends HelperDB {
  Cavalo cavalo;
  //Singleton
  //
  static CavaloDB _this;
  factory CavaloDB() {
    if (_this == null) {
      _this = CavaloDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  CavaloDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items =
        await db.query("cavalo", where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Cavalo> insert(Cavalo cavalo) async {
    Database db = await this.getDb();
    cavalo.id = await db.insert("cavalo", cavalo.toMap());
    return cavalo;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM cavalo orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("cavalo", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM cavalo"));
  }

  Future<void> updateItem(Cavalo cavalo) async {
    Database db = await this.getDb();
    await db.update("cavalo", cavalo.toMap(),
        where: "id = ?", whereArgs: [cavalo.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM cavalo");
    List<Cavalo> list = [];
    for (Map m in listMap) {
      list.add(Cavalo.fromMap(m));
    }
    return list;
  }
}

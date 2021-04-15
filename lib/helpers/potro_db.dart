import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/potro.dart';
import 'package:sqflite/sqflite.dart';

class PotroDB extends HelperDB {
  Potro potro;
  //Singleton
  //
  static PotroDB _this;
  factory PotroDB() {
    if (_this == null) {
      _this = PotroDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  PotroDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items =
        await db.query("potro", where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Potro> insert(Potro potro) async {
    Database db = await this.getDb();
    potro.id = await db.insert("potro", potro.toMap());
    return potro;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM potro orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("potro", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM potro"));
  }

  Future<void> updateItem(Potro potro) async {
    Database db = await this.getDb();
    await db
        .update("potro", potro.toMap(), where: "id = ?", whereArgs: [potro.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM potro");
    List<Potro> list = [];
    for (Map m in listMap) {
      list.add(Potro.fromMap(m));
    }
    return list;
  }
}

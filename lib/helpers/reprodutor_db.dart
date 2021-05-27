import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/reprodutor.dart';
import 'package:sqflite/sqflite.dart';

class ReprodutorDB extends HelperDB {
  Reprodutor reprodutor;
  //Singleton
  //
  static ReprodutorDB _this;
  factory ReprodutorDB() {
    if (_this == null) {
      _this = ReprodutorDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  ReprodutorDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("reprodutor",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Reprodutor> insert(Reprodutor reprodutor) async {
    Database db = await this.getDb();
    reprodutor.id = await db.insert("reprodutor", reprodutor.toMap());
    return reprodutor;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM reprodutor orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("reprodutor", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM reprodutor"));
  }

  Future<void> updateItem(Reprodutor reprodutor) async {
    Database db = await this.getDb();
    await db.update("reprodutor", reprodutor.toMap(),
        where: "id = ?", whereArgs: [reprodutor.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM reprodutor");
    List<Reprodutor> list = [];
    for (Map m in listMap) {
      list.add(Reprodutor.fromMap(m));
    }
    return list;
  }

  Future<List> getAllItemsVivos() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery(
        "SELECT * FROM reprodutor WHERE situacao == 'Vivo' OR situacao == 'Reprodutor'");
    List<Reprodutor> list = [];
    for (Map m in listMap) {
      list.add(Reprodutor.fromMap(m));
    }
    return list;
  }
}

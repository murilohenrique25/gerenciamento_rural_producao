import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/egua.dart';
import 'package:sqflite/sqflite.dart';

class EguaDB extends HelperDB {
  Egua egua;
  //Singleton
  //
  static EguaDB _this;
  factory EguaDB() {
    if (_this == null) {
      _this = EguaDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  EguaDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items =
        await db.query("egua", where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Egua> insert(Egua egua) async {
    Database db = await this.getDb();
    egua.id = await db.insert("egua", egua.toMap());
    return egua;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM egua orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("egua", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM egua"));
  }

  Future<void> updateItem(Egua egua) async {
    Database db = await this.getDb();
    await db
        .update("egua", egua.toMap(), where: "id = ?", whereArgs: [egua.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM egua");
    List<Egua> list = [];
    for (Map m in listMap) {
      list.add(Egua.fromMap(m));
    }
    return list;
  }
}

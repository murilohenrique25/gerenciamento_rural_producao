import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/caprino_abatido.dart';
import 'package:sqflite/sqflite.dart';

class CaprinoAbatidoDB extends HelperDB {
  CaprinoAbatido caprinoAbatido;
  //Singleton
  //
  static CaprinoAbatidoDB _this;
  factory CaprinoAbatidoDB() {
    if (_this == null) {
      _this = CaprinoAbatidoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  CaprinoAbatidoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("caprinoAbatido",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<CaprinoAbatido> insert(CaprinoAbatido caprinoAbatido) async {
    Database db = await this.getDb();
    caprinoAbatido.id =
        await db.insert("caprinoAbatido", caprinoAbatido.toMap());
    return caprinoAbatido;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM caprinoAbatido orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("caprinoAbatido", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM caprinoAbatido"));
  }

  Future<void> updateItem(CaprinoAbatido caprinoAbatido) async {
    Database db = await this.getDb();
    await db.update("caprinoAbatido", caprinoAbatido.toMap(),
        where: "id = ?", whereArgs: [caprinoAbatido.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM caprinoAbatido");
    List<CaprinoAbatido> list = [];
    for (Map m in listMap) {
      list.add(CaprinoAbatido.fromMap(m));
    }
    return list;
  }
}

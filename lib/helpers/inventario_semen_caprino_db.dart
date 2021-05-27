import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/inventario_semen_caprino.dart';
import 'package:sqflite/sqflite.dart';

class InventarioSemenCaprinoDB extends HelperDB {
  InventarioSemenCaprino inventario;
  //Singleton
  //
  static InventarioSemenCaprinoDB _this;
  factory InventarioSemenCaprinoDB() {
    if (_this == null) {
      _this = InventarioSemenCaprinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  InventarioSemenCaprinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("inventarioSemenCaprino",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<InventarioSemenCaprino> insert(
      InventarioSemenCaprino inventario) async {
    Database db = await this.getDb();
    inventario.id =
        await db.insert("inventarioSemenCaprino", inventario.toMap());
    return inventario;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM inventarioSemenCaprino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("inventarioSemenCaprino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM inventarioSemenCaprino"));
  }

  // Future<int> updateItems(InventarioSemen inventariosemen) async {
  //   Database db = await this.getDb();
  //   int p = await db.update("inventarioSemen", inventariosemen.toMap(),
  //       where: "id = ?", whereArgs: [inventariosemen.id]);

  //   return p;
  // }

  Future<void> updateItem(InventarioSemenCaprino inventariosemen) async {
    Database db = await this.getDb();
    await db.update("inventarioSemenCaprino", inventariosemen.toMap(),
        where: "id = ?", whereArgs: [inventariosemen.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM inventarioSemenCaprino");
    List<InventarioSemenCaprino> list = [];
    for (Map m in listMap) {
      list.add(InventarioSemenCaprino.fromMap(m));
    }
    return list;
  }

  Future<List> getAllItemsEstoque() async {
    Database db = await this.getDb();
    List listMap = await db
        .rawQuery("SELECT * FROM inventarioSemenCaprino WHERE quantidade > 0");
    List<InventarioSemenCaprino> list = [];
    for (Map m in listMap) {
      list.add(InventarioSemenCaprino.fromMap(m));
    }
    return list;
  }
}

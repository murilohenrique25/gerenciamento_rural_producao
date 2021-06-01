import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/inventario_semen.dart';
import 'package:sqflite/sqflite.dart';

class InventarioSemenBovinoCorteDB extends HelperDB {
  InventarioSemen inventario;
  //Singleton
  //
  static InventarioSemenBovinoCorteDB _this;
  factory InventarioSemenBovinoCorteDB() {
    if (_this == null) {
      _this = InventarioSemenBovinoCorteDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  InventarioSemenBovinoCorteDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("inventarioSemenBovinoCorte",
        where: "id_inventario = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<InventarioSemen> insert(InventarioSemen inventario) async {
    Database db = await this.getDb();
    inventario.id =
        await db.insert("inventarioSemenBovinoCorte", inventario.toMap());
    return inventario;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery(
        "SELECT * FROM inventarioSemenBovinoCorte orderBy id_inventario CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("inventarioSemenBovinoCorte",
        where: "id_inventario = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM inventarioSemenBovinoCorte"));
  }

  // Future<int> updateItems(InventarioSemen inventariosemen) async {
  //   Database db = await this.getDb();
  //   int p = await db.update("inventarioSemen", inventariosemen.toMap(),
  //       where: "id = ?", whereArgs: [inventariosemen.id]);

  //   return p;
  // }

  Future<void> updateItem(InventarioSemen inventariosemen) async {
    Database db = await this.getDb();
    await db.update("inventarioSemenBovinoCorte", inventariosemen.toMap(),
        where: "id_inventario = ?", whereArgs: [inventariosemen.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap =
        await db.rawQuery("SELECT * FROM inventarioSemenBovinoCorte");
    List<InventarioSemen> list = [];
    for (Map m in listMap) {
      list.add(InventarioSemen.fromMap(m));
    }
    return list;
  }
}

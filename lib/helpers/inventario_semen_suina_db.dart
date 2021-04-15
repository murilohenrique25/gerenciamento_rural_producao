import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/inventario_semen_suino.dart';
import 'package:sqflite/sqflite.dart';

class InventarioSemenSuinaDB extends HelperDB {
  InventarioSemenSuina inventario;
  //Singleton
  //
  static InventarioSemenSuinaDB _this;
  factory InventarioSemenSuinaDB() {
    if (_this == null) {
      _this = InventarioSemenSuinaDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  InventarioSemenSuinaDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("inventarioSemenSuina",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<InventarioSemenSuina> insert(InventarioSemenSuina inventario) async {
    Database db = await this.getDb();
    inventario.id = await db.insert("inventarioSemenSuina", inventario.toMap());
    return inventario;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM inventarioSemenSuina orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("inventarioSemenSuina", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM inventarioSemenSuina"));
  }

  // Future<int> updateItems(InventarioSemen inventariosemen) async {
  //   Database db = await this.getDb();
  //   int p = await db.update("inventarioSemen", inventariosemen.toMap(),
  //       where: "id = ?", whereArgs: [inventariosemen.id]);

  //   return p;
  // }

  Future<void> updateItem(InventarioSemenSuina inventariosemen) async {
    Database db = await this.getDb();
    await db.update("inventarioSemenSuina", inventariosemen.toMap(),
        where: "id = ?", whereArgs: [inventariosemen.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM inventarioSemenSuina");
    List<InventarioSemenSuina> list = [];
    for (Map m in listMap) {
      list.add(InventarioSemenSuina.fromMap(m));
    }
    return list;
  }

  Future<List> getAllItemsEstoque() async {
    Database db = await this.getDb();
    List listMap = await db
        .rawQuery("SELECT * FROM inventarioSemenSuina WHERE quantidade > 0");
    List<InventarioSemenSuina> list = [];
    for (Map m in listMap) {
      list.add(InventarioSemenSuina.fromMap(m));
    }
    return list;
  }
}

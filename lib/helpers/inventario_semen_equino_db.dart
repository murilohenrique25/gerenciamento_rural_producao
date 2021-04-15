import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/inventario_semen_equino.dart';
import 'package:sqflite/sqflite.dart';

class InventarioSemenEquinoDB extends HelperDB {
  InventarioSemenEquino inventario;
  //Singleton
  //
  static InventarioSemenEquinoDB _this;
  factory InventarioSemenEquinoDB() {
    if (_this == null) {
      _this = InventarioSemenEquinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  InventarioSemenEquinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("inventarioSemenEquino",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<InventarioSemenEquino> insert(InventarioSemenEquino inventario) async {
    Database db = await this.getDb();
    inventario.id =
        await db.insert("inventarioSemenEquino", inventario.toMap());
    return inventario;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM inventarioSemenEquino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("inventarioSemenEquino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM inventarioSemenEquino"));
  }

  // Future<int> updateItems(InventarioSemen inventariosemen) async {
  //   Database db = await this.getDb();
  //   int p = await db.update("inventarioSemen", inventariosemen.toMap(),
  //       where: "id = ?", whereArgs: [inventariosemen.id]);

  //   return p;
  // }

  Future<void> updateItem(InventarioSemenEquino inventariosemen) async {
    Database db = await this.getDb();
    await db.update("inventarioSemenEquino", inventariosemen.toMap(),
        where: "id = ?", whereArgs: [inventariosemen.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM inventarioSemenEquino");
    List<InventarioSemenEquino> list = [];
    for (Map m in listMap) {
      list.add(InventarioSemenEquino.fromMap(m));
    }
    return list;
  }

  Future<List> getAllItemsEstoque() async {
    Database db = await this.getDb();
    List listMap = await db
        .rawQuery("SELECT * FROM inventarioSemenEquino WHERE quantidade > 0");
    List<InventarioSemenEquino> list = [];
    for (Map m in listMap) {
      list.add(InventarioSemenEquino.fromMap(m));
    }
    return list;
  }
}

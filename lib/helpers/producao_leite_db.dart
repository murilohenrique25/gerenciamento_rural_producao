import 'package:gerenciamento_rural/models/producao_leite.dart';
import 'package:sqflite/sqflite.dart';

import 'HelperDB.dart';
import 'application.dart';

class ProducaoLeiteDB extends HelperDB {
  ProducaoLeite producaoLeite;
  //Singleton
  //
  static ProducaoLeiteDB _this;
  factory ProducaoLeiteDB() {
    if (_this == null) {
      _this = ProducaoLeiteDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  ProducaoLeiteDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("producaoLeiteTable",
        where: "id_prod_leite = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<ProducaoLeite> insert(ProducaoLeite producaoLeite) async {
    Database db = await this.getDb();
    producaoLeite.id =
        await db.insert("producaoLeiteTable", producaoLeite.toMap());
    return producaoLeite;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery(
        "SELECT * FROM producaoLeiteTable orderBy id_prod_leite CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("producaoLeiteTable", where: "id_prod_leite", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM producaoLeiteTable"));
  }

  Future<int> updateItem(ProducaoLeite producaoLeite) async {
    Database db = await this.getDb();
    int p = await db.update("producaoLeiteTable", producaoLeite.toMap());

    return p;
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM producaoLeiteTable");
    List<ProducaoLeite> list = List();
    for (Map m in listMap) {
      list.add(ProducaoLeite.fromMap(m));
    }
    return list;
  }
}

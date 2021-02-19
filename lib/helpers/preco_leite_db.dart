import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/preco_leite.dart';
import 'package:sqflite/sqflite.dart';

class PrecoLeiteDB extends HelperDB {
  PrecoLeite precoLeite;
  //Singleton
  //
  static PrecoLeiteDB _this;
  factory PrecoLeiteDB() {
    if (_this == null) {
      _this = PrecoLeiteDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  PrecoLeiteDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("precoLeite",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<PrecoLeite> insert(PrecoLeite precoLeite) async {
    Database db = await this.getDb();
    precoLeite.id = await db.insert("precoLeite", precoLeite.toMap());
    return precoLeite;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM precoLeite orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("precoLeite", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM precoLeite"));
  }

  Future<int> updateItem(PrecoLeite precoLeite) async {
    Database db = await this.getDb();
    int p = await db.update("precoLeite", precoLeite.toMap());

    return p;
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM precoLeite");
    List<PrecoLeite> list = List();
    for (Map m in listMap) {
      list.add(PrecoLeite.fromMap(m));
    }
    return list;
  }
}
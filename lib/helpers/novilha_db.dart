import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/novilha.dart';
import 'package:sqflite/sqflite.dart';

class NovilhaDB extends HelperDB {
  Novilha novilha;
  //Singleton
  //
  static NovilhaDB _this;
  factory NovilhaDB() {
    if (_this == null) {
      _this = NovilhaDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  NovilhaDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("novilha",
        where: "idNovilha = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Novilha> insert(Novilha novilha) async {
    Database db = await this.getDb();
    novilha.idNovilha = await db.insert("novilha", novilha.toMap());
    return novilha;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM novilha orderBy idNovilha CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("novilha", where: "idNovilha = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM novilha"));
  }

  Future<void> updateItem(Novilha novilha) async {
    Database db = await this.getDb();
    await db.update("novilha", novilha.toMap(),
        where: "idNovilha = ?", whereArgs: [novilha.idNovilha]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM novilha");
    List<Novilha> list = List();
    for (Map m in listMap) {
      list.add(Novilha.fromMap(m));
    }
    return list;
  }
}

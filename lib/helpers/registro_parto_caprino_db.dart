import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/registro_partos_caprinos.dart';
import 'package:sqflite/sqflite.dart';

class RegistroPartoCaprinoDB extends HelperDB {
  RegistroPartoCaprino registroPartoCaprino;
  //Singleton
  //
  static RegistroPartoCaprinoDB _this;
  factory RegistroPartoCaprinoDB() {
    if (_this == null) {
      _this = RegistroPartoCaprinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  RegistroPartoCaprinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("registroPartoCaprino",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<RegistroPartoCaprino> insert(
      RegistroPartoCaprino registroPartoCaprino) async {
    Database db = await this.getDb();
    registroPartoCaprino.id =
        await db.insert("registroPartoCaprino", registroPartoCaprino.toMap());
    return registroPartoCaprino;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM registroPartoCaprino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("registroPartoCaprino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM registroPartoCaprino"));
  }

  Future<void> updateItem(RegistroPartoCaprino registroPartoCaprino) async {
    Database db = await this.getDb();
    await db.update("registroPartoCaprino", registroPartoCaprino.toMap(),
        where: "id = ?", whereArgs: [registroPartoCaprino.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM registroPartoCaprino");
    List<RegistroPartoCaprino> list = [];
    for (Map m in listMap) {
      list.add(RegistroPartoCaprino.fromMap(m));
    }
    return list;
  }
}

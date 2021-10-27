import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/registro_partos_bovino_corte.dart';
import 'package:sqflite/sqflite.dart';

class RegistroPartoBCDB extends HelperDB {
  RegistroPartoBC registroPartoBC;
  //Singleton
  //
  static RegistroPartoBCDB _this;
  factory RegistroPartoBCDB() {
    if (_this == null) {
      _this = RegistroPartoBCDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  RegistroPartoBCDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("registroPartoBC",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<RegistroPartoBC> insert(RegistroPartoBC registroPartoBC) async {
    Database db = await this.getDb();
    registroPartoBC.id =
        await db.insert("registroPartoBC", registroPartoBC.toMap());
    return registroPartoBC;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM registroPartoBC orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("registroPartoBC", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM registroPartoBC"));
  }

  Future<void> updateItem(RegistroPartoBC registroPartoBC) async {
    Database db = await this.getDb();
    await db.update("registroPartoBC", registroPartoBC.toMap(),
        where: "id = ?", whereArgs: [registroPartoBC.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM registroPartoBC");
    List<RegistroPartoBC> list = [];
    for (Map m in listMap) {
      list.add(RegistroPartoBC.fromMap(m));
    }
    return list;
  }
}

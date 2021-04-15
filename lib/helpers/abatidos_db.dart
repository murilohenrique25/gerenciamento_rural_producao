import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/abatidos.dart';
import 'package:sqflite/sqflite.dart';

class AbatidosDB extends HelperDB {
  Abatido abatido;
  //Singleton
  //
  static AbatidosDB _this;
  factory AbatidosDB() {
    if (_this == null) {
      _this = AbatidosDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  AbatidosDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("abatido",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Abatido> insert(Abatido abatido) async {
    Database db = await this.getDb();
    abatido.id = await db.insert("abatido", abatido.toMap());
    return abatido;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM abatido orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("abatido", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM abatido"));
  }

  Future<void> updateItem(Abatido abatido) async {
    Database db = await this.getDb();
    await db.update("abatido", abatido.toMap(),
        where: "id = ?", whereArgs: [abatido.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM abatido");
    List<Abatido> list = [];
    for (Map m in listMap) {
      list.add(Abatido.fromMap(m));
    }
    return list;
  }
}

import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/bezerra_corte.dart';
import 'package:sqflite/sqflite.dart';

class BezerraCorteDB extends HelperDB {
  BezerraCorte bezerra;
  //Singleton
  //
  static BezerraCorteDB _this;
  factory BezerraCorteDB() {
    if (_this == null) {
      _this = BezerraCorteDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  BezerraCorteDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("bezerraCorte",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<BezerraCorte> insert(BezerraCorte bezerra) async {
    Database db = await this.getDb();
    bezerra.id = await db.insert("bezerraCorte", bezerra.toMap());
    return bezerra;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM bezerraCorte orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("bezerraCorte", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM bezerraCorte"));
  }

  ///<sumary>
  ///Método responsavel por atualizar item
  ///</sumary>
  ///<param name="bezerra"> Um tipo de animal.</param>
  Future<void> updateItem(BezerraCorte bezerra) async {
    Database db = await this.getDb();
    await db.update("bezerraCorte", bezerra.toMap(),
        where: "id = ?", whereArgs: [bezerra.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery(
        "SELECT * FROM bezerraCorte WHERE virou_adulto == 0 AND animal_abatido == 0");
    List<BezerraCorte> list = [];
    for (Map m in listMap) {
      list.add(BezerraCorte.fromMap(m));
    }
    return list;
  }
}

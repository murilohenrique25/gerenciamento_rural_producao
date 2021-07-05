import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/touro_corte.dart';
import 'package:sqflite/sqflite.dart';

class TouroCorteDB extends HelperDB {
  TouroCorte touroCorte;
  //Singleton
  //
  static TouroCorteDB _this;
  factory TouroCorteDB() {
    if (_this == null) {
      _this = TouroCorteDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  TouroCorteDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("touroCorte",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<TouroCorte> insert(TouroCorte touroCorte) async {
    Database db = await this.getDb();
    touroCorte.id = await db.insert("touroCorte", touroCorte.toMap());
    return touroCorte;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM touroCorte orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("touroCorte", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM touroCorte"));
  }

  ///<sumary>
  ///Método responsavel por atualizar item
  ///</sumary>
  ///<param name="bezerra"> Um tipo de animal.</param>
  Future<void> updateItem(TouroCorte touroCorte) async {
    Database db = await this.getDb();
    await db.update("touroCorte", touroCorte.toMap(),
        where: "id = ?", whereArgs: [touroCorte.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap =
        await db.rawQuery("SELECT * FROM touroCorte WHERE animal_abatido == 0");
    List<TouroCorte> list = [];
    for (Map m in listMap) {
      list.add(TouroCorte.fromMap(m));
    }
    return list;
  }
}

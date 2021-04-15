import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/historico_parto_suino.dart';
import 'package:sqflite/sqflite.dart';

class HistoricoPartoSuinoDB extends HelperDB {
  HistoricoPartoSuino historicoPartoSuino;
  //Singleton
  //
  static HistoricoPartoSuinoDB _this;
  factory HistoricoPartoSuinoDB() {
    if (_this == null) {
      _this = HistoricoPartoSuinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  HistoricoPartoSuinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("historicoPartoSuino",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<HistoricoPartoSuino> insert(
      HistoricoPartoSuino historicoPartoSuino) async {
    Database db = await this.getDb();
    historicoPartoSuino.id =
        await db.insert("historicoPartoSuino", historicoPartoSuino.toMap());
    return historicoPartoSuino;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM historicoPartoSuino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("historicoPartoSuino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM historicoPartoSuino"));
  }

  Future<void> updateItem(HistoricoPartoSuino historicoPartoSuino) async {
    Database db = await this.getDb();
    await db.update("historicoPartoSuino", historicoPartoSuino.toMap(),
        where: "id = ?", whereArgs: [historicoPartoSuino.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM historicoPartoSuino");
    List<HistoricoPartoSuino> list = [];
    for (Map m in listMap) {
      list.add(HistoricoPartoSuino.fromMap(m));
    }
    return list;
  }
}

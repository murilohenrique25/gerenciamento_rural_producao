import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/tratamento.dart';
import 'package:sqflite/sqflite.dart';

class TratamentoSuinoDB extends HelperDB {
  Tratamento tratamento;
  //Singleton
  //
  static TratamentoSuinoDB _this;
  factory TratamentoSuinoDB() {
    if (_this == null) {
      _this = TratamentoSuinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  TratamentoSuinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("tratamentoSuino",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Tratamento> insert(Tratamento tratamento) async {
    Database db = await this.getDb();
    tratamento.id = await db.insert("tratamentoSuino", tratamento.toMap());
    return tratamento;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM tratamentoSuino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("tratamentoSuino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM tratamentoSuino"));
  }

  Future<void> updateItem(Tratamento tratamento) async {
    Database db = await this.getDb();
    await db.update("tratamentoSuino", tratamento.toMap(),
        where: "id = ?", whereArgs: [tratamento.id]);
  }

  Future<List> getAllItemsFemeas() async {
    Database db = await this.getDb();
    List listMap =
        await db.rawQuery("SELECT * FROM tratamentoSuino WHERE tipo = 0");
    List<Tratamento> list = [];
    for (Map m in listMap) {
      list.add(Tratamento.fromMap(m));
    }
    return list;
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM tratamentoSuino");
    List<Tratamento> list = [];
    for (Map m in listMap) {
      list.add(Tratamento.fromMap(m));
    }
    return list;
  }
}

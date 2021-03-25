import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/medicamento.dart';
import 'package:sqflite/sqflite.dart';

class MedicamentoSuinoDB extends HelperDB {
  Medicamento medicamento;
  //Singleton
  //
  static MedicamentoSuinoDB _this;
  factory MedicamentoSuinoDB() {
    if (_this == null) {
      _this = MedicamentoSuinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  MedicamentoSuinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("medicamentoSuino",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Medicamento> insert(Medicamento medicamento) async {
    Database db = await this.getDb();
    medicamento.id = await db.insert("medicamentoSuino", medicamento.toMap());
    return medicamento;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM medicamentoSuino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("medicamentoSuino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM medicamentoSuino"));
  }

  Future<void> updateItem(Medicamento medicamento) async {
    Database db = await this.getDb();
    await db.update("medicamentoSuino", medicamento.toMap(),
        where: "id = ?", whereArgs: [medicamento.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM medicamentoSuino");
    List<Medicamento> list = List();
    for (Map m in listMap) {
      list.add(Medicamento.fromMap(m));
    }
    return list;
  }
}

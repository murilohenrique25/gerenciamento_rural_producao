import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/inseminacao.dart';
import 'package:sqflite/sqflite.dart';

class InseminacaoBovinoCorteDB extends HelperDB {
  Inseminacao inseminacao;
  //Singleton
  //
  static InseminacaoBovinoCorteDB _this;
  factory InseminacaoBovinoCorteDB() {
    if (_this == null) {
      _this = InseminacaoBovinoCorteDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  InseminacaoBovinoCorteDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("inseminacaoBovinoCorte",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Inseminacao> insert(Inseminacao inseminacao) async {
    Database db = await this.getDb();
    inseminacao.id =
        await db.insert("inseminacaoBovinoCorte", inseminacao.toMap());
    return inseminacao;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM inseminacaoBovinoCorte orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db
        .delete("inseminacaoBovinoCorte", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM inseminacaoBovinoCorte"));
  }

  Future<void> updateItem(Inseminacao inseminacao) async {
    Database db = await this.getDb();
    await db.update("inseminacaoBovinoCorte", inseminacao.toMap(),
        where: "id = ?", whereArgs: [inseminacao.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM inseminacaoBovinoCorte");
    List<Inseminacao> list = [];
    for (Map m in listMap) {
      list.add(Inseminacao.fromMap(m));
    }
    return list;
  }
}

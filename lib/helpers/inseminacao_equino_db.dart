import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/inseminacao_equino.dart';
import 'package:sqflite/sqflite.dart';

class InseminacaoEquinoDB extends HelperDB {
  InseminacaoEquino inseminacaoEquino;
  //Singleton
  //
  static InseminacaoEquinoDB _this;
  factory InseminacaoEquinoDB() {
    if (_this == null) {
      _this = InseminacaoEquinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  InseminacaoEquinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("inseminacaoEquino",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<InseminacaoEquino> insert(InseminacaoEquino inseminacao) async {
    Database db = await this.getDb();
    inseminacao.id = await db.insert("inseminacaoEquino", inseminacao.toMap());
    return inseminacao;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM inseminacaoEquino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("inseminacaoEquino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM inseminacaoEquino"));
  }

  Future<void> updateItem(InseminacaoEquino inseminacao) async {
    Database db = await this.getDb();
    await db.update("inseminacaoEquino", inseminacao.toMap(),
        where: "id = ?", whereArgs: [inseminacao.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM inseminacaoEquino");
    List<InseminacaoEquino> list = [];
    for (Map m in listMap) {
      list.add(InseminacaoEquino.fromMap(m));
    }
    return list;
  }
}

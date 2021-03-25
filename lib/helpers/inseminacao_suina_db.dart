import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/inseminacao_suino.dart';
import 'package:sqflite/sqflite.dart';

class InseminacaoSuinaDB extends HelperDB {
  InseminacaoSuino inseminacaoSuino;
  //Singleton
  //
  static InseminacaoSuinaDB _this;
  factory InseminacaoSuinaDB() {
    if (_this == null) {
      _this = InseminacaoSuinaDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  InseminacaoSuinaDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("inseminacaoSuina",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<InseminacaoSuino> insert(InseminacaoSuino inseminacao) async {
    Database db = await this.getDb();
    inseminacao.id = await db.insert("inseminacaoSuina", inseminacao.toMap());
    return inseminacao;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM inseminacaoSuina orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("inseminacaoSuina", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM inseminacaoSuina"));
  }

  Future<void> updateItem(InseminacaoSuino inseminacao) async {
    Database db = await this.getDb();
    await db.update("inseminacaoSuina", inseminacao.toMap(),
        where: "id = ?", whereArgs: [inseminacao.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM inseminacaoSuina");
    List<InseminacaoSuino> list = List();
    for (Map m in listMap) {
      list.add(InseminacaoSuino.fromMap(m));
    }
    return list;
  }
}

import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/inseminacao_caprino.dart';
import 'package:sqflite/sqflite.dart';

class InseminacaoCaprinaDB extends HelperDB {
  InseminacaoCaprino inseminacaoCaprino;
  //Singleton
  //
  static InseminacaoCaprinaDB _this;
  factory InseminacaoCaprinaDB() {
    if (_this == null) {
      _this = InseminacaoCaprinaDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  InseminacaoCaprinaDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("inseminacaoCaprino",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<InseminacaoCaprino> insert(InseminacaoCaprino inseminacao) async {
    Database db = await this.getDb();
    inseminacao.id = await db.insert("inseminacaoCaprino", inseminacao.toMap());
    return inseminacao;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM inseminacaoCaprino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("inseminacaoCaprino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM inseminacaoCaprino"));
  }

  Future<void> updateItem(InseminacaoCaprino inseminacao) async {
    Database db = await this.getDb();
    await db.update("inseminacaoCaprino", inseminacao.toMap(),
        where: "id = ?", whereArgs: [inseminacao.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM inseminacaoCaprino");
    List<InseminacaoCaprino> list = [];
    for (Map m in listMap) {
      list.add(InseminacaoCaprino.fromMap(m));
    }
    return list;
  }
}

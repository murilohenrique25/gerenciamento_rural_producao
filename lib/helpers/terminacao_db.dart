import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/terminacao.dart';
import 'package:sqflite/sqflite.dart';

class TerminacaoDB extends HelperDB {
  Terminacao terminacao;
  //Singleton
  //
  static TerminacaoDB _this;
  factory TerminacaoDB() {
    if (_this == null) {
      _this = TerminacaoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  TerminacaoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("terminacao",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<Terminacao> insert(Terminacao terminacao) async {
    Database db = await this.getDb();
    terminacao.id = await db.insert("terminacao", terminacao.toMap());
    return terminacao;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM terminacao orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("terminacao", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM terminacao"));
  }

  Future<void> updateItem(Terminacao terminacao) async {
    Database db = await this.getDb();
    await db.update("terminacao", terminacao.toMap(),
        where: "id = ?", whereArgs: [terminacao.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap =
        await db.rawQuery("SELECT * FROM terminacao WHERE mudar_plantel == 0");
    List<Terminacao> list = [];
    for (Map m in listMap) {
      list.add(Terminacao.fromMap(m));
    }
    return list;
  }
}

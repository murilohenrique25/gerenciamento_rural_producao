import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/pesagem_lote_caprina.dart';
import 'package:gerenciamento_rural/models/preco_carne_caprina.dart';
import 'package:sqflite/sqflite.dart';

class PesagemLoteCaprinaDB extends HelperDB {
  PrecoCarneCaprina precoCarneCaprina;
  //Singleton
  //
  static PesagemLoteCaprinaDB _this;
  factory PesagemLoteCaprinaDB() {
    if (_this == null) {
      _this = PesagemLoteCaprinaDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  PesagemLoteCaprinaDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("pesagemLoteCaprina",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<PesagemLoteCaprina> insert(
      PesagemLoteCaprina pesagemLoteCaprina) async {
    Database db = await this.getDb();
    pesagemLoteCaprina.id =
        await db.insert("pesagemLoteCaprina", pesagemLoteCaprina.toMap());
    return pesagemLoteCaprina;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM pesagemLoteCaprina orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("pesagemLoteCaprina", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM pesagemLoteCaprina"));
  }

  Future<void> updateItem(PesagemLoteCaprina pesagemLoteCaprina) async {
    Database db = await this.getDb();
    await db.update("pesagemLoteCaprina", pesagemLoteCaprina.toMap(),
        where: "id = ?", whereArgs: [pesagemLoteCaprina.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM pesagemLoteCaprina");
    List<PesagemLoteCaprina> list = [];
    for (Map m in listMap) {
      list.add(PesagemLoteCaprina.fromMap(m));
    }
    return list;
  }
}

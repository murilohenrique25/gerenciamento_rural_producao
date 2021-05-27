import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/jovem_femea_caprino.dart';
import 'package:sqflite/sqflite.dart';

class JovemFemeaCaprinoDB extends HelperDB {
  JovemFemeaCaprino jovemFemeaCaprino;
  //Singleton
  //
  static JovemFemeaCaprinoDB _this;
  factory JovemFemeaCaprinoDB() {
    if (_this == null) {
      _this = JovemFemeaCaprinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  JovemFemeaCaprinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("jovemFemea",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<JovemFemeaCaprino> insert(JovemFemeaCaprino jovemFemeaCaprino) async {
    Database db = await this.getDb();
    jovemFemeaCaprino.id =
        await db.insert("jovemFemea", jovemFemeaCaprino.toMap());
    return jovemFemeaCaprino;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM jovemFemea orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("jovemFemea", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM jovemFemea"));
  }

  Future<void> updateItem(JovemFemeaCaprino jovemFemeaCaprino) async {
    Database db = await this.getDb();
    await db.update("jovemFemea", jovemFemeaCaprino.toMap(),
        where: "id = ?", whereArgs: [jovemFemeaCaprino.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery(
        "SELECT * FROM jovemFemea WHERE situacao == 'Viva' AND virouAdulto == 0");
    List<JovemFemeaCaprino> list = [];
    for (Map m in listMap) {
      list.add(JovemFemeaCaprino.fromMap(m));
    }
    return list;
  }
}

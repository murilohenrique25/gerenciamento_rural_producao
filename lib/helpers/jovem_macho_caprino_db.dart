import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/jovem_macho_caprino.dart';
import 'package:sqflite/sqflite.dart';

class JovemMachoCaprinoDB extends HelperDB {
  JovemMachoCaprino jovemMachoCaprino;
  //Singleton
  //
  static JovemMachoCaprinoDB _this;
  factory JovemMachoCaprinoDB() {
    if (_this == null) {
      _this = JovemMachoCaprinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  JovemMachoCaprinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("reprodutor",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<JovemMachoCaprino> insert(JovemMachoCaprino jovemMachoCaprino) async {
    Database db = await this.getDb();
    jovemMachoCaprino.id =
        await db.insert("jovemMacho", jovemMachoCaprino.toMap());
    return jovemMachoCaprino;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM jovemMacho orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows = await db.delete("jovemMacho", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM jovemMacho"));
  }

  Future<void> updateItem(JovemMachoCaprino jovemMachoCaprino) async {
    Database db = await this.getDb();
    await db.update("jovemMacho", jovemMachoCaprino.toMap(),
        where: "id = ?", whereArgs: [jovemMachoCaprino.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery(
        "SELECT * FROM jovemMacho  WHERE situacao == 'Vivo' AND virouAdulto == 0");
    List<JovemMachoCaprino> list = [];
    for (Map m in listMap) {
      list.add(JovemMachoCaprino.fromMap(m));
    }
    return list;
  }
}

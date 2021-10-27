import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/novilha_corte.dart';
import 'package:sqflite/sqflite.dart';

class NovilhaCorteDB extends HelperDB {
  NovilhaCorte novilha;
  //Singleton
  //
  static NovilhaCorteDB _this;
  factory NovilhaCorteDB() {
    if (_this == null) {
      _this = NovilhaCorteDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  NovilhaCorteDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("novilhaCorte",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<NovilhaCorte> insert(NovilhaCorte bezerra) async {
    Database db = await this.getDb();
    bezerra.id = await db.insert("novilhaCorte", bezerra.toMap());
    return bezerra;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM novilhaCorte orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("novilhaCorte", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM novilhaCorte"));
  }

  ///<sumary>
  ///Método responsavel por atualizar item
  ///</sumary>
  ///<param name="bezerra"> Um tipo de animal.</param>
  Future<void> updateItem(NovilhaCorte novilhaCorte) async {
    Database db = await this.getDb();
    await db.update("novilhaCorte", novilhaCorte.toMap(),
        where: "id = ?", whereArgs: [novilhaCorte.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery(
        "SELECT * FROM novilhaCorte WHERE virou_adulto == 0 AND animal_abatido == 0 AND situacao == 'Viva'");
    List<NovilhaCorte> list = [];
    for (Map m in listMap) {
      list.add(NovilhaCorte.fromMap(m));
    }
    return list;
  }
}

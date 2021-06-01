import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/garrote_corte.dart';
import 'package:sqflite/sqflite.dart';

class GarroteCorteDB extends HelperDB {
  GarroteCorte garrote;
  //Singleton
  //
  static GarroteCorteDB _this;
  factory GarroteCorteDB() {
    if (_this == null) {
      _this = GarroteCorteDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  GarroteCorteDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("garroteCorte",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<GarroteCorte> insert(GarroteCorte bezerra) async {
    Database db = await this.getDb();
    bezerra.id = await db.insert("garroteCorte", bezerra.toMap());
    return bezerra;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM garroteCorte orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("garroteCorte", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM garroteCorte"));
  }

  ///<sumary>
  ///Método responsavel por atualizar item
  ///</sumary>
  ///<param name="bezerra"> Um tipo de animal.</param>
  Future<void> updateItem(GarroteCorte garroteCorte) async {
    Database db = await this.getDb();
    await db.update("garroteCorte", garroteCorte.toMap(),
        where: "id = ?", whereArgs: [garroteCorte.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap =
        await db.rawQuery("SELECT * FROM garroteCorte WHERE virouAdulto == 0");
    List<GarroteCorte> list = [];
    for (Map m in listMap) {
      list.add(GarroteCorte.fromMap(m));
    }
    return list;
  }
}

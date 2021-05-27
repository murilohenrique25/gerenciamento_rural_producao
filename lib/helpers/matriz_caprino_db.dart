import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/matriz_caprino.dart';
import 'package:sqflite/sqflite.dart';

class MatrizCaprinoDB extends HelperDB {
  MatrizCaprino matriz;
  //Singleton
  //
  static MatrizCaprinoDB _this;
  factory MatrizCaprinoDB() {
    if (_this == null) {
      _this = MatrizCaprinoDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  MatrizCaprinoDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("matrizCaprino",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<MatrizCaprino> insert(MatrizCaprino matriz) async {
    Database db = await this.getDb();
    matriz.id = await db.insert("matrizCaprino", matriz.toMap());
    return matriz;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM matrizCaprino orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("matrizCaprino", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM matrizCaprino"));
  }

  Future<void> updateItem(MatrizCaprino matriz) async {
    Database db = await this.getDb();
    await db.update("matrizCaprino", matriz.toMap(),
        where: "id = ?", whereArgs: [matriz.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM matrizCaprino");
    List<MatrizCaprino> list = [];
    for (Map m in listMap) {
      list.add(MatrizCaprino.fromMap(m));
    }
    return list;
  }
}

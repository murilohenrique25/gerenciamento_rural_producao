import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:sqflite/sqflite.dart';

abstract class HelperDB {
  Database _database;
  String get dbname;
  int get dbversion;

  Future<Database> init() async {
    if (this._database == null) {
      var databasesPath = await getDatabasesPath();
      String path = databasesPath + dbname;

      this._database = await openDatabase(path, version: dbversion,
          onCreate: (Database db, int version) async {
        //Cria as tabelas
        dbCreate.forEach((String sql) {
          db.execute(sql);
        });
        //   }, onUpgrade: (_database, oldVersion, newVersion) {
        //     if (oldVersion < newVersion){
        //     String sql = "DROP TABLE IF EXISTS " + TABLE_PROMOCOES;
        //     database.execSQL(sql);
        //     onCreate(database);
        // }

        //     }
      });
    }
    return this._database;
  }

  Future<Database> getDb() async {
    return await this.init();
  }

  Future<List> getAllItems();

  Future<List<Map>> list();

  Future<Map> getItem(dynamic where);

  Future<bool> delete(dynamic id);

  Future<int> getNumber();
}

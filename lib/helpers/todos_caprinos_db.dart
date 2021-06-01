import 'package:gerenciamento_rural/helpers/HelperDB.dart';
import 'package:gerenciamento_rural/helpers/application.dart';
import 'package:gerenciamento_rural/models/todoscaprino.dart';
import 'package:sqflite/sqflite.dart';

class TodosCaprinosDB extends HelperDB {
  TodosCaprino todosCaprino;
  //Singleton
  //
  static TodosCaprinosDB _this;
  factory TodosCaprinosDB() {
    if (_this == null) {
      _this = TodosCaprinosDB.getInstance();
    }
    return _this;
  }
  //
  //The instance
  TodosCaprinosDB.getInstance() : super();
  //

  @override
  String get dbname => dbName;

  @override
  int get dbversion => dbVersion;

  @override
  Future<Map> getItem(dynamic where) async {
    Database db = await this.getDb();
    List<Map> items = await db.query("todosCaprinos",
        where: "id = ?", whereArgs: [where], limit: 1);
    Map result = Map();
    if (items.isNotEmpty) {
      result = items.first;
    }
    return result;
  }

  Future<TodosCaprino> insert(TodosCaprino todos) async {
    Database db = await this.getDb();
    todos.id = await db.insert("todosCaprinos", todos.toMap());
    return todos;
  }

  @override
  Future<List<Map>> list() async {
    Database db = await this.getDb();
    return db.rawQuery("SELECT * FROM todosCaprinos orderBy id CRESC");
  }

  @override
  Future<bool> delete(dynamic id) async {
    Database db = await this.getDb();
    int rows =
        await db.delete("todosCaprinos", where: "id = ?", whereArgs: [id]);

    return (rows != 0);
  }

  Future<int> getNumber() async {
    Database db = await this.getDb();
    return Sqflite.firstIntValue(
        await db.rawQuery("SELECT COUNT(*) FROM todosCaprinos"));
  }

  Future<void> updateItem(TodosCaprino todos) async {
    Database db = await this.getDb();
    await db.update("todosCaprinos", todos.toMap(),
        where: "id = ?", whereArgs: [todos.id]);
  }

  Future<List> getAllItems() async {
    Database db = await this.getDb();
    List listMap = await db.rawQuery("SELECT * FROM todosCaprinos");
    List<TodosCaprino> list = [];
    for (Map m in listMap) {
      list.add(TodosCaprino.fromMap(m));
    }
    return list;
  }

  Future<List> getAllItemsPorLote(String where) async {
    Database db = await this.getDb();
    List listMap =
        await db.rawQuery("SELECT * FROM todosCaprinos WHERE lote == '$where'");
    List<TodosCaprino> list = [];
    for (Map m in listMap) {
      list.add(TodosCaprino.fromMap(m));
    }
    return list;
  }
}

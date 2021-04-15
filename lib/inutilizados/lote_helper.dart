// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// final String loteTable = "loteTable";
// final String idColumn = "idColumn";
// final String nameColumn = "nameColumn";
// final String codigoExternoColumn = "codigoExternoColumn";

// class LoteHelper {
//   static final LoteHelper _instance = LoteHelper.internal();

//   factory LoteHelper() => _instance;

//   LoteHelper.internal();

//   Database _db;

//   Future<Database> get db async {
//     if (_db != null) {
//       return _db;
//     } else {
//       _db = await initDb();
//       return _db;
//     }
//   }

//   Future<Database> initDb() async {
//     final databasesPath = await getDatabasesPath();
//     final path = join(databasesPath, 'gr01.db');

//     return await openDatabase(path, version: 1,
//         onCreate: (Database db, int newerVersion) async {
//       await db.execute(
//           "CREATE TABLE $loteTable($idColumn INTEGER PRIMARY KEY, $nameColumn TEXT, $codigoExternoColumn TEXT)");
//     });
//   }

//   Future<Lote> saveLote(Lote lote) async {
//     Database dbLote = await db;
//     lote.id = await dbLote.insert(loteTable, lote.toMap());
//     return lote;
//   }

//   Future<Lote> getLote(int id) async {
//     Database dbLote = await db;
//     List<Map> maps = await dbLote.query(loteTable,
//         columns: [idColumn, nameColumn, codigoExternoColumn],
//         where: "$idColumn = ?",
//         whereArgs: [id]);
//     if (maps.length > 0) {
//       return Lote.fromMap(maps.first);
//     } else {
//       return null;
//     }
//   }

//   Future<int> deleteLote(int id) async {
//     Database dbLote = await db;
//     return await dbLote
//         .delete(loteTable, where: "$idColumn = ?", whereArgs: [id]);
//   }

//   Future<int> updateLote(Lote lote) async {
//     Database dbLote = await db;
//     return await dbLote.update(loteTable, lote.toMap(),
//         where: "$idColumn = ?", whereArgs: [lote.id]);
//   }

//   Future<List> getAllLotes() async {
//     Database dbLote = await db;
//     List listMap = await dbLote.rawQuery("SELECT * FROM $loteTable");
//     List<Lote> listLote = [];
//     for (Map m in listMap) {
//       listLote.add(Lote.fromMap(m));
//     }
//     return listLote;
//   }

//   Future<int> getNumber() async {
//     Database dbLote = await db;
//     return Sqflite.firstIntValue(
//         await dbLote.rawQuery("SELECT COUNT(*) FROM $loteTable"));
//   }

//   Future close() async {
//     Database dbLote = await db;
//     dbLote.close();
//   }
// }

// class Lote {
//   int id;
//   String name;
//   String codigoExterno;

//   Lote();
//   Lote.fromMap(Map map) {
//     id = map[idColumn];
//     name = map[nameColumn];
//     codigoExterno = map[codigoExternoColumn];
//   }

//   Map toMap() {
//     Map<String, dynamic> map = {
//       nameColumn: name,
//       codigoExternoColumn: codigoExterno
//     };
//     if (id != null) {
//       map[idColumn] = id;
//     }
//     return map;
//   }

//   @override
//   String toString() {
//     return "Lote(id:$id, name: $name, codigoExterno : $codigoExterno)";
//   }
// }

// import 'dart:async';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';

// final String producaoLeiteTable = "producaoLeiteTable";
// final String idColumn = "idColumn";
// final String dataColetaColumn = "dataColetaColumn";
// final String quantidadeColumn = "quantidadeColumn";
// final String gorduraColumn = "gorduraColumn";
// final String proteinaColumn = "proteinaColumn";
// final String lactoseColumn = "lactoseColumn";
// final String ureiaColumn = "ureiaColumn";

// class ProducaoLeiteHelper {
//   static final ProducaoLeiteHelper _instance = ProducaoLeiteHelper.internal();

//   factory ProducaoLeiteHelper() => _instance;

//   ProducaoLeiteHelper.internal();

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

//     return await openDatabase(
//       path,
//       version: 1,
//       onUpgrade: (Database db, int oldVersion, int newVersion) async {
//         await db.execute(
//             "CREATE TABLE $producaoLeiteTable($idColumn INTEGER PRIMARY KEY, $dataColetaColumn TEXT, $quantidadeColumn REAL" +
//                 "$gorduraColumn REAL, $proteinaColumn REAL, $lactoseColumn REAL, $ureiaColumn REAL)");
//       },
//     );
//   }

//   Future<ProducaoLeite> saveProducaoLeite(ProducaoLeite producaoLeite) async {
//     Database dbProducaoLeite = await db;
//     producaoLeite.id =
//         await dbProducaoLeite.insert(producaoLeiteTable, producaoLeite.toMap());
//     return producaoLeite;
//   }

//   Future<ProducaoLeite> getProducaoLeite(int id) async {
//     Database dbProducaoLeite = await db;
//     List<Map> maps = await dbProducaoLeite.query(producaoLeiteTable,
//         columns: [
//           idColumn,
//           dataColetaColumn,
//           quantidadeColumn,
//           gorduraColumn,
//           proteinaColumn,
//           lactoseColumn,
//           ureiaColumn
//         ],
//         where: "$idColumn = ?",
//         whereArgs: [id]);
//     if (maps.length > 0) {
//       return ProducaoLeite.fromMap(maps.first);
//     } else {
//       return null;
//     }
//   }

//   Future<int> deleteProducaoLeite(int id) async {
//     Database dbProducaoLeite = await db;
//     return await dbProducaoLeite
//         .delete(producaoLeiteTable, where: "$idColumn = ?", whereArgs: [id]);
//   }

//   Future<int> updateProducaoLeite(ProducaoLeite producaoLeite) async {
//     Database dbProducaoLeite = await db;
//     return await dbProducaoLeite.update(
//         producaoLeiteTable, producaoLeite.toMap(),
//         where: "$idColumn = ?", whereArgs: [producaoLeite.id]);
//   }

//   Future<List> getAllProducaoLeites() async {
//     Database dbProducaoLeite = await db;
//     List listMap =
//         await dbProducaoLeite.rawQuery("SELECT * FROM $producaoLeiteTable");
//     List<ProducaoLeite> listProducaoLeite = List();
//     for (Map m in listMap) {
//       listProducaoLeite.add(ProducaoLeite.fromMap(m));
//     }
//     return listProducaoLeite;
//   }

//   Future<int> getNumber() async {
//     Database dbProducaoLeite = await db;
//     return Sqflite.firstIntValue(await dbProducaoLeite
//         .rawQuery("SELECT COUNT(*) FROM $producaoLeiteTable"));
//   }

//   Future close() async {
//     Database dbProducaoLeite = await db;
//     dbProducaoLeite.close();
//   }
// }

// // class ProducaoLeite {
// //   int id;
// //   DateTime dataColeta;
// //   double quantidade;
// //   double gordura;
// //   double proteina;
// //   double lactose;
// //   double ureia;

// //   ProducaoLeite();
// //   ProducaoLeite.fromMap(Map map) {
// //     id = map[idColumn];
// //     dataColeta = map[dataColetaColumn];
// //     quantidade = map[quantidadeColumn];
// //     gordura = map[gorduraColumn];
// //     proteina = map[proteinaColumn];
// //     lactose = map[lactoseColumn];
// //     ureia = map[ureiaColumn];
// //   }

// //   Map toMap() {
// //     Map<String, dynamic> map = {
// //       dataColetaColumn: dataColeta,
// //       quantidadeColumn: quantidade,
// //       gorduraColumn: gordura,
// //       proteinaColumn: proteina,
// //       lactoseColumn: lactose,
// //       ureiaColumn: ureia
// //     };
// //     if (id != null) {
// //       map[idColumn] = id;
// //     }
// //     return map;
// //   }

// //   @override
// //   String toString() {
// //     return "ProducaoLeite(id:$id, dataColetaColumn: $dataColeta, quantidade: $quantidade, " +
// //         "gordura:$gordura, proteina:$proteina, lactose: $lactose, ureia: $ureia)";
// //   }
// // }

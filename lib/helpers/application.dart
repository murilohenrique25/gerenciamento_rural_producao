String dbName = 'gerenciabovi.db';
int dbVersion = 1;

List<String> dbCreate = [
  //tb lote
  """CREATE TABLE loteTable(
    id_lote INTEGER PRIMARY KEY, 
    name TEXT, 
    codigoExterno INTEGER
    )""",
  //tb producaoleite
  """CREATE TABLE producaoLeiteTable(
    id_prod_leite INTEGER PRIMARY KEY, 
    dataColeta TEXT, 
    quantidade REAL, 
    gordura REAL, 
    proteina REAL, 
    lactose REAL, 
    ureia REAL,
    ccs REAL,
    cbt REAL
    )"""
];

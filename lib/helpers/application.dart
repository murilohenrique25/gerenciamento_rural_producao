String dbName = '07022021final1.db';
int dbVersion = 1;

List<String> dbCreate = [
  //tb lote
  """CREATE TABLE loteTable(
    id_lote INTEGER PRIMARY KEY, 
    name TEXT, 
    quantidade INTEGER
    )""",
  //tb producaoleite
  """CREATE TABLE leiteTable(
    id_leite INTEGER PRIMARY KEY, 
    dataColeta TEXT, 
    quantidade REAL, 
    gordura REAL, 
    proteina REAL, 
    lactose REAL, 
    ureia REAL,
    ccs REAL,
    cbt REAL,
    idMes INTEGER
    )""",
  //tb Vaca
  """CREATE TABLE vaca(
    idVaca INTEGER PRIMARY KEY, 
    nome TEXT,
    ultimaInseminacao TEXT, 
    raca TEXT, 
    idLote INTEGER,
    estado TEXT,
    pai TEXT,
    mae TEXT,
    avoMMaterno TEXT,
    avoFMaterno TEXT,
    avoMPaterno TEXT,
    avoFPaterno TEXT
    )""",
  //tb NOVILHA
  """CREATE TABLE novilha(
    idNovilha INTEGER PRIMARY KEY, 
    nome TEXT,
    raca TEXT,
    pesoNascimento REAL, 
    pesoDesmama REAL, 
    idLote INTEGER,
    dataDesmama TEXT,
    dataCobertura TEXT,
    pesoPrimeiraCobertura REAL,
    idadePrimeiraCobertura REAL,
    idadePrimeiroParto REAL,
    diagnosticoGestacao TEXT,
    pai TEXT,
    mae TEXT,
    avoMMaterno TEXT,
    avoFMaterno TEXT,
    avoMPaterno TEXT,
    avoFPaterno TEXT
    )""",
  //tb BEZERRA
  """CREATE TABLE bezerra(
    idBezerra INTEGER PRIMARY KEY, 
    nome TEXT,
    raca TEXT,
    dataNascimento TEXT,
    pesoNascimento REAL, 
    pesoDesmama REAL, 
    idLote INTEGER,
    dataDesmama TEXT,
    pai TEXT,
    mae TEXT,
    avoMMaterno TEXT,
    avoFMaterno TEXT,
    avoMPaterno TEXT,
    avoFPaterno TEXT
    )""",
  //tabela inventario semen
  """CREATE TABLE inventarioSemen(
      id_inventario INTEGER PRIMARY KEY,
      codigoIA TEXT,
      tamanho TEXT,
      quantidade INTEGER,
      cor TEXT,
      id_touro INTEGER,
      CONSTRAINT fk_invenTouro FOREIGN KEY (id_touro) REFERENCES touro(id_touro) 
    )""",
  //tabela touro
  """CREATE TABLE touro(
      idTouro INTEGER PRIMARY KEY,
      nome TEXT,
      raca TEXT,
      dataNascimento TEXT,
      estado TEXT,
      pai TEXT,
      mae TEXT,
      avoMMaterno TEXT,
      avoFMaterno TEXT,
      avoMPaterno TEXT,
      avoFPaterno TEXT
     )"""
];

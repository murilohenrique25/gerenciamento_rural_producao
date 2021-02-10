String dbName = 'new090220215.db';
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
    dataNascimento TEXT,
    partoPrevisto TEXT,
    secagemPrevista TEXT, 
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
      idTouro INTEGER,
      nomeTouro TEXT,
      dataCadastro TEXT,
      FOREIGN KEY (idTouro) REFERENCES touro(idTouro) 
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

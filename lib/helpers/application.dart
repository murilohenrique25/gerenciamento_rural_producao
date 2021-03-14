String dbName = 'final09032021.db';
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
    diagnosticoGestacao TEXT,
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
    dataNascimento TEXT,
    dataDesmama TEXT,
    dataCobertura TEXT,
    pesoPrimeiraCobertura REAL,
    idadePrimeiraCobertura REAL,
    idadePrimeiroParto REAL,
    diagnosticoGestacao TEXT,
    estado TEXT,
    pai TEXT,
    mae TEXT,
    avoMMaterno TEXT,
    avoFMaterno TEXT,
    avoMPaterno TEXT,
    avoFPaterno TEXT,
    virouVaca INTEGER
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
    avoFPaterno TEXT,
    virouNovilha INTEGER,
    estado TEXT
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
     )""",
  //tabela gasto
  """CREATE TABLE gasto(
      id INTEGER PRIMARY KEY,
      nome TEXT,
      data TEXT,
      quantidade INTEGER,
      observacao TEXT,
      valorUnitario REAL,
      valorTotal REAL
     )""",
  //tabela medicamento
  """CREATE TABLE medicamento(
      id INTEGER PRIMARY KEY,
      nomeMedicamento TEXT,
      quantidade REAL,
      precoUnitario REAL,
      precoTotal REAL,
      tempoDescarteLeite TEXT,
      tipoDosagem TEXT,
      carenciaMedicamento TEXT,
      dataVencimento TEXT,
      fornecedor TEXT,
      dataAbertura TEXT,
      dataCompra TEXT,
      principioAtivo TEXT,
      observacao TEXT
     )""",
  //tb precoLeite
  """CREATE TABLE precoLeite(
    id INTEGER PRIMARY KEY, 
    data TEXT, 
    preco REAL
    )""",
  //tb insemincacao
  """CREATE TABLE inseminacao(
    id INTEGER PRIMARY KEY, 
    idVaca INTEGER, 
    nomeVaca TEXT,
    idSemen INTEGER,
    nomeTouro TEXT,
    data TEXT,
    observacao TEXT,
    inseminador TEXT
    )""",
  //tb tratamento
  """CREATE TABLE tratamento(
    id INTEGER PRIMARY KEY,
    lote TEXT,
    idVaca INTEGER, 
    nomeVaca TEXT,
    enfermidade TEXT,
    idMedicamento INTEGER,
    quantidade REAL,
    nomeMedicamento TEXT,
    unidade TEXT,
    viaAplicacao TEXT,
    duracao TEXT,
    inicioTratamento TEXT,
    fimTratamento TEXT,
    carencia TEXT,
    observacao TEXT,
    tipo INTEGER,
    FOREIGN KEY (idMedicamento) REFERENCES medicamento(id) 
    )""",
  //tb volumoso
  """CREATE TABLE nutricaoVolumoso(
    id INTEGER PRIMARY KEY,
    id_lote INTEGER,
    nome_lote TEXT,
    tipo TEXT,
    pb REAL,
    ndt REAL,
    ms REAL,
    umidade REAL,
    quantidade_individual REAL,
    quantidade_total REAL,
    observacao TEXT,
    data TEXT,
    FOREIGN KEY (id_lote) REFERENCES loteTable(id_lote) 
  )""",
  //tb volumoso
  """CREATE TABLE nutricaoConcentrado(
    id INTEGER PRIMARY KEY,
    id_lote INTEGER,
    nome_lote TEXT,
    ingredientes TEXT,
    pb REAL,
    ndt REAL,
    quantidade_individual REAL,
    quantidade_total REAL,
    observacao TEXT,
    data TEXT,
    FOREIGN KEY (id_lote) REFERENCES loteTable(id_lote) 
  )""",
  //tb volumoso
  """CREATE TABLE nutricaoSuplementar(
    id INTEGER PRIMARY KEY,
    id_lote INTEGER,
    nome_lote TEXT,
    ingredientes TEXT,
    quantidade_individual REAL,
    quantidade_total REAL,
    observacao TEXT,
    data TEXT,
    FOREIGN KEY (id_lote) REFERENCES loteTable(id_lote) 
  )"""
];

String dbName = 'final0204.db';
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
  )""",
  //TB historicoPartoSuino
  """CREATE TABLE historicoPartoSuino(
  id INTEGER PRIMARY KEY,
  ninhada TEXT,
  data_nascimento TEXT,
  quantidade INTEGER,
  vivos TEXT,
  mortos TEXT,
  pai TEXT,
  mae TEXT,
  sexoF TEXT,
  sexoM TEXT
  )""",
  //TB aleitamento
  """CREATE TABLE aleitamento(
  id INTEGER PRIMARY KEY,
  id_animal INTEGER,
  nome TEXT,
  data_nascimento TEXT,
  quantidade INTEGER,
  estado TEXT,
  lote TEXT,
  identificacao TEXT,
  vivos TEXT,
  mortos TEXT,
  raca TEXT,
  pai TEXT,
  mae TEXT,
  sexoF TEXT,
  sexoM TEXT,
  baia TEXT,
  peso_nascimento TEXT,
  peso_desmama TEXT,
  data_desmama TEXT,
  mudar_plantel INTEGER,
  observacao TEXT
  )""",

  //TB creche
  """CREATE TABLE creche(
  id INTEGER PRIMARY KEY,
  id_animal INTEGER,
  nome TEXT,
  data_nascimento TEXT,
  quantidade INTEGER,
  estado TEXT,
  lote TEXT,
  identificacao TEXT,
  vivos TEXT,
  mortos TEXT,
  raca TEXT,
  pai TEXT,
  mae TEXT,
  sexoF TEXT,
  sexoM TEXT,
  baia TEXT,
  peso_nascimento TEXT,
  peso_desmama TEXT,
  data_desmama TEXT,
  mudar_plantel INTEGER,
  observacao TEXT
  )""",
  //TB terminacao
  """CREATE TABLE terminacao(
  id INTEGER PRIMARY KEY,
  id_animal INTEGER,
  nome TEXT,
  data_nascimento TEXT,
  quantidade INTEGER,
  estado TEXT,
  lote TEXT,
  identificacao TEXT,
  vivos TEXT,
  mortos TEXT,
  raca TEXT,
  pai TEXT,
  mae TEXT,
  sexoF TEXT,
  sexoM TEXT,
  baia TEXT,
  peso_nascimento TEXT,
  peso_desmama TEXT,
  data_desmama TEXT,
  observacao TEXT,
  data_abate TEXT,
  mudar_plantel INTEGER,
  peso_abate REAL,
  peso_medio REAL
  )""",

  //TB abatido
  """CREATE TABLE abatido(
  id INTEGER PRIMARY KEY,
  id_animal INTEGER,
  nome TEXT,
  data_nascimento TEXT,
  quantidade INTEGER,
  estado TEXT,
  lote TEXT,
  identificacao TEXT,
  vivos TEXT,
  mortos TEXT,
  raca TEXT,
  pai TEXT,
  mae TEXT,
  sexoF TEXT,
  sexoM TEXT,
  baia TEXT,
  peso_nascimento TEXT,
  peso_desmama TEXT,
  data_desmama TEXT,
  observacao TEXT,
  data_abate TEXT,
  mudar_plantel INTEGER,
  peso_abate REAL,
  peso_medio REAL
  )""",
  //TB cachaco
  """CREATE TABLE cachaco(
  id_animal INTEGER PRIMARY KEY,
  nome_animal TEXT,
  data_nascimento TEXT,
  estado TEXT,
  lote TEXT,
  identificacao TEXT,
  raca TEXT,
  pai TEXT,
  mae TEXT,
  baia TEXT,
  peso double,
  origem TEXT,
  observacao TEXT
  )""",
  //TB matriz
  """CREATE TABLE matriz(
  id_animal INTEGER PRIMARY KEY,
  nome_animal TEXT,
  data_nascimento TEXT,
  estado TEXT,
  lote TEXT,
  identificacao TEXT,
  raca TEXT,
  pai TEXT,
  mae TEXT,
  baia TEXT,
  peso TEXT,
  origem TEXT,
  numero_partos INTEGER,
  parto_previsto TEXT,
  diagnostico_gestacao TEXT,
  dias_prenha INTEGER
  )""",
  //tabela medicamentoSuino
  """CREATE TABLE medicamentoSuino(
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
  //tb tratamentoSuino
  """CREATE TABLE tratamentoSuino(
    id INTEGER PRIMARY KEY,
    lote TEXT,
    idAnimal INTEGER, 
    nomeAnimal TEXT,
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
    FOREIGN KEY (idMedicamento) REFERENCES medicamentoSuino(id) 
    )""",
  //tb insemincaoSuina
  """CREATE TABLE inseminacaoSuina(
      id INTEGER PRIMARY KEY,
      id_matriz INTEGER,
      nome_matriz TEXT,
      id_semen INTEGER,
      nome_cachaco TEXT,
      data TEXT,
      observacao TEXT,
      inseminador TEXT,
      tipo_reproducao TEXT,
      palheta TEXT
    )""",
  //tb inventarioSemenSuina
  """CREATE TABLE inventarioSemenSuina(
      id INTEGER PRIMARY KEY,
      id_cachaco INTEGER,
      nome_cachaco TEXT,
      identificao TEXT,
      quantidade INTEGER,
      cor TEXT,
      data_cadastro TEXT,
      data_validade TEXT,
      observacao TEXT,
      vigor TEXT,
      mortalidade TEXT,
      turbilhamento TEXT,
      concentracao TEXT,
      volume REAL,
      aspecto TEXT,
      celulas_normais REAL,
      defeito_maiores TEXT,
      defeito_menores TEXT
    )""",
  //tb precoCarneSuina
  """CREATE TABLE precoCarneSuina(
    id INTEGER PRIMARY KEY, 
    data TEXT, 
    preco REAL
    )""",
  //tb producaoCarneSuina
  """CREATE TABLE producaoCarneSuina(
    id INTEGER PRIMARY KEY, 
    data TEXT, 
    preco REAL,
    quantidade REAL,
    total REAL
    )""",
  //tb nutricaosuina
  """CREATE TABLE nutricaoSuina(
    id INTEGER PRIMARY KEY,
    nome_lote TEXT,
    fase TEXT,
    pb REAL,
    ndt REAL,
    ed REAL,
    baia TEXT,
    quantidade_individual REAL,
    quantidade_total REAL,
    quantidade_animais REAL,
    ingredientes TEXT,
    data TEXT 
  )""",
  //tabela gasto
  """CREATE TABLE gastoSuino(
      id INTEGER PRIMARY KEY,
      nome TEXT,
      data TEXT,
      quantidade INTEGER,
      observacao TEXT,
      valorUnitario REAL,
      valorTotal REAL
     )""",
];

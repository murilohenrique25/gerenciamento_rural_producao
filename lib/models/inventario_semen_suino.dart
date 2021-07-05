class InventarioSemenSuina {
  int id;
  int idCachaco;
  String nomeCachaco;
  String identificacao;
  int quantidade;
  String cor;
  String dataCadastro;
  String dataValidade;
  String observacao;
  String vigor;
  String mortalidade;
  String turbilhamento;
  String concentracao;
  double volume;
  String aspecto;
  double celulasNormais;
  String defeitoMaiores;
  String defeitoMenores;

  InventarioSemenSuina();
  InventarioSemenSuina.fromMap(Map map) {
    id = map["id"];
    idCachaco = map["id_cachaco"];
    nomeCachaco = map["nome_cachaco"];
    identificacao = map["identificacao"];
    quantidade = map["quantidade"];
    cor = map["cor"];
    dataCadastro = map["data_cadastro"];
    dataValidade = map["data_validade"];
    observacao = map["observacao"];
    vigor = map["vigor"];
    mortalidade = map["mortalidade"];
    turbilhamento = map["turbilhamento"];
    concentracao = map["concentracao"];
    volume = map["volume"];
    aspecto = map["aspecto"];
    celulasNormais = map["celulas_normais"];
    defeitoMaiores = map["defeito_maiores"];
    defeitoMenores = map["defeito_menores"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "id_cachaco": idCachaco,
      "nome_cachaco": nomeCachaco,
      "identificacao": identificacao,
      "quantidade": quantidade,
      "cor": cor,
      "data_cadastro": dataCadastro,
      "data_validade": dataValidade,
      "observacao": observacao,
      "vigor": vigor,
      "mortalidade": mortalidade,
      "turbilhamento": turbilhamento,
      "concentracao": concentracao,
      "volume": volume,
      "aspecto": aspecto,
      "celulas_normais": celulasNormais,
      "defeito_maiores": defeitoMaiores,
      "defeito_menores": defeitoMenores,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Inventario(id:$id, touro: $idCachaco, Quantidade : $quantidade)";
  }
}

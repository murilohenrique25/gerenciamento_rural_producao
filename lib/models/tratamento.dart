class Tratamento {
  int id;
  int idAnimal;
  String nomeAnimal;
  String lote;
  String enfermidade;
  int idMedicamento;
  String nomeMedicamento;
  String unidade;
  double quantidade;
  String viaAplicacao;
  String duracao;
  String inicioTratamento;
  String fimTratamento;
  String carencia;
  String observacao;
  int tipo;

  Tratamento();
  Tratamento.fromMap(Map map) {
    id = map["id"];
    idAnimal = map["idAnimal"];
    nomeAnimal = map["nomeAnimal"];
    lote = map["lote"];
    enfermidade = map["enfermidade"];
    idMedicamento = map["idMedicamento"];
    nomeMedicamento = map["nomeMedicamento"];
    unidade = map["unidade"];
    quantidade = map["quantidade"];
    viaAplicacao = map["viaAplicacao"];
    duracao = map["duracao"];
    inicioTratamento = map["inicioTratamento"];
    fimTratamento = map["fimTratamento"];
    carencia = map["carencia"];
    observacao = map["observacao"];
    tipo = map["tipo"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "idAnimal": idAnimal,
      "nomeAnimal": nomeAnimal,
      "lote": lote,
      "enfermidade": enfermidade,
      "idMedicamento": idMedicamento,
      "nomeMedicamento": nomeMedicamento,
      "unidade": unidade,
      "quantidade": quantidade,
      "viaAplicacao": viaAplicacao,
      "duracao": duracao,
      "inicioTratamento": inicioTratamento,
      "fimTratamento": fimTratamento,
      "carencia": carencia,
      "observacao": observacao,
      "tipo": tipo
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}

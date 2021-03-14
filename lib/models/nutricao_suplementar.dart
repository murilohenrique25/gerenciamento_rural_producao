class NutricaoSuplementar {
  int id;
  int idLote;
  String nomeLote;
  String ingredientes;
  double quantidadeInd;
  double quantidadeTotal;
  String observacao;
  String data;

  NutricaoSuplementar();
  NutricaoSuplementar.fromMap(Map map) {
    id = map["id"];
    idLote = map["id_lote"];
    nomeLote = map["nome_lote"];
    ingredientes = map["ingredientes"];
    quantidadeInd = map["quantidade_individual"];
    quantidadeTotal = map["quantidade_total"];
    observacao = map["observacao"];
    data = map["data"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "id_lote": idLote,
      "nome_lote": nomeLote,
      "ingredientes": ingredientes,
      "quantidade_individual": quantidadeInd,
      "quantidade_total": quantidadeTotal,
      "observacao": observacao,
      "data": data,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}

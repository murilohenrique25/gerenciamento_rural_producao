class NutricaoVolumoso {
  int id;
  int idLote;
  String nomeLote;
  String tipo;
  double quantidadeInd;
  double quantidadeTotal;
  double pb;
  double ndt;
  double ms;
  double umidade;
  String observacao;
  String data;

  NutricaoVolumoso();
  NutricaoVolumoso.fromMap(Map map) {
    id = map["id"];
    idLote = map["id_lote"];
    nomeLote = map["nome_lote"];
    tipo = map["tipo"];
    pb = map["pb"];
    ndt = map["ndt"];
    ms = map["ms"];
    umidade = map["umidade"];
    quantidadeInd = map["quantidade_individual"];
    quantidadeTotal = map["quantidade_total"];
    observacao = map["observacao"];
    data = map["data"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "id_lote": idLote,
      "nome_lote": nomeLote,
      "tipo": tipo,
      "pb": pb,
      "ndt": ndt,
      "ms": ms,
      "umidade": umidade,
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

class NutricaoConcentrado {
  int id;
  int idLote;
  String nomeLote;
  String ingredientes;
  double quantidadeInd;
  double quantidadeTotal;
  double pb;
  double ndt;
  String observacao;
  String data;
  String baia;
  NutricaoConcentrado();
  NutricaoConcentrado.fromMap(Map map) {
    id = map["id"];
    idLote = map["id_lote"];
    nomeLote = map["nome_lote"];
    ingredientes = map["ingredientes"];
    pb = map["pb"];
    ndt = map["ndt"];
    quantidadeInd = map["quantidade_individual"];
    quantidadeTotal = map["quantidade_total"];
    observacao = map["observacao"];
    data = map["data"];
    baia = map["baia"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "id_lote": idLote,
      "nome_lote": nomeLote,
      "ingredientes": ingredientes,
      "pb": pb,
      "ndt": ndt,
      "quantidade_individual": quantidadeInd,
      "quantidade_total": quantidadeTotal,
      "observacao": observacao,
      "data": data,
      "baia": baia,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "$idLote\n $nomeLote\n $ingredientes\n $pb\n $ndt\n $quantidadeInd\n " +
        "$quantidadeTotal\n $observacao\n $data";
  }
}

class NutricaoSuina {
  int id;
  String nomeLote;
  String fase;
  String ingredientes;
  String baia;
  double quantidadeInd;
  double quantidadeTotal;
  double pb;
  double ndt;
  double ed;
  double quantidadeAnimais;
  String data;

  NutricaoSuina();
  NutricaoSuina.fromMap(Map map) {
    id = map["id"];
    nomeLote = map["nome_lote"];
    fase = map["fase"];
    ingredientes = map["ingredientes"];
    baia = map["baia"];
    pb = map["pb"];
    ndt = map["ndt"];
    ed = map["ed"];
    quantidadeInd = map["quantidade_individual"];
    quantidadeTotal = map["quantidade_total"];
    quantidadeAnimais = map["quantidade_animais"];
    data = map["data"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "nome_lote": nomeLote,
      "ingredientes": ingredientes,
      "fase": fase,
      "baia": baia,
      "pb": pb,
      "ndt": ndt,
      "ed": ed,
      "quantidade_individual": quantidadeInd,
      "quantidade_total": quantidadeTotal,
      "quantidade_animais": quantidadeAnimais,
      "data": data,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}

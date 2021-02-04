class Leite {
  int id;
  String dataColeta;
  double quantidade;
  double gordura;
  double proteina;
  double lactose;
  double ureia;
  double ccs;
  double cbt;
  int idMes;

  Leite();
  Leite.fromMap(Map map) {
    id = map["id_leite"];
    dataColeta = map["dataColeta"];
    quantidade = map["quantidade"];
    gordura = map["gordura"];
    proteina = map["proteina"];
    lactose = map["lactose"];
    ureia = map["ureia"];
    ccs = map["ccs"];
    cbt = map["cbt"];
    idMes = map["idMes"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "dataColeta": dataColeta,
      "quantidade": quantidade,
      "gordura": gordura,
      "proteina": proteina,
      "lactose": lactose,
      "ureia": ureia,
      "ccs": ccs,
      "cbt": cbt,
      "idMes": idMes
    };
    if (id != null) {
      map["id_leite"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "ProducaoLeite(id:$id, dataColeta: $dataColeta, quantidade: $quantidade, " +
        "gordura:$gordura, proteina:$proteina, lactose: $lactose, ureia: $ureia, ccs:$ccs, cbt: $cbt, idMes: $idMes)";
  }
}

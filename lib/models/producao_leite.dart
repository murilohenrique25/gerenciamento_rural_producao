class ProducaoLeite {
  int id;
  String dataColeta;
  double quantidade;
  double gordura;
  double proteina;
  double lactose;
  double ureia;
  double ccs;
  double cbt;

  ProducaoLeite();
  ProducaoLeite.fromMap(Map map) {
    id = map["id_prod_leite"];
    dataColeta = map["dataColeta"];
    quantidade = map["quantidade"];
    gordura = map["gordura"];
    proteina = map["proteina"];
    lactose = map["lactose"];
    ureia = map["ureia"];
    ccs = map["ccs"];
    cbt = map["cbt"];
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
      "cbt": cbt
    };
    if (id != null) {
      map["id_prod_leite"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "ProducaoLeite(id:$id, dataColeta: $dataColeta, quantidade: $quantidade, " +
        "gordura:$gordura, proteina:$proteina, lactose: $lactose, ureia: $ureia, ccs:$ccs, cbt: $cbt)";
  }
}

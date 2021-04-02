class ProducaoCarneSuina {
  int id;
  String data;
  double quantidade;
  double preco;
  double total;

  ProducaoCarneSuina();
  ProducaoCarneSuina.fromMap(Map map) {
    id = map["id"];
    data = map["data"];
    quantidade = map["quantidade"];
    preco = map["preco"];
    total = map["total"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "data": data,
      "quantidade": quantidade,
      "preco": preco,
      "total": total,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "ProducaoCarneSuina(id:$id, quantidade: $quantidade, data : $data)";
  }
}

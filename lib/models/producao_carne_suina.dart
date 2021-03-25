class ProducaoCarneSuina {
  int id;
  String data;
  double quantidade;
  double preco;

  ProducaoCarneSuina();
  ProducaoCarneSuina.fromMap(Map map) {
    id = map["id"];
    data = map["data"];
    quantidade = map["quantidade"];
    preco = map["preco"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "data": data,
      "quantidade": quantidade,
      "preco": preco,
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

class RegistroPartoBC {
  int id;
  String nomeVaca;
  String nomeTouro;
  String data;
  int quantidade;
  int quantMachos;
  int quantFemeas;
  String problema;
  String tipoInseminacao;
  double totalPartos;

  RegistroPartoBC();
  RegistroPartoBC.fromMap(Map map) {
    id = map["id"];
    nomeVaca = map["nome_vaca"];
    nomeTouro = map["nome_touro"];
    data = map["data"];
    quantidade = map["quantidade"];
    quantMachos = map["quant_machos"];
    quantFemeas = map["quant_femeas"];
    problema = map["problema"];
    tipoInseminacao = map["tipo_inseminacao"];
    totalPartos = map["total_partos"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "nome_vaca": nomeVaca,
      "nome_touro": nomeTouro,
      "quantidade": quantidade,
      "quant_machos": quantMachos,
      "quant_femeas": quantFemeas,
      "problema": problema,
      "data": data,
      "tipo_inseminacao": tipoInseminacao,
      "total_partos": totalPartos,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "RegistroPartos(id:$id, Descricao: $nomeTouro, codigoExterno : $quantidade)";
  }
}

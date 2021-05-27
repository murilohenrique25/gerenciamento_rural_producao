class RegistroPartoCaprino {
  int id;
  String nomeMatriz;
  String nomeReprodutor;
  String data;
  int quantidade;
  int quantMachos;
  int quantFemeas;
  String problema;
  String tipoInseminacao;
  double totalPartos;

  RegistroPartoCaprino();
  RegistroPartoCaprino.fromMap(Map map) {
    id = map["id"];
    nomeMatriz = map["nome_matriz"];
    nomeReprodutor = map["nome_reprodutor"];
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
      "nome_matriz": nomeMatriz,
      "nome_reprodutor": nomeReprodutor,
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
    return "RegistroPartos(id:$id, Descricao: $nomeMatriz, codigoExterno : $quantidade)";
  }
}

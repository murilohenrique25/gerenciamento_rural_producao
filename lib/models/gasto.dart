class Gasto {
  int id;
  String nome;
  double valorUnitario;
  int quantidade;
  String observacao;
  double valorTotal;
  String data;

  Gasto();
  Gasto.fromMap(Map map) {
    id = map["id"];
    nome = map["nome"];
    quantidade = map["quantidade"];
    valorUnitario = map["valorUnitario"];
    observacao = map["observacao"];
    valorTotal = map["valorTotal"];
    data = map["data"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "quantidade": quantidade,
      "valorUnitario": valorUnitario,
      "observacao": observacao,
      "data": data,
      "valorTotal": valorTotal
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Gastos(id:$id, Descricao: $nome, codigoExterno : $quantidade)";
  }
}

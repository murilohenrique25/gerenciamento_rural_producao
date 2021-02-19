class Medicamento {
  int id;
  String nomeMedicamento;
  double quantidade;
  double precoUnitario;
  double precoTotal;
  String tempoDescarteLeite;
  String tipoDosagem;
  String carenciaMedicamento;
  String dataVencimento;
  String fornecedor;
  String dataAbertura;
  String dataCompra;
  String principioAtivo;
  String observacao;

  Medicamento();
  Medicamento.fromMap(Map map) {
    id = map["id"];
    nomeMedicamento = map["nomeMedicamento"];
    quantidade = map["quantidade"];
    tipoDosagem = map["tipoDosagem"];
    carenciaMedicamento = map["carenciaMedicamento"];
    dataVencimento = map["dataVencimento"];
    fornecedor = map["fornecedor"];
    dataAbertura = map["dataAbertura"];
    principioAtivo = map["principioAtivo"];
    observacao = map["observacao"];
    precoUnitario = map["precoUnitario"];
    precoTotal = map["precoTotal"];
    tempoDescarteLeite = map["tempoDescarteLeite"];
    dataCompra = map["dataCompra"];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      "nomeMedicamento": nomeMedicamento,
      "quantidade": quantidade,
      "tipoDosagem": tipoDosagem,
      "carenciaMedicamento": carenciaMedicamento,
      "dataVencimento": dataVencimento,
      "fornecedor": fornecedor,
      "dataAbertura": dataAbertura,
      "principioAtivo": principioAtivo,
      "observacao": observacao,
      "precoUnitario": precoUnitario,
      "precoTotal": precoTotal,
      "tempoDescarteLeite": tempoDescarteLeite,
      "dataCompra": dataCompra
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "id: $id, nome: $nomeMedicamento";
  }
}

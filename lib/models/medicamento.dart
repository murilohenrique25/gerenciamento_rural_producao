class Medicamento {
  int id;
  String nomeMedicamento;
  double quantidade;
  String tipoDosagem;
  String carenciaMedicamento;
  String dataVencimento;
  String fornecedor;
  String dataAbertura;
  String principioAtivo;
  String observacao;

  Medicamento();
  Medicamento.fromMap(Map map) {
    id = map["id_medicamento"];
    nomeMedicamento = map["nomeMedicamento"];
    quantidade = map["quantidade"];
    tipoDosagem = map["tipoDosagem"];
    carenciaMedicamento = map["carenciaMedicamento"];
    dataVencimento = map["dataVencimento"];
    fornecedor = map["fornecedor"];
    dataAbertura = map["dataAbertura"];
    principioAtivo = map["principioAtivo"];
    observacao = map["observacao"];
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
      "observacao": observacao
    };
    if (id != null) {
      map["id_medicamento"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "id: $id, nome: $nomeMedicamento";
  }
}

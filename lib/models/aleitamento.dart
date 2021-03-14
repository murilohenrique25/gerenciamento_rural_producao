class Aleitamento {
  int id;
  String nome;
  int quantidade;

  Aleitamento();
  Aleitamento.fromMap(Map map) {
    id = map["id_lote"];
    nome = map["nome"];
    quantidade = map["quantidade"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "quantidade": quantidade,
    };
    if (id != null) {
      map["id_lote"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Lote(id:$id, nome: $nome, codigoExterno : $quantidade)";
  }
}

class TodosCaprino {
  int id;
  String nome;
  String lote;
  String tipo;

  TodosCaprino();
  TodosCaprino.fromMap(Map map) {
    id = map["id"]; //
    nome = map["nome"]; //
    lote = map["lote"]; //
    tipo = map["tipo"]; //
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "tipo": tipo,
      "lote": lote,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "TodosAnimais(id:$id, nome: $nome)";
  }
}

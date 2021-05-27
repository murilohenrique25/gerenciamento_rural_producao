class TodosCaprino {
  int id;
  String nome;

  TodosCaprino();
  TodosCaprino.fromMap(Map map) {
    id = map["id"]; //
    nome = map["nome"]; //
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
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

class Lote {
  int id;
  String nome;

  Lote();
  Lote.fromMap(Map map) {
    id = map["id"];
    nome = map["nome"];
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
    return "Lote(id:$id)";
  }
}

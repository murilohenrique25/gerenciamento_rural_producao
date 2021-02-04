class Lote {
  int id;
  String name;
  int quantidade;

  Lote();
  Lote.fromMap(Map map) {
    id = map["id_lote"];
    name = map["name"];
    quantidade = map["quantidade"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "quantidade": quantidade,
    };
    if (id != null) {
      map["id_lote"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Lote(id:$id, name: $name, codigoExterno : $quantidade)";
  }
}

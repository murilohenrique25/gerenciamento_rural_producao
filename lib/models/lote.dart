class Lote {
  int id;
  String name;
  int codigoExterno;

  Lote();
  Lote.fromMap(Map map) {
    id = map["id_lote"];
    name = map["name"];
    codigoExterno = map["codigoExterno"];
  }

  Map toMap() {
    Map<String, dynamic> map = {"name": name, "codigoExterno": codigoExterno};
    if (id != null) {
      map["id_lote"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Lote(id:$id, name: $name, codigoExterno : $codigoExterno)";
  }
}

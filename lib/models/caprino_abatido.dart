class CaprinoAbatido {
  int id;
  int idLote;
  String nome;
  String data;
  String tipo;
  double peso;

  CaprinoAbatido();
  CaprinoAbatido.fromMap(Map map) {
    id = map["id"];
    idLote = map["id_lote"];
    nome = map["nome"];
    tipo = map["tipo"];
    data = map["data"];
    peso = map["peso"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "data": data,
      "peso": peso,
      "tipo": tipo,
      "id_lote": idLote,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "CaprinoAbatido(id:$id, name: $nome)";
  }
}

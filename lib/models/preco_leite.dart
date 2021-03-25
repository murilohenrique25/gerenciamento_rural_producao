class PrecoLeite {
  int id;
  String data;
  double preco;

  PrecoLeite();
  PrecoLeite.fromMap(Map map) {
    id = map["id"];
    data = map["data"];
    preco = map["preco"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "data": data,
      "preco": preco,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "PrecoLeite(id:$id, name: $preco, codigoExterno : $data)";
  }
}

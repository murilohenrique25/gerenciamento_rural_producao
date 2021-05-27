class PrecoCarneCaprina {
  int id;
  String data;
  double preco;

  PrecoCarneCaprina();
  PrecoCarneCaprina.fromMap(Map map) {
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
    return "PrecoCarneCaprina(id:$id, name: $preco, data : $data)";
  }
}

class InventarioSemen {
  int id;
  String codigoIA;
  int idTouro;
  String nomeTouro;
  String tamanho;
  int quantidade;
  String cor;
  String dataCadastro;

  InventarioSemen();
  InventarioSemen.fromMap(Map map) {
    id = map["id_inventario"];
    codigoIA = map["codigoIA"];
    idTouro = map["idTouro"];
    nomeTouro = map["nomeTouro"];
    tamanho = map["tamanho"];
    quantidade = map["quantidade"];
    cor = map["cor"];
    dataCadastro = map["dataCadastro"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "codigoIA": codigoIA,
      "idTouro": idTouro,
      "nomeTouro": nomeTouro,
      "tamanho": tamanho,
      "quantidade": quantidade,
      "cor": cor,
      "dataCadastro": dataCadastro
    };
    if (id != null) {
      map["id_inventario"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Inventario(id:$id, touro: $idTouro, Quantidade : $quantidade)";
  }
}

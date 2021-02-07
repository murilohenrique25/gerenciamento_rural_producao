import 'package:gerenciamento_rural/models/touro.dart';

class InventarioSemen {
  int id;
  String codigoIA;
  Touro touro;
  String tamanho;
  int quantidade;
  String cor;

  InventarioSemen();
  InventarioSemen.fromMap(Map map) {
    id = map["id_inventario"];
    codigoIA = map["codigoIA"];
    touro.idTouro = map["id_touro"];
    tamanho = map["tamanho"];
    quantidade = map["quantidade"];
    cor = map["cor"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "codigoIA": codigoIA,
      "id_touro": touro.idTouro,
      "tamanho": tamanho,
      "quantidade": quantidade,
      "cor": cor
    };
    if (id != null) {
      map["id_inventario"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Inventario(id:$id, touro: $touro, Quantidade : $quantidade)";
  }
}

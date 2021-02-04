import 'package:gerenciamento_rural/models/animal.dart';

class Vaca extends Animal {
  int idVaca;
  String ultimaInseminacao;

  Vaca();
  Vaca.fromMap(Map map) {
    idVaca = map["idVaca"];
    nome = map["nome"];
    ultimaInseminacao = map["ultimaInseminacao"];
    raca = map["raca"];
    idLote = map["idLote"];
    estado = map["estado"];
    pai = map["pai"];
    mae = map["mae"];
    avoMMaterno = map["avoMMaterno"];
    avoFMaterno = map["avoFMaterno"];
    avoMPaterno = map["avoMPaterno"];
    avoFPaterno = map["avoFPaterno"];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "dataNascimento": dataNascimento,
      "raca": raca,
      "idLote": idLote,
      "ultimaInseminacao": ultimaInseminacao,
      "pai": pai,
      "mae": mae,
      "avoMMaterno": avoMMaterno,
      "avoFMaterno": avoFMaterno,
      "avoMPaterno": avoMPaterno,
      "avoFPaterno": avoFPaterno
    };
    if (idVaca != null) {
      map["idVaca"] = idVaca;
    }
    return map;
  }
}

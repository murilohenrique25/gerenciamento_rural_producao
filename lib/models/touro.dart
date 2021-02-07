import 'package:gerenciamento_rural/models/animal.dart';

class Touro extends Animal {
  int idTouro;

  Touro();
  Touro.fromMap(Map map) {
    idTouro = map["idTouro"];
    nome = map["nome"];
    dataNascimento = map["dataNascimento"];
    raca = map["raca"];
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
      "estado": estado,
      "pai": pai,
      "mae": mae,
      "avoMMaterno": avoMMaterno,
      "avoFMaterno": avoFMaterno,
      "avoMPaterno": avoMPaterno,
      "avoFPaterno": avoFPaterno
    };
    if (idTouro != null) {
      map["idTouro"] = idTouro;
    }
    return map;
  }
}

import 'package:gerenciamento_rural/models/animal.dart';

class Bezerra extends Animal {
  int idBezerra;
  double pesoNascimento;
  double pesoDesmama;
  String dataDesmama;

  Bezerra();
  Bezerra.fromMap(Map map) {
    idBezerra = map["idBezerra"];
    nome = map["nome"];
    dataNascimento = map["dataNascimento"];
    raca = map["raca"];
    idLote = map["idLote"];
    pesoNascimento = map["pesoNascimento"];
    pesoDesmama = map["pesoDesmama"];
    dataDesmama = map["dataDesmama"];
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
      "pesoNascimento": pesoNascimento,
      "pesoDesmama": pesoDesmama,
      "dataDesmama": dataDesmama,
      "pai": pai,
      "mae": mae,
      "avoMMaterno": avoMMaterno,
      "avoFMaterno": avoFMaterno,
      "avoMPaterno": avoMPaterno,
      "avoFPaterno": avoFPaterno
    };
    if (idBezerra != null) {
      map["idBezerra"] = idBezerra;
    }
    return map;
  }
}

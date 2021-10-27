import 'package:gerenciamento_rural/models/animal.dart';

class Bezerra extends Animal {
  int idBezerra;
  double pesoNascimento;
  double pesoDesmama;
  String dataDesmama;
  int virouNovilha;
  String origem;
  String observacao;
  double peso;
  String cec;

  Bezerra();
  Bezerra.fromMap(Map map) {
    idBezerra = map["idBezerra"];
    nome = map["nome"];
    origem = map["origem"];
    observacao = map["observacao"];
    peso = map["peso"];
    cec = map["cec"];
    dataNascimento = map["dataNascimento"];
    raca = map["raca"];
    idLote = map["idLote"];
    pesoNascimento = map["pesoNascimento"];
    pesoDesmama = map["pesoDesmama"];
    dataDesmama = map["dataDesmama"];
    pai = map["pai"];
    mae = map["mae"];
    estado = map["estado"];
    avoMMaterno = map["avoMMaterno"];
    avoFMaterno = map["avoFMaterno"];
    avoMPaterno = map["avoMPaterno"];
    avoFPaterno = map["avoFPaterno"];
    virouNovilha = map["virouNovilha"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "dataNascimento": dataNascimento,
      "raca": raca,
      "origem": origem,
      "observacao": observacao,
      "peso": peso,
      "cec": cec,
      "idLote": idLote,
      "pesoNascimento": pesoNascimento,
      "pesoDesmama": pesoDesmama,
      "dataDesmama": dataDesmama,
      "pai": pai,
      "mae": mae,
      "estado": estado,
      "avoMMaterno": avoMMaterno,
      "avoFMaterno": avoFMaterno,
      "avoMPaterno": avoMPaterno,
      "avoFPaterno": avoFPaterno,
      "virouNovilha": virouNovilha
    };
    if (idBezerra != null) {
      map["idBezerra"] = idBezerra;
    }
    return map;
  }
}

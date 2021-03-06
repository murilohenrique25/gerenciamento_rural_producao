import 'package:gerenciamento_rural/models/animal.dart';

class Novilha extends Animal {
  int idNovilha;
  double pesoNascimento;
  double pesoDesmama;
  String dataDesmama;
  String dataCobertura;
  double pesoPrimeiraCobertura;
  double idadePrimeiraCobertura;
  double idadePrimeiroParto;
  String diagnosticoGestacao;
  int virouVaca;

  Novilha();
  Novilha.fromMap(Map map) {
    idNovilha = map["idNovilha"];
    nome = map["nome"];
    raca = map["raca"];
    pesoNascimento = map["pesoNascimento"];
    dataNascimento = map["dataNascimento"];
    pesoDesmama = map["pesoDesmama"];
    dataDesmama = map["dataDesmama"];
    dataCobertura = map["dataCobertura"];
    idLote = map["idLote"];
    pesoPrimeiraCobertura = map["pesoPrimeiraCobertura"];
    idadePrimeiraCobertura = map["idadePrimeiraCobertura"];
    idadePrimeiroParto = map["idadePrimeiroParto"];
    diagnosticoGestacao = map["diagnosticoGestacao"];
    pai = map["pai"];
    mae = map["mae"];
    estado = map["estado"];
    avoMMaterno = map["avoMMaterno"];
    avoFMaterno = map["avoFMaterno"];
    avoMPaterno = map["avoMPaterno"];
    avoFPaterno = map["avoFPaterno"];
    virouVaca = map["virouVaca"];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "pesoNascimento": pesoNascimento,
      "dataNascimento": dataNascimento,
      "raca": raca,
      "pesoDesmama": pesoDesmama,
      "dataDesmama": dataDesmama,
      "dataCobertura": dataCobertura,
      "pesoPrimeiraCobertura": pesoPrimeiraCobertura,
      "idadePrimeiraCobertura": idadePrimeiraCobertura,
      "idadePrimeiroParto": idadePrimeiroParto,
      "diagnosticoGestacao": diagnosticoGestacao,
      "pai": pai,
      "mae": mae,
      "estado": estado,
      "avoMMaterno": avoMMaterno,
      "avoFMaterno": avoFMaterno,
      "avoMPaterno": avoMPaterno,
      "avoFPaterno": avoFPaterno,
      "virouVaca": virouVaca
    };
    if (idNovilha != null) {
      map["idNovilha"] = idNovilha;
    }
    return map;
  }
}

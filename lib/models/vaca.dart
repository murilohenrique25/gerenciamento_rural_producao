import 'package:gerenciamento_rural/models/animal.dart';

class Vaca extends Animal {
  int idVaca;
  String ultimaInseminacao;
  String partoPrevisto;
  String secagemPrevista;

  Vaca();
  Vaca.fromMap(Map map) {
    idVaca = map["idVaca"];
    nome = map["nome"];
    dataNascimento = map["dataNascimento"];
    ultimaInseminacao = map["ultimaInseminacao"];
    partoPrevisto = map["partoPrevisto"];
    secagemPrevista = map["secagemPrevista"];
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
      "secagemPrevista": secagemPrevista,
      "partoPrevisto": partoPrevisto,
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

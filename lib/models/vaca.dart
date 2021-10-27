import 'package:gerenciamento_rural/models/animal.dart';

class Vaca extends Animal {
  int idVaca;
  String ultimaInseminacao;
  String partoPrevisto;
  String secagemPrevista;
  String diagnosticoGestacao;
  String dataDiagnosticoGestacao;
  String tipoDiagnosticoGestacao;
  int diasPrenha;
  String origem;
  String observacao;
  double peso;
  String cec;

  Vaca();
  Vaca.fromMap(Map map) {
    idVaca = map["idVaca"];
    nome = map["nome"];
    origem = map["origem"];
    observacao = map["observacao"];
    peso = map["peso"];
    cec = map["cec"];
    dataNascimento = map["dataNascimento"];
    ultimaInseminacao = map["ultimaInseminacao"];
    partoPrevisto = map["partoPrevisto"];
    secagemPrevista = map["secagemPrevista"];
    raca = map["raca"];
    idLote = map["idLote"];
    nomeLote = map["nomeLote"];
    estado = map["estado"];
    pai = map["pai"];
    mae = map["mae"];
    diagnosticoGestacao = map["diagnosticoGestacao"];
    avoMMaterno = map["avoMMaterno"];
    avoFMaterno = map["avoFMaterno"];
    avoMPaterno = map["avoMPaterno"];
    avoFPaterno = map["avoFPaterno"];
    dataDiagnosticoGestacao = map["dataDiagnosticoGestacao"];
    tipoDiagnosticoGestacao = map["tipoDiagnosticoGestacao"];
    diasPrenha = map["diasPrenha"];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "origem": origem,
      "observacao": observacao,
      "peso": peso,
      "cec": cec,
      "dataNascimento": dataNascimento,
      "raca": raca,
      "secagemPrevista": secagemPrevista,
      "partoPrevisto": partoPrevisto,
      "idLote": idLote,
      "nomeLote": nomeLote,
      "ultimaInseminacao": ultimaInseminacao,
      "pai": pai,
      "mae": mae,
      "diagnosticoGestacao": diagnosticoGestacao,
      "estado": estado,
      "avoMMaterno": avoMMaterno,
      "avoFMaterno": avoFMaterno,
      "avoMPaterno": avoMPaterno,
      "dataDiagnosticoGestacao": dataDiagnosticoGestacao,
      "tipoDiagnosticoGestacao": tipoDiagnosticoGestacao,
      "diasPrenha": diasPrenha,
      "avoFPaterno": avoFPaterno
    };
    if (idVaca != null) {
      map["idVaca"] = idVaca;
    }
    return map;
  }

  @override
  String toString() {
    return "Vaca(id:$idVaca, dataInseminacao:$ultimaInseminacao)";
  }
}

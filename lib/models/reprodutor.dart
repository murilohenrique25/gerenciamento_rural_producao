import 'package:gerenciamento_rural/models/caprino.dart';

class Reprodutor extends Caprinos {
  String dataAbatido;
  double pesoAbatido;
  String descricao;
  String dataAcontecido;
  double valorVendido;
  double pesoFinal;
  Reprodutor();
  Reprodutor.fromMap(Map map) {
    id = map["id"]; //
    idLote = map["id_lote"]; //
    setor = map["setor"]; //
    nomeAnimal = map["nome_animal"]; //
    dataNascimento = map["data_nascimento"]; //
    lote = map["lote"];
    raca = map["raca"]; //
    pai = map["pai"]; //
    mae = map["mae"]; //
    situacao = map["situacao"]; //
    origem = map["origem"]; //
    procedencia = map["procedencia"];
    baia = map["baia"];
    observacao = map["observacao"]; //
    dataAbatido = map["data_abatido"]; //
    pesoAbatido = map["peso_abatido"]; //
    descricao = map["descricao"]; //
    dataAcontecido = map["data_acontecido"]; //
    valorVendido = map["valor_vendido"]; //
    pesoFinal = map["peso_final"]; //
    peso = map["peso"]; //
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "id_lote": idLote, //
      "setor": setor, //
      "nome_animal": nomeAnimal,
      "data_nascimento": dataNascimento,
      "lote": lote,
      "raca": raca,
      "pai": pai,
      "mae": mae,
      "situacao": situacao,
      "procedencia": procedencia,
      "baia": baia,
      "origem": origem,
      "observacao": observacao,
      "data_abatido": dataAbatido,
      "peso_abatido": pesoAbatido,
      "descricao": descricao,
      "data_acontecido": dataAcontecido,
      "valor_vendido": valorVendido,
      "peso_final": pesoFinal,
      "peso": peso,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Reprodutor(id:$id, nome: $nomeAnimal)";
  }
}

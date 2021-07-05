import 'package:gerenciamento_rural/models/suino.dart';

class Matriz extends Suinos {
  String origem;
  int numeroPartos;
  String partoPrevisto;
  String diagnosticoGestacao;
  int diasPrenha;
  String procedencia;
  Matriz();
  Matriz.fromMap(Map map) {
    idAnimal = map["id_animal"]; //
    nomeAnimal = map["nome_animal"]; //
    dataNascimento = map["data_nascimento"]; //
    estado = map["estado"]; //
    lote = map["lote"]; //
    identificacao = map["identificacao"]; //usar como vivo/ morto/ vendido
    raca = map["raca"]; //
    pai = map["pai"]; //
    mae = map["mae"]; //
    baia = map["baia"]; //
    origem = map["origem"]; //
    numeroPartos = map["numero_partos"]; //
    partoPrevisto = map["parto_previsto"]; //
    diagnosticoGestacao = map["diagnostico_gestacao"]; //
    diasPrenha = map["dias_prenha"]; //
    descricao = map["descricao"]; //
    precoFinal = map["preco_final"]; //
    dataAcontecido = map["data_acontecido"]; //
    peso = map["peso"];
    procedencia = map["procedencia"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "nome_animal": nomeAnimal,
      "data_nascimento": dataNascimento,
      "estado": estado,
      "lote": lote,
      "identificacao": identificacao,
      "raca": raca,
      "pai": pai,
      "mae": mae,
      "baia": baia,
      "origem": origem,
      "numero_partos": numeroPartos,
      "parto_previsto": partoPrevisto,
      "diagnostico_gestacao": diagnosticoGestacao,
      "dias_prenha": diasPrenha,
      "descricao": descricao,
      "preco_final": precoFinal,
      "data_acontecido": dataAcontecido,
      "peso": peso,
      "procedencia": procedencia,
    };
    if (idAnimal != null) {
      map["id_animal"] = idAnimal;
    }
    return map;
  }

  @override
  String toString() {
    return "Matriz(id:$idAnimal, nome: $nomeAnimal, parto previsto : $partoPrevisto)";
  }
}

import 'package:gerenciamento_rural/models/caprino.dart';

class MatrizCaprino extends Caprinos {
  String idadePrimeiroParto;
  double pesoPrimeiroParto;
  String ultimaInseminacao;
  String diagnosticoGestacao;
  String descricao;
  String dataAcontecido;
  double valorVendido;
  double pesoFinal;
  int diasPrenha;
  MatrizCaprino();
  MatrizCaprino.fromMap(Map map) {
    id = map["id"]; //
    idLote = map["id_lote"]; //
    setor = map["setor"]; //
    nomeAnimal = map["nome_animal"]; //
    dataNascimento = map["data_nascimento"]; //
    lote = map["lote"];
    raca = map["raca"]; //
    pai = map["pai"]; //
    mae = map["mae"]; //
    peso = map["peso"];
    situacao = map["situacao"]; //
    procedencia = map["procedencia"];
    baia = map["baia"];
    origem = map["origem"];
    diagnosticoGestacao = map["diagnostico_gestacao"];
    idadePrimeiroParto = map["idade_primeiro_parto"];
    pesoPrimeiroParto = map["peso_primeiro_parto"];
    ultimaInseminacao = map["ultima_inseminacao"];
    observacao = map["observacao"]; //
    descricao = map["descricao"]; //
    dataAcontecido = map["data_acontecido"]; //
    valorVendido = map["valor_vendido"]; //
    pesoFinal = map["peso_final"]; //
    diasPrenha = map["dias_prenha"]; //
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
      "peso": peso,
      "origem": origem,
      "diagnostico_gestacao": diagnosticoGestacao,
      "idade_primeiro_parto": idadePrimeiroParto,
      "peso_primeiro_parto": pesoPrimeiroParto,
      "ultima_inseminacao": ultimaInseminacao,
      "observacao": observacao,
      "descricao": descricao,
      "data_acontecido": dataAcontecido,
      "valor_vendido": valorVendido,
      "peso_final": pesoFinal,
      "dias_prenha": diasPrenha,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "MatrizCaprino(id:$id, nome: $nomeAnimal)";
  }
}

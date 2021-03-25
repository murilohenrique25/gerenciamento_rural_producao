import 'package:gerenciamento_rural/models/suino.dart';

class Cachaco extends Suinos {
  String origem;
  double peso;
  Cachaco();
  Cachaco.fromMap(Map map) {
    idAnimal = map["id_animal"]; //
    nomeAnimal = map["nome_animal"]; //
    dataNascimento = map["data_nascimento"]; //
    estado = map["estado"]; //
    lote = map["lote"];
    identificacao = map["identificacao"]; //usar como vivo/ morto/ vendido
    raca = map["raca"]; //
    pai = map["pai"]; //
    mae = map["mae"]; //
    baia = map["baia"]; //
    origem = map["origem"]; //
    peso = map["peso"]; //
    observacao = map["observacao"]; //
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
      "peso": peso,
      "observacao": observacao,
    };
    if (idAnimal != null) {
      map["id_animal"] = idAnimal;
    }
    return map;
  }

  @override
  String toString() {
    return "Cachaço(id:$idAnimal, nome: $nomeAnimal, codigoExterno : $quantidade)";
  }
}

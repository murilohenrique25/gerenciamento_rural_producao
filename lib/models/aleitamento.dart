import 'package:gerenciamento_rural/models/suino.dart';

class Aleitamento extends Suinos {
  Aleitamento();
  Aleitamento.fromMap(Map map) {
    idAnimal = map["id_animal"];
    id = map["id"];
    nomeAnimal = map["nome_animal"];
    dataNascimento = map["data_nascimento"];
    quantidade = map["quantidade"];
    estado = map["estado"];
    lote = map["lote"];
    identificacao = map["identificacao"];
    vivos = map["vivos"];
    mortos = map["mortos"];
    raca = map["raca"];
    pai = map["pai"];
    mae = map["mae"];
    sexoF = map["sexoF"];
    sexoM = map["sexoM"];
    baia = map["baia"];
    pesoNascimento = map["pesoNascimento"];
    pesoDesmama = map["pesoDesmama"];
    dataDesmama = map["dataDesmama"];
    observacao = map["observacao"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "id_animal": idAnimal,
      "nome_animal": nomeAnimal,
      "data_nascimento": dataNascimento,
      "quantidade": quantidade,
      "estado": estado,
      "lote": lote,
      "identificacao": identificacao,
      "vivos": vivos,
      "mortos": mortos,
      "raca": raca,
      "pai": pai,
      "mae": mae,
      "sexoF": sexoF,
      "sexoM": sexoM,
      "baia": baia,
      "pesoNascimento": pesoNascimento,
      "pesoDesmama": pesoDesmama,
      "dataDesmama": dataDesmama,
      "observacao": observacao,
    };
    if (idAnimal != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Aleitamento(id:$idAnimal, nome: $nomeAnimal, codigoExterno : $quantidade)";
  }
}

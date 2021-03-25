import 'package:gerenciamento_rural/models/suino.dart';

class Terminacao extends Suinos {
  String dataAbate;
  String pesoAbate;
  double pesoMedio;

  Terminacao();
  Terminacao.fromMap(Map map) {
    id = map["id"];
    idAnimal = map["id_animal"];
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
    dataAbate = map["data_abate"];
    pesoAbate = map["peso_abate"];
    pesoMedio = map["peso_medio"];
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
      "peso_medio": pesoMedio,
      "peso_abate": pesoAbate,
      "data_abate": dataAbate,
    };
    if (idAnimal != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Terminação(id:$idAnimal, nome: $nomeAnimal, codigoExterno : $quantidade)";
  }
}

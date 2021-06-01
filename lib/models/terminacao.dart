import 'package:gerenciamento_rural/models/suino.dart';

class Terminacao extends Suinos {
  String dataAbate;
  double pesoAbate;
  double pesoMedio;
  int mudarPlantel;
  String nome;
  Terminacao();
  Terminacao.fromMap(Map map) {
    id = map["id"];
    idAnimal = map["id_animal"];
    nome = map["nome"];
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
    pesoNascimento = map["peso_nascimento"];
    pesoDesmama = map["peso_desmama"];
    dataDesmama = map["data_desmama"];
    observacao = map["observacao"];
    dataAbate = map["data_abate"];
    pesoAbate = map["peso_abate"];
    pesoMedio = map["peso_medio"];
    mudarPlantel = map["mudar_palantel"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "id_animal": idAnimal,
      "nome": nome,
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
      "peso_nascimento": pesoNascimento,
      "peso_desmama": pesoDesmama,
      "data_desmama": dataDesmama,
      "observacao": observacao,
      "peso_medio": pesoMedio,
      "peso_abate": pesoAbate,
      "data_abate": dataAbate,
      "mudar_plantel": mudarPlantel
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Terminação(id:$idAnimal, nome: $nome, codigoExterno : $quantidade)";
  }
}

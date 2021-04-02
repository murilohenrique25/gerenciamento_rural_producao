import 'package:gerenciamento_rural/models/suino.dart';

class HistoricoPartoSuino extends Suinos {
  int mudarPlantel;
  String nome;
  HistoricoPartoSuino();
  HistoricoPartoSuino.fromMap(Map map) {
    id = map["id"];
    nome = map["ninhada"];
    dataNascimento = map["data_nascimento"];
    quantidade = map["quantidade"];
    vivos = map["vivos"];
    mortos = map["mortos"];
    pai = map["pai"];
    mae = map["mae"];
    sexoF = map["sexoF"];
    sexoM = map["sexoM"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "ninhada": nome,
      "data_nascimento": dataNascimento,
      "quantidade": quantidade,
      "vivos": vivos,
      "mortos": mortos,
      "pai": pai,
      "mae": mae,
      "sexoF": sexoF,
      "sexoM": sexoM
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "HistoricoParto(id:$id, nome: $nome, codigoExterno : $quantidade)";
  }
}

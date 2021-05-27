import 'package:gerenciamento_rural/models/caprino.dart';

class JovemFemeaCaprino extends Caprinos {
  String pesoNascimento;
  String pesoDesmama;
  String dataDesmama;
  int virouAdulto;
  String descricao;
  String dataAcontecido;
  double valorVendido;
  double pesoFinal;

  JovemFemeaCaprino();
  JovemFemeaCaprino.fromMap(Map map) {
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
    baia = map["baia"];
    origem = map["origem"];
    pesoNascimento = map["peso_nascimento"];
    pesoDesmama = map["peso_desmama"];
    dataDesmama = map["data_desmama"];
    observacao = map["observacao"]; //
    virouAdulto = map["virouAdulto"]; //
    descricao = map["descricao"]; //
    dataAcontecido = map["data_acontecido"]; //
    valorVendido = map["valor_vendido"]; //
    pesoFinal = map["peso_final"]; //
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "id_lote": idLote,
      "nome_animal": nomeAnimal,
      "setor": setor,
      "data_nascimento": dataNascimento,
      "lote": lote,
      "raca": raca,
      "pai": pai,
      "mae": mae,
      "baia": baia,
      "origem": origem,
      "situacao": situacao,
      "peso_nascimento": pesoNascimento,
      "peso_desmama": pesoDesmama,
      "data_desmama": dataDesmama,
      "observacao": observacao,
      "virouAdulto": virouAdulto,
      "descricao": descricao,
      "data_acontecido": dataAcontecido,
      "valor_vendido": valorVendido,
      "peso_final": pesoFinal,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "JovemFemea(id:$id, nome: $nomeAnimal)";
  }
}

import 'package:gerenciamento_rural/models/animal_corte.dart';

class BezerroCorte extends AnimalCorte {
  String idadeDesmama;
  double pesoDesmama;
  int virouAdulto;

  BezerroCorte();
  BezerroCorte.fromMap(Map map) {
    id = map["id"];
    nome = map["nome"];
    dataNascimento = map["data_nascimento"];
    raca = map["raca"];
    origem = map["origem"];
    peso = map["peso"];
    idLote = map["id_lote"];
    nomeLote = map["nome_lote"];
    pai = map["pai"];
    mae = map["mae"];
    situacao = map["situacao"];
    observacao = map["observacao"];
    dataAcontecido = map["data_acontecido"];
    pesoFinal = map["peso_final"];
    comprador = map["comprador"];
    precoVivo = map["preco_vivo"];
    idadeDesmama = map["idade_desmama"];
    pesoDesmama = map["peso_desmama"];
    virouAdulto = map["virou_adulto"];
    descricao = map["descricao"];
    animalAbatido = map["animal_abatido"];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "data_nascimento": dataNascimento,
      "raca": raca,
      "origem": origem,
      "peso": peso,
      "id_lote": idLote,
      "nome_lote": nomeLote,
      "pai": pai,
      "mae": mae,
      "situacao": situacao,
      "observacao": observacao,
      "data_acontecido": dataAcontecido,
      "peso_final": pesoFinal,
      "comprador": comprador,
      "preco_vivo": precoVivo,
      "idade_desmama": idadeDesmama,
      "peso_desmama": pesoDesmama,
      "virou_adulto": virouAdulto,
      "descricao": descricao,
      "animal_abatido": descricao,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Bezerro(id:$id)";
  }
}

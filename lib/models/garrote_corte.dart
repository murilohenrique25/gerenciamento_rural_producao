import 'package:gerenciamento_rural/models/animal_corte.dart';

class GarroteCorte extends AnimalCorte {
  String idadeDesmama;
  double pesoDesmama;
  int virouAdulto;

  GarroteCorte();
  GarroteCorte.fromMap(Map map) {
    id = map["id"];
    nome = map["nome"];
    dataNascimento = map["data_nascimento"];
    raca = map["raca"];
    origem = map["origem"];
    idLote = map["id_lote"];
    nomeLote = map["nome_lote"];
    peso = map["peso"];
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
      "id_lote": idLote,
      "peso": peso,
      "nome_lote": nomeLote,
      "idade_desmama": idadeDesmama,
      "pai": pai,
      "mae": mae,
      "peso_desmama": pesoDesmama,
      "situacao": situacao,
      "observacao": observacao,
      "data_acontecido": dataAcontecido,
      "peso_final": pesoFinal,
      "comprador": comprador,
      "preco_vivo": precoVivo,
      "virou_adulto": virouAdulto,
      "descricao": descricao,
      "animal_abatido": animalAbatido,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Vaca(id:$id)";
  }
}

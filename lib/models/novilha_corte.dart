import 'package:gerenciamento_rural/models/animal_corte.dart';

class NovilhaCorte extends AnimalCorte {
  String ultimaInseminacao;
  String partoPrevisto;
  String secagemPrevista;
  String diagnosticoGestacao;
  String dataParto;
  int diasPrenha;
  String dataDiagnosticoGestacao;
  String dataInseminacao;
  String idadeDesmama;
  double pesoDesmama;
  String idadePrimeiraCobertura;
  double pesoPrimeiraCobertura;
  String idadePrimeiroParto;
  double pesoPrimeiroParto;
  int virouAdulto;
  String tipoDiagnosticoGestacao;
  String tipoParto;

  NovilhaCorte();
  NovilhaCorte.fromMap(Map map) {
    id = map["id"];
    nome = map["nome"];
    dataNascimento = map["data_nascimento"];
    ultimaInseminacao = map["ultima_inseminacao"];
    dataDiagnosticoGestacao = map["data_diagnostico_gestacao"];
    partoPrevisto = map["parto_previsto"];
    secagemPrevista = map["secagem_prevista"];
    dataParto = map["data_parto"];
    raca = map["raca"];
    origem = map["origem"];
    diasPrenha = map["dias_prenha"];
    peso = map["peso"];
    idLote = map["id_lote"];
    nomeLote = map["nome_lote"];
    pai = map["pai"];
    mae = map["mae"];
    situacao = map["situacao"];
    observacao = map["observacao"];
    cec = map["cec"];
    diagnosticoGestacao = map["diagnostico_gestacao"];
    dataAcontecido = map["data_acontecido"];
    pesoFinal = map["peso_final"];
    comprador = map["comprador"];
    precoVivo = map["preco_vivo"];
    idadeDesmama = map["idade_desmama"];
    pesoDesmama = map["peso_desmama"];
    idadePrimeiraCobertura = map["idade_primeira_cobertura"];
    pesoPrimeiraCobertura = map["peso_primeira_cobertura"];
    idadePrimeiroParto = map["idade_primeiro_parto"];
    pesoPrimeiroParto = map["peso_primeiro_parto"];
    virouAdulto = map["virou_adulto"];
    descricao = map["descricao"];
    dataInseminacao = map["data_inseminacao"];
    tipoDiagnosticoGestacao = map["tipo_diagnostico_gestacao"];
    tipoParto = map["tipo_parto"];
    animalAbatido = map["animal_abatido"];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "data_nascimento": dataNascimento,
      "raca": raca,
      "origem": origem,
      "peso": peso,
      "secagem_prevista": secagemPrevista,
      "parto_previsto": partoPrevisto,
      "data_parto": dataParto,
      "data_diagnostico_gestacao": dataDiagnosticoGestacao,
      "dias_prenha": diasPrenha,
      "id_lote": idLote,
      "nome_lote": nomeLote,
      "ultima_inseminacao": ultimaInseminacao,
      "pai": pai,
      "mae": mae,
      "diagnostico_gestacao": diagnosticoGestacao,
      "situacao": situacao,
      "cec": cec,
      "observacao": observacao,
      "data_acontecido": dataAcontecido,
      "peso_final": pesoFinal,
      "comprador": comprador,
      "preco_vivo": precoVivo,
      "idade_desmama": idadeDesmama,
      "peso_desmama": pesoDesmama,
      "idade_primeira_cobertura": idadePrimeiraCobertura,
      "peso_primeira_cobertura": pesoPrimeiraCobertura,
      "idade_primeiro_parto": idadePrimeiroParto,
      "peso_primeiro_parto": pesoPrimeiroParto,
      "virou_adulto": virouAdulto,
      "descricao": descricao,
      "data_inseminacao": dataInseminacao,
      "tipo_diagnostico_gestacao": tipoDiagnosticoGestacao,
      "tipo_parto": tipoParto,
      "animal_abatido": animalAbatido,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Novilha(id:$id)";
  }
}

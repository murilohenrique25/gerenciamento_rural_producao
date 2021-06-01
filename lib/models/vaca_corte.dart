import 'package:gerenciamento_rural/models/animal_corte.dart';

class VacaCorte extends AnimalCorte {
  String ultimaInseminacao;
  String partoPrevisto;
  String secagemPrevista;
  String diagnosticoGestacao;
  String dataParto;
  int diasPrenha;
  String dataDiagnosticoGestacao;
  String tipoDiagnosticoGestacao;
  VacaCorte();
  VacaCorte.fromMap(Map map) {
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
    peso = map["peso"];
    diasPrenha = map["dias_prenha"];
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
    descricao = map["descricao"];
    tipoDiagnosticoGestacao = map["tipo_diagnostico_gestacao"];
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
      "descricao": descricao,
      "tipo_diagnostico_gestacao": tipoDiagnosticoGestacao,
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

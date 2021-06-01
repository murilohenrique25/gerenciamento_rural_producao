class Egua {
  int id;
  String nome;
  String dataNascimento;
  String pai;
  String mae;
  String lote;
  String estado;
  String origem;
  String raca;
  String resenha;
  String observacao;
  String situacao;
  String diagnosticoGestacao;
  String vm;
  String cios;
  String baia;
  double peso;
  String totalPartos;
  int diasPrenha;
  String pelagem;
  String partoPrevisto;
  String descricao;
  String dataAcontecido;
  double valorVendido;

  Egua();
  Egua.fromMap(Map map) {
    id = map["id"]; //
    nome = map["nome"]; //
    dataNascimento = map["data_nascimento"]; //
    estado = map["estado"]; //
    lote = map["lote"]; //
    raca = map["raca"]; //
    pai = map["pai"]; //
    mae = map["mae"]; //
    resenha = map["resenha"]; //
    baia = map["baia"]; //
    peso = map["peso"]; //
    origem = map["origem"]; //
    observacao = map["observacao"]; //
    situacao = map["situacao"]; //
    diagnosticoGestacao = map["diagnostico_gestacao"];
    vm = map["vm"];
    diasPrenha = map["diasPrenha"];
    cios = map["cios"];
    totalPartos = map["total_partos"];
    pelagem = map["pelagem"];
    partoPrevisto = map["parto_previsto"];
    descricao = map["descricao"];
    dataAcontecido = map["data_acontecido"];
    valorVendido = map["valor_vendido"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "data_nascimento": dataNascimento,
      "estado": estado,
      "lote": lote,
      "raca": raca,
      "pai": pai,
      "mae": mae,
      "origem": origem,
      "resenha": resenha,
      "baia": baia,
      "peso": peso,
      "observacao": observacao,
      "situacao": situacao,
      "diasPrenha": diasPrenha,
      "diagnostico_gestacao": diagnosticoGestacao,
      "vm": vm,
      "cios": cios,
      "total_partos": totalPartos,
      "pelagem": pelagem,
      "parto_previsto": partoPrevisto,
      "descricao": pelagem,
      "data_acontecido": dataAcontecido,
      "valor_vendido": valorVendido,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Egua(id:$id, nome: $nome, origem : $origem)";
  }
}

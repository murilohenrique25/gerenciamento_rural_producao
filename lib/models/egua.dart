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
  String totalPartos;
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
    origem = map["origem"]; //
    observacao = map["observacao"]; //
    situacao = map["situacao"]; //
    diagnosticoGestacao = map["diagnostico_gestacao"];
    vm = map["vm"];
    cios = map["cios"];
    totalPartos = map["total_partos"];
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
      "observacao": observacao,
      "situacao": situacao,
      "diagnostico_gestacao": diagnosticoGestacao,
      "vm": vm,
      "cios": cios,
      "total_partos": totalPartos,
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

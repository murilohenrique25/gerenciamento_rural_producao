class Potro {
  int id;
  String nome;
  String sexo;
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
  int virouAdulto;
  String vm;
  Potro();
  Potro.fromMap(Map map) {
    id = map["id"]; //
    nome = map["nome"]; //
    dataNascimento = map["data_nascimento"]; //
    estado = map["estado"]; //
    lote = map["lote"]; //
    sexo = map["sexo"];
    raca = map["raca"]; //
    pai = map["pai"]; //
    mae = map["mae"]; //
    resenha = map["resenha"]; //
    origem = map["origem"]; //
    observacao = map["observacao"]; //
    situacao = map["situacao"]; //
    virouAdulto = map["virou_adulto"];
    vm = map["vm"];
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
      "sexo": sexo,
      "origem": origem,
      "resenha": resenha,
      "observacao": observacao,
      "situacao": situacao,
      "virou_adulto": virouAdulto,
      "vm": vm,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Potro(id:$id, nome: $nome, origem : $origem)";
  }
}

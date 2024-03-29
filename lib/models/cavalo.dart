class Cavalo {
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
  String baia;
  double peso;
  String vm;
  String pelagem;
  String descricao;
  String dataAcontecido;
  double valorVendido;
  Cavalo();
  Cavalo.fromMap(Map map) {
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
    vm = map["vm"];
    pelagem = map["pelagem"];
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
      "baia": baia,
      "peso": peso,
      "resenha": resenha,
      "observacao": observacao,
      "vm": vm,
      "pelagem": pelagem,
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
    return "Cavalo(id:$id, nome: $nome, origem : $origem)";
  }
}

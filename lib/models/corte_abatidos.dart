class CortesAbatidos {
  int id;
  String nomeAnimal;
  String categoria;
  String idade;
  double pesoArroba;
  double precoKgArroba;
  String data;
  String comprador;
  int quantidade;
  String observacao;

  CortesAbatidos();
  CortesAbatidos.fromMap(Map map) {
    id = map["id"];
    nomeAnimal = map["nome_animal"];
    categoria = map["categoria"];
    idade = map["idade"];
    pesoArroba = map["peso_arroba"];
    precoKgArroba = map["preco_kg_arroba"];
    data = map["data"];
    comprador = map["comprador"];
    quantidade = map["quantidade"];
    observacao = map["observacao"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "nome_animal": nomeAnimal,
      "categoria": categoria,
      "idade": idade,
      "peso_arroba": pesoArroba,
      "preco_kg_arroba": precoKgArroba,
      "data": data,
      "quantidade": quantidade,
      "comprador": comprador,
      "observacao": observacao
    };
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  @override
  String toString() {
    return "Abatidos(categoria:$categoria\npeso arroba:$pesoArroba\npreco arroba:$precoKgArroba\nquantidade: $quantidade)";
  }
}

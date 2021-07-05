class CortesAbatidosAgrupado {
  int id;
  int quantidadeAnimal;
  String categoria;
  String idade;
  double pesoArroba;
  double precoKgArroba;
  double precoTotal;
  String dia;
  String comprador;
  String observacao;

  CortesAbatidosAgrupado();
  CortesAbatidosAgrupado.fromMap(Map map) {
    id = map["id"];
    quantidadeAnimal = map["nome_animal"];
    categoria = map["categoria"];
    idade = map["idade"];
    pesoArroba = map["peso_arroba"];
    precoKgArroba = map["preco_kg_arroba"];
    precoTotal = map["preco_total"];
    dia = map["dia"];
    comprador = map["comprador"];
    observacao = map["observacao"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "quantidade_animal": quantidadeAnimal,
      "categoria": categoria,
      "idade": idade,
      "peso_arroba": pesoArroba,
      "preco_kg_arroba": precoKgArroba,
      "preco_total": precoTotal,
      "dia": dia,
      "comprador": comprador,
      "observacao": observacao
    };
    if (id != null) {
      map["id"] = id;
    }

    return map;
  }
}

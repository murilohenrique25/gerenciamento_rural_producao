class Inseminacao {
  int id;
  int idVaca;
  String nomeVaca;
  int idSemen;
  String nomeTouro;
  String data;
  String observacao;
  String inseminador;

  Inseminacao();
  Inseminacao.fromMap(Map map) {
    id = map["id"];
    idVaca = map["idVaca"];
    nomeVaca = map["nomeVaca"];
    idSemen = map["idSemen"];
    nomeTouro = map["nomeTouro"];
    data = map["data"];
    observacao = map["observacao"];
    inseminador = map["inseminador"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "idVaca": idVaca,
      "nomeVaca": nomeVaca,
      "idSemen": idSemen,
      "nomeTouro": nomeTouro,
      "data": data,
      "inseminador": inseminador,
      "observacao": observacao
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Inseminacao(id:$id, touro: $nomeVaca, Quantidade : $nomeTouro)";
  }
}

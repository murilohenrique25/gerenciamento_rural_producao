class InseminacaoSuino {
  int id;
  int idMatriz;
  String nomeMatriz;
  int idSemen;
  String nomeCachaco;
  String data;
  String observacao;
  String inseminador;
  String tipoReproducao;
  String palheta;

  InseminacaoSuino();
  InseminacaoSuino.fromMap(Map map) {
    id = map["id"];
    idMatriz = map["id_matriz"];
    nomeMatriz = map["nome_matriz"];
    idSemen = map["id_semen"];
    nomeCachaco = map["nome_cachaco"];
    data = map["data"];
    observacao = map["observacao"];
    inseminador = map["inseminador"];
    tipoReproducao = map["tipo_reproducao"];
    palheta = map["palheta"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "id_matriz": idMatriz,
      "nome_matriz": nomeMatriz,
      "id_semen": idSemen,
      "nome_cachaco": nomeCachaco,
      "data": data,
      "inseminador": inseminador,
      "observacao": observacao,
      "tipo_reproducao": tipoReproducao,
      "palheta": palheta,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Inseminacao(id:$id, cachaco: $nomeCachaco, matriz : $nomeMatriz)";
  }
}

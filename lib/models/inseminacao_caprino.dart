class InseminacaoCaprino {
  int id;
  int idMatriz;
  String nomeMatriz;
  int idSemen;
  String nomeReprodutor;
  String data;
  String observacao;
  String inseminador;
  String tipoReproducao;
  String palheta;

  InseminacaoCaprino();
  InseminacaoCaprino.fromMap(Map map) {
    id = map["id"];
    idMatriz = map["id_matriz"];
    nomeMatriz = map["nome_matriz"];
    idSemen = map["id_semen"];
    nomeReprodutor = map["nome_reprodutor"];
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
      "nome_reprodutor": nomeReprodutor,
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
    return "InseminacaoCaprino(id:$id, cachaco: $nomeReprodutor, matriz : $nomeMatriz)";
  }
}

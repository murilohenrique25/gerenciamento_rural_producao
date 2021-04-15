class InseminacaoEquino {
  int id;
  int idEgua;
  String nomeEgua;
  int idSemen;
  String nomeCavalo;
  String data;
  String observacao;
  String inseminador;
  String tipoReproducao;
  String palheta;

  InseminacaoEquino();
  InseminacaoEquino.fromMap(Map map) {
    id = map["id"];
    idEgua = map["id_egua"];
    nomeEgua = map["nome_egua"];
    idSemen = map["id_semen"];
    nomeCavalo = map["nome_cavalo"];
    data = map["data"];
    observacao = map["observacao"];
    inseminador = map["inseminador"];
    tipoReproducao = map["tipo_reproducao"];
    palheta = map["palheta"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "id_egua": idEgua,
      "nome_egua": nomeEgua,
      "id_semen": idSemen,
      "nome_cavalo": nomeCavalo,
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
    return "Inseminacao(id:$id, cavalo: $nomeCavalo, egua : $nomeEgua)";
  }
}

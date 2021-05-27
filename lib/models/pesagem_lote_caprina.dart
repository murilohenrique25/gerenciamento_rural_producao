class PesagemLoteCaprina {
  int id;
  String lote;
  String baia;
  String data;
  double peso;
  String animal;
  double media;
  String observacao;

  PesagemLoteCaprina();
  PesagemLoteCaprina.fromMap(Map map) {
    id = map["id"];
    lote = map["lote"];
    data = map["data"];
    peso = map["peso"];
    baia = map["baia"];
    animal = map["animal"];
    media = map["media"];
    observacao = map["observacao"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "lote": lote,
      "data": data,
      "peso": peso,
      "animal": animal,
      "media": media,
      "baia": baia,
      "observacao": observacao,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "PesagemLoteCaprina(id:$id, animal: $animal, data : $data)";
  }
}

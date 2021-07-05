import 'package:gerenciamento_rural/models/animal_corte.dart';

class TouroCorte extends AnimalCorte {
  String exameGeral;
  String exameSistemaGenital;
  String perimetroEscrotal;
  String consistenciaEscrotal;
  String glandulasSexuaisAcessorias;
  String regiaoPrepucial;
  String exameObservacao;
  String temperamento;
  String texteLibido;
  String reflexoFleming;
  String capacidadeIdenticarFemeaCio;
  String perseguicaoFemeaPersistencia;
  String tentativasMontas;
  String monta;
  String saltos;
  String avaliacao;
  String tipoAvaliacao;
  String vigor;
  String motilidade;
  String turbilhamento;
  String concentracao;
  String volume;
  String aspecto;
  String celulasNormais;
  String defeitosMenores;
  String defeitosMaiores;
  String cor;
  String dataExame;
  TouroCorte();
  TouroCorte.fromMap(Map map) {
    id = map["id"];
    nome = map["nome"];
    dataNascimento = map["dataNascimento"];
    raca = map["raca"];
    origem = map["origem"];
    idLote = map["id_lote"];
    nomeLote = map["nome_lote"];
    peso = map["peso"];
    cec = map["cec"];
    pai = map["pai"];
    mae = map["mae"];
    situacao = map["situacao"];
    observacao = map["observacao"];
    dataAcontecido = map["data_acontecido"];
    pesoFinal = map["peso_final"];
    comprador = map["comprador"];
    precoVivo = map["preco_vivo"];
    exameGeral = map["exame_geral"];
    exameSistemaGenital = map["exame_sistema_genital"];
    perimetroEscrotal = map["perimetro_escrotal"];
    consistenciaEscrotal = map["consistencia_escrotal"];
    glandulasSexuaisAcessorias = map["glandulas_sexuais_acessorias"];
    regiaoPrepucial = map["regiao_prepucial"];
    exameObservacao = map["exame_observacao"];
    temperamento = map["temperamento"];
    texteLibido = map["texte_libido"];
    reflexoFleming = map["reflexo_fleming"];
    capacidadeIdenticarFemeaCio = map["capacidade_identicar_femea_cio"];
    perseguicaoFemeaPersistencia = map["perseguicao_femea_persistencia"];
    tentativasMontas = map["tentativas_montas"];
    monta = map["monta"];
    saltos = map["saltos"];
    avaliacao = map["avaliacao"];
    tipoAvaliacao = map["tipo_avaliacao"];
    vigor = map["vigor"];
    motilidade = map["motilidade"];
    turbilhamento = map["turbilhamento"];
    concentracao = map["concentracao"];
    volume = map["volume"];
    aspecto = map["aspecto"];
    celulasNormais = map["celulas_normais"];
    defeitosMenores = map["defeitos_menores"];
    defeitosMaiores = map["defeitos_maiores"];
    cor = map["cor"];
    dataExame = map["data_exame"];
    descricao = map["descricao"];
    animalAbatido = map["animal_abatido"];
  }
  Map toMap() {
    Map<String, dynamic> map = {
      "nome": nome,
      "dataNascimento": dataNascimento,
      "raca": raca,
      "origem": origem,
      "peso": peso,
      "nome_lote": nomeLote,
      "id_lote": idLote,
      "pai": pai,
      "mae": mae,
      "cec": cec,
      "situacao": situacao,
      "observacao": observacao,
      "data_acontecido": dataAcontecido,
      "peso_final": pesoFinal,
      "comprador": comprador,
      "preco_vivo": precoVivo,
      "exame_geral": exameGeral,
      "exame_sistema_genital": exameSistemaGenital,
      "perimetro_escrotal": perimetroEscrotal,
      "consistencia_escrotal": consistenciaEscrotal,
      "glandulas_sexuais_acessorias": glandulasSexuaisAcessorias,
      "regiao_prepucial": regiaoPrepucial,
      "exame_observacao": exameObservacao,
      "temperamento": temperamento,
      "texte_libido": texteLibido,
      "reflexo_fleming": reflexoFleming,
      "capacidade_identicar_femea_cio": capacidadeIdenticarFemeaCio,
      "perseguicao_femea_persistencia": perseguicaoFemeaPersistencia,
      "tentativas_montas": tentativasMontas,
      "monta": monta,
      "saltos": saltos,
      "avaliacao": avaliacao,
      "tipo_avaliacao": tipoAvaliacao,
      "vigor": vigor,
      "motilidade": motilidade,
      "turbilhamento": turbilhamento,
      "concentracao": concentracao,
      "volume": volume,
      "aspecto": aspecto,
      "celulas_normais": celulasNormais,
      "defeitos_menores": defeitosMenores,
      "defeitos_maiores": defeitosMaiores,
      "cor": cor,
      "data_exame": dataExame,
      "descricao": descricao,
      "animal_abatido": animalAbatido,
    };
    if (id != null) {
      map["id"] = id;
    }
    return map;
  }
}

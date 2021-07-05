import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/corte_abatidos_db.dart';
import 'package:gerenciamento_rural/helpers/lote_db.dart';
import 'package:gerenciamento_rural/helpers/touro_corte_db.dart';
import 'package:gerenciamento_rural/models/corte_abatidos.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/models/touro_corte.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroTouroCorte extends StatefulWidget {
  final TouroCorte touro;

  CadastroTouroCorte({this.touro});
  @override
  _CadastroTouroCorteState createState() => _CadastroTouroCorteState();
}

class _CadastroTouroCorteState extends State<CadastroTouroCorte> {
  LoteDB helperLote = LoteDB();
  List<Lote> lotes = [];
  final _nameFocus = FocusNode();
  Lote lote = Lote();
  bool _touroEdited = false;
  TouroCorte _editedTouro;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _origemController = TextEditingController();
  final _pesoController = TextEditingController();
  final _pesoFinalController = TextEditingController();
  final _compradorController = TextEditingController();
  final _precoVivoController = TextEditingController();
  final _observacaoController = TextEditingController();
  final _cecController = TextEditingController();
  final _exameGeralController = TextEditingController();
  final _exameSistemaGenitalController = TextEditingController();
  final _perimetroEscrotalController = TextEditingController();
  final _consistenciaEscrotalController = TextEditingController();
  final _glandulasSexuaisController = TextEditingController();
  final _regiaoPrepucialController = TextEditingController();
  final _exameObservacaoController = TextEditingController();
  final _temperamentoController = TextEditingController();
  final _reflexoFlemingController = TextEditingController();
  final _capacidadeIdenticarFemeaCioController = TextEditingController();
  final _perseguicaoFemeaPersistenciaController = TextEditingController();
  final _tentativasMontasController = TextEditingController();
  final _saltosController = TextEditingController();
  final _vigorController = TextEditingController();
  final _motilidadeController = TextEditingController();
  final _turbilhamentoController = TextEditingController();
  final _concentracaoController = TextEditingController();
  final _volumeController = TextEditingController();
  final _aspectoController = TextEditingController();
  final _celulasNormaisController = TextEditingController();
  final _defeitoMenoresController = TextEditingController();
  final _defeitomaioresController = TextEditingController();
  final _corController = TextEditingController();
  final _tipoAvaliacaoController = TextEditingController();

  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  var _dataAcontecidoController = MaskedTextController(mask: '00-00-0000');
  var _dataExameController = MaskedTextController(mask: '00-00-0000');

  final df = new DateFormat("dd-MM-yyyy");

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  int _radioValue = 0;
  int _radioValueAvaliacao = 0;
  String numeroData;
  String idadeFinal = "";
  String _idadeAnimal = "";
  String loteSelecionado = "";

  void _reset() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getAllLotes();
    if (widget.touro == null) {
      _editedTouro = TouroCorte();
      _editedTouro.situacao = "Vivo";
      _editedTouro..animalAbatido = 0;
    } else {
      _editedTouro = TouroCorte.fromMap(widget.touro.toMap());
      _nomeController.text = _editedTouro.nome;
      _racaController.text = _editedTouro.raca;
      _paiController.text = _editedTouro.pai;
      _maeController.text = _editedTouro.mae;
      _pesoController.text = _editedTouro.peso.toString();
      _origemController.text = _editedTouro.origem;
      loteSelecionado = _editedTouro.nomeLote;
      _observacaoController.text = _editedTouro.observacao;

      _cecController.text = _editedTouro.cec;
      _exameGeralController.text = _editedTouro.exameGeral;
      _exameSistemaGenitalController.text = _editedTouro.exameSistemaGenital;
      _perimetroEscrotalController.text = _editedTouro.perimetroEscrotal;
      _consistenciaEscrotalController.text = _editedTouro.consistenciaEscrotal;
      _glandulasSexuaisController.text =
          _editedTouro.glandulasSexuaisAcessorias;
      _regiaoPrepucialController.text = _editedTouro.regiaoPrepucial;
      _exameObservacaoController.text = _editedTouro.exameObservacao;
      _temperamentoController.text = _editedTouro.temperamento;
      _reflexoFlemingController.text = _editedTouro.reflexoFleming;
      _capacidadeIdenticarFemeaCioController.text =
          _editedTouro.capacidadeIdenticarFemeaCio;
      _perseguicaoFemeaPersistenciaController.text =
          _editedTouro.perseguicaoFemeaPersistencia;
      _tentativasMontasController.text = _editedTouro.tentativasMontas;
      _saltosController.text = _editedTouro.saltos;
      _vigorController.text = _editedTouro.vigor;
      _motilidadeController.text = _editedTouro.motilidade;
      _turbilhamentoController.text = _editedTouro.turbilhamento;
      _concentracaoController.text = _editedTouro.concentracao;
      _volumeController.text = _editedTouro.volume;
      _aspectoController.text = _editedTouro.aspecto;
      _celulasNormaisController.text = _editedTouro.celulasNormais;
      _defeitoMenoresController.text = _editedTouro.defeitosMenores;
      _defeitomaioresController.text = _editedTouro.defeitosMaiores;
      _corController.text = _editedTouro.cor;
      _tipoAvaliacaoController.text = _editedTouro.tipoAvaliacao;

      numeroData = _editedTouro.dataNascimento;
      _dataNasc.text = numeroData;
      if (_editedTouro.situacao == "Vivo") {
        _radioValue = 0;
      } else if (_editedTouro.situacao == "Morto") {
        _radioValue = 1;
      } else {
        _radioValue = 2;
      }
      idadeFinal = differenceDate();
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pedigree'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _paiController,
                  decoration: InputDecoration(labelText: "Pai"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.pai = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.mae = text;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Feito'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMortoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Causa Morte'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _descricaoController,
                  decoration: InputDecoration(labelText: "Causa"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.dataAcontecido = text;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Feito'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAbatidoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Abatido'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.dataAcontecido = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoFinalController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.pesoFinal = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _compradorController,
                  decoration: InputDecoration(labelText: "Comprador"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.comprador = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _precoVivoController,
                  decoration: InputDecoration(labelText: "Preço Vivo/@"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.precoVivo = double.parse(text);
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Feito'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        key: _scaffoldstate,
        appBar: AppBar(
          title: Text(
            _editedTouro.nome ?? "Cadastrar Touro",
            style: TextStyle(fontSize: 15.0),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: _reset,
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_nomeController.text.isEmpty) {
              Toast.show("Nome inválido.", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else if (_dataNasc.text.isEmpty) {
              Toast.show("Data nascimento inválida.", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else {
              if (_editedTouro.situacao == "Abate") {
                TouroCorteDB bezerraCorteDB = TouroCorteDB();
                CorteAbatidosDB corteAbatidosDB = CorteAbatidosDB();
                CortesAbatidos cortesAbatidos = CortesAbatidos();
                cortesAbatidos.categoria = "Touro";
                cortesAbatidos.comprador = _editedTouro.comprador;
                cortesAbatidos.data = _editedTouro.dataAcontecido;
                cortesAbatidos.nomeAnimal = _editedTouro.nome;
                cortesAbatidos.idade = idadeFinal;
                cortesAbatidos.pesoArroba = _editedTouro.pesoFinal;
                cortesAbatidos.precoKgArroba = _editedTouro.precoVivo;
                corteAbatidosDB.insert(cortesAbatidos);
                _editedTouro.animalAbatido = 1;
                bezerraCorteDB.updateItem(_editedTouro);
              }
              Navigator.pop(context, _editedTouro);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.green[700],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.add_circle,
                  size: 80.0,
                  color: Color.fromARGB(255, 4, 125, 141),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _nomeController,
                  focusNode: _nameFocus,
                  decoration: InputDecoration(labelText: "Nome / Nº Brinco"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.nome = text;
                    });
                  },
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      numeroData = _dataNasc.text;
                      _editedTouro.dataNascimento = _dataNasc.text;
                      idadeFinal = differenceDate();
                    });
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text("Idade do animal:  $idadeFinal",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 20.0,
                ),
                SearchableDropdown.single(
                  items: lotes.map((lote) {
                    return DropdownMenuItem(
                      value: lote,
                      child: Row(
                        children: [
                          Text(lote.nome),
                        ],
                      ),
                    );
                  }).toList(),
                  value: lote,
                  hint: "Selecione um Lote",
                  searchHint: "Selecione um Lote",
                  onChanged: (value) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.idLote = value.id;
                      _editedTouro.nomeLote = value.nome;
                      lote = value;
                      loteSelecionado = lote.nome;
                    });
                  },
                  doneButton: "Pronto",
                  displayItem: (item, selected) {
                    return (Row(children: [
                      selected
                          ? Icon(
                              Icons.radio_button_checked,
                              color: Colors.grey,
                            )
                          : Icon(
                              Icons.radio_button_unchecked,
                              color: Colors.grey,
                            ),
                      SizedBox(width: 7),
                      Expanded(
                        child: item,
                      ),
                    ]));
                  },
                  isExpanded: true,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text("Lote:  $loteSelecionado",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _origemController,
                  decoration: InputDecoration(labelText: "Origem"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.origem = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.peso = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _cecController,
                  decoration: InputDecoration(labelText: "CEC"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.cec = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _exameGeralController,
                  decoration: InputDecoration(labelText: "Exame Geral"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.exameGeral = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _exameSistemaGenitalController,
                  decoration:
                      InputDecoration(labelText: "Exame Sistema Genital"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.exameSistemaGenital = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _perimetroEscrotalController,
                  decoration: InputDecoration(labelText: "Perímetro Escrotal"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.perimetroEscrotal = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _consistenciaEscrotalController,
                  decoration:
                      InputDecoration(labelText: "Consistência Escrotal"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.perimetroEscrotal = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _glandulasSexuaisController,
                  decoration: InputDecoration(
                      labelText: "Glândulas Sexuais Acessórias"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.glandulasSexuaisAcessorias = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _regiaoPrepucialController,
                  decoration: InputDecoration(labelText: "Região Prepucial"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.regiaoPrepucial = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _exameObservacaoController,
                  decoration: InputDecoration(labelText: "Exame Observação"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.exameObservacao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _temperamentoController,
                  decoration: InputDecoration(labelText: "Temperamento"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.temperamento = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _reflexoFlemingController,
                  decoration: InputDecoration(labelText: "Reflexo Fleming"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.reflexoFleming = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _capacidadeIdenticarFemeaCioController,
                  decoration: InputDecoration(
                      labelText: "Capacidade Identicar Fêmea no Cio"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.capacidadeIdenticarFemeaCio = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _perseguicaoFemeaPersistenciaController,
                  decoration: InputDecoration(
                      labelText: "Perseguição Fêmea Persistência"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.perseguicaoFemeaPersistencia = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _tentativasMontasController,
                  decoration: InputDecoration(labelText: "Tentativas e Monta"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.tentativasMontas = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _saltosController,
                  decoration: InputDecoration(labelText: "Saltos"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.saltos = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _vigorController,
                  decoration: InputDecoration(labelText: "Vigor"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.vigor = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _motilidadeController,
                  decoration: InputDecoration(labelText: "Motilidade"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.motilidade = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _turbilhamentoController,
                  decoration: InputDecoration(labelText: "Turbilhamento"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.turbilhamento = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _concentracaoController,
                  decoration: InputDecoration(labelText: "Concentração"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.concentracao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _volumeController,
                  decoration: InputDecoration(labelText: "Volume"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.volume = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _aspectoController,
                  decoration: InputDecoration(labelText: "Aspecto"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.aspecto = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _celulasNormaisController,
                  decoration: InputDecoration(labelText: "Células Normais"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.celulasNormais = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _defeitoMenoresController,
                  decoration: InputDecoration(labelText: "Defeitos Menores"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.defeitosMenores = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _defeitomaioresController,
                  decoration: InputDecoration(labelText: "Defeitos Maiores"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.defeitosMaiores = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _corController,
                  decoration: InputDecoration(labelText: "Cor"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.cor = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataExameController,
                  decoration: InputDecoration(labelText: "Data Exame"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.dataExame = text;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 0,
                        groupValue: _radioValueAvaliacao,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueAvaliacao = value;
                            _editedTouro.avaliacao = "Apto";
                          });
                        }),
                    Text("Apto"),
                    Radio(
                        value: 1,
                        groupValue: _radioValueAvaliacao,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueAvaliacao = value;
                            _editedTouro.avaliacao = "Inapto";
                          });
                        }),
                    Text("Inapto"),
                  ],
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _tipoAvaliacaoController,
                  decoration: InputDecoration(labelText: "Descrição Avaliação"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.tipoAvaliacao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _observacaoController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.observacao = text;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: Text("Pedigree"),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 0,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedTouro.situacao = "Vivo";
                          });
                        }),
                    Text("Vivo"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedTouro.situacao = "Morto";
                            if (_editedTouro.situacao == "Morto")
                              _showMortoDialog();
                          });
                        }),
                    Text("Morta"),
                    Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedTouro.situacao = "Abate";
                            if (_editedTouro.situacao == "Abate")
                              _showAbatidoDialog();
                          });
                        }),
                    Text("Abate"),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_touroEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: [
                ElevatedButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: Text("Sim"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
      return Future.value(false);
      // ignore: dead_code
    } else {
      return Future.value(true);
    }
  }

  String differenceDate() {
    String num = "";
    DateTime dt = DateTime.now();
    if (numeroData.isNotEmpty) {
      num = numeroData.split('-').reversed.join();
    }

    DateTime date = DateTime.parse(num);
    int quant = dt.difference(date).inDays;
    if (quant < 0) {
      _idadeAnimal = "Data incorreta";
    } else if (quant < 365) {
      _idadeAnimal = "$quant dias";
    } else if (quant == 365) {
      _idadeAnimal = "1 ano";
    } else if (quant > 365 && quant < 731) {
      int dias = quant - 365;
      _idadeAnimal = "1 ano e $dias dias";
    } else if (quant > 731 && quant < 1096) {
      int dias = quant - 731;
      _idadeAnimal = "2 ano e $dias dias";
    } else if (quant > 1095 && quant < 1461) {
      int dias = quant - 1095;
      _idadeAnimal = "3 ano e $dias dias";
    } else if (quant > 1460 && quant < 1826) {
      int dias = quant - 1460;
      _idadeAnimal = "4 ano e $dias dias";
    } else if (quant > 1825 && quant < 2191) {
      int dias = quant - 1825;
      _idadeAnimal = "5 ano e $dias dias";
    } else if (quant > 2190 && quant < 2.556) {
      int dias = quant - 2190;
      _idadeAnimal = "6 ano e $dias dias";
    }
    return _idadeAnimal;
  }

  void _getAllLotes() {
    helperLote.getAllItems().then((list) {
      setState(() {
        lotes = list;
      });
    });
  }
}

class Item {
  const Item(this.name);
  final String name;
}

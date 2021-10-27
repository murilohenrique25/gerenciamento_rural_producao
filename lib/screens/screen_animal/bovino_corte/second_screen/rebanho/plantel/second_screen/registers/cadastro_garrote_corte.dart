import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/corte_abatidos_db.dart';
import 'package:gerenciamento_rural/helpers/garrote_corte_db.dart';
import 'package:gerenciamento_rural/helpers/lote_bovino_corte_db.dart';
import 'package:gerenciamento_rural/models/corte_abatidos.dart';
import 'package:gerenciamento_rural/models/garrote_corte.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class CadastroGarroteCorte extends StatefulWidget {
  final GarroteCorte garrote;

  CadastroGarroteCorte({this.garrote});
  @override
  _CadastroGarroteCorteState createState() => _CadastroGarroteCorteState();
}

class _CadastroGarroteCorteState extends State<CadastroGarroteCorte> {
  LoteBovinoCorteDB helperLote = LoteBovinoCorteDB();
  List<Lote> lotes = [];
  final _nameFocus = FocusNode();
  Lote lote = Lote();
  bool _garroteEdited = false;
  GarroteCorte _editedGarrote;

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
  final _pesoDesmamaController = TextEditingController();
  final _idadeDesmamaController = TextEditingController();

  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  var _dataAcontecidoController = MaskedTextController(mask: '00-00-0000');

  final df = new DateFormat("dd-MM-yyyy");

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  int _radioValue = 0;
  int groupValueTipo = 0;
  String numeroData;
  String idadeFinal = "";
  String loteSelecionado = "";

  void _reset() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getAllLotes();
    if (widget.garrote == null) {
      _editedGarrote = GarroteCorte();
      _editedGarrote.situacao = "Vivo";
      _editedGarrote..animalAbatido = 0;
    } else {
      _editedGarrote = GarroteCorte.fromMap(widget.garrote.toMap());
      _nomeController.text = _editedGarrote.nome;
      _racaController.text = _editedGarrote.raca;
      _paiController.text = _editedGarrote.pai;
      _maeController.text = _editedGarrote.mae;
      _pesoController.text = _editedGarrote.peso.toString();
      _origemController.text = _editedGarrote.origem;
      loteSelecionado = _editedGarrote.nomeLote;
      _observacaoController.text = _editedGarrote.observacao;
      numeroData = _editedGarrote.dataNascimento;
      _dataNasc.text = numeroData;
      if (_editedGarrote.situacao == "Vivo") {
        _radioValue = 0;
      } else if (_editedGarrote.situacao == "Morto") {
        _radioValue = 1;
      } else {
        _radioValue = 2;
      }
      idadeFinal = calculaIdadeAnimal(numeroData);
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
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.pai = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.mae = text;
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
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.dataAcontecido = text;
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
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.dataAcontecido = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoFinalController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.pesoFinal = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _compradorController,
                  decoration: InputDecoration(labelText: "Comprador"),
                  onChanged: (text) {
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.comprador = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _precoVivoController,
                  decoration: InputDecoration(labelText: "Preço Vivo/@"),
                  onChanged: (text) {
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.precoVivo = double.parse(text);
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
            _editedGarrote.nome ?? "Cadastrar Garrote",
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
              if (_editedGarrote.situacao == "Abate") {
                GarroteCorteDB bezerraCorteDB = GarroteCorteDB();
                CorteAbatidosDB corteAbatidosDB = CorteAbatidosDB();
                CortesAbatidos cortesAbatidos = CortesAbatidos();
                cortesAbatidos.categoria = "Garrote";
                cortesAbatidos.comprador = _editedGarrote.comprador;
                cortesAbatidos.data = _editedGarrote.dataAcontecido;
                cortesAbatidos.nomeAnimal = _editedGarrote.nome;
                cortesAbatidos.idade = idadeFinal;
                cortesAbatidos.pesoArroba = _editedGarrote.pesoFinal;
                cortesAbatidos.precoKgArroba = _editedGarrote.precoVivo;
                corteAbatidosDB.insert(cortesAbatidos);
                _editedGarrote.animalAbatido = 1;
                bezerraCorteDB.updateItem(_editedGarrote);
              }
              Navigator.pop(context, _editedGarrote);
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
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.nome = text;
                    });
                  },
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _garroteEdited = true;
                    setState(() {
                      numeroData = _dataNasc.text;
                      _editedGarrote.dataNascimento = _dataNasc.text;
                      idadeFinal = calculaIdadeAnimal(numeroData);
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
                CustomSearchableDropDown(
                  items: lotes,
                  label: 'Selecione um lote',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: lotes?.map((item) {
                        return item.nome;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    if (value != null) {
                      _editedGarrote.idLote = value.id;
                      _editedGarrote.nomeLote = value.nome;
                      lote = value;
                      loteSelecionado = value.nome;
                    }
                  },
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
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _origemController,
                  decoration: InputDecoration(labelText: "Origem"),
                  onChanged: (text) {
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.origem = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.peso = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoDesmamaController,
                  decoration: InputDecoration(labelText: "Peso Desmama"),
                  onChanged: (text) {
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.peso = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _idadeDesmamaController,
                  decoration: InputDecoration(labelText: "Idade desmama"),
                  onChanged: (text) {
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.peso = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _observacaoController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _garroteEdited = true;
                    setState(() {
                      _editedGarrote.observacao = text;
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
                            _editedGarrote.situacao = "Vivo";
                          });
                        }),
                    Text("Vivo"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedGarrote.situacao = "Morto";
                            if (_editedGarrote.situacao == "Morto")
                              _showMortoDialog();
                          });
                        }),
                    Text("Morto"),
                    Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedGarrote.situacao = "Abate";
                            if (_editedGarrote.situacao == "Abate")
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
    if (_garroteEdited) {
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

  String calculaIdadeAnimal(String dateString) {
    String dataFinal = "";
    if (dateString.length == 10) {
      DateTime data = DateTime.parse(dateString.split('-').reversed.join());
      //data = dateString as DateTime;
      DateTime dataAgora = DateTime.now();
      int ano = (dataAgora.year - data.year);
      int mes = (dataAgora.month - data.month);
      int dia = (dataAgora.day - data.day);
      if (dia < 0) {
        dia = dia + 30;
        mes = mes - 1;
      }
      if (mes < 0) {
        mes = mes + 12;
        ano = ano - 1;
      }
      dataFinal = ano.toString() +
          " anos " +
          mes.toString() +
          " meses " +
          dia.toString() +
          " dias";
    }
    return dataFinal;
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

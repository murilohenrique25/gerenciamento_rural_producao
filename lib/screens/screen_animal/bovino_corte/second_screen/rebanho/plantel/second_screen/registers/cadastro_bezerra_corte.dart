import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/bezerra_corte_db.dart';
import 'package:gerenciamento_rural/helpers/corte_abatidos_db.dart';
import 'package:gerenciamento_rural/helpers/lote_bovino_corte_db.dart';
import 'package:gerenciamento_rural/models/bezerra_corte.dart';
import 'package:gerenciamento_rural/models/corte_abatidos.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class CadastroBezerraCorte extends StatefulWidget {
  final BezerraCorte bezerra;

  CadastroBezerraCorte({this.bezerra});
  @override
  _CadastroBezerraCorteState createState() => _CadastroBezerraCorteState();
}

class _CadastroBezerraCorteState extends State<CadastroBezerraCorte> {
  LoteBovinoCorteDB helperLote = LoteBovinoCorteDB();
  List<Lote> lotes = [];
  final _nameFocus = FocusNode();
  Lote lote = Lote();
  bool _bezEdited = false;
  BezerraCorte _editedBez;

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
  final _cecController = TextEditingController();
  final _pesoDesmamaController = TextEditingController();
  var _dataDesmama = MaskedTextController(mask: '00-00-0000');
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
    if (widget.bezerra == null) {
      _editedBez = BezerraCorte();
      _editedBez.situacao = "Viva";
      _editedBez.animalAbatido = 0;
      _editedBez.virouAdulto = 0;
    } else {
      _editedBez = BezerraCorte.fromMap(widget.bezerra.toMap());
      _nomeController.text = _editedBez.nome;
      _racaController.text = _editedBez.raca;
      _paiController.text = _editedBez.pai;
      _maeController.text = _editedBez.mae;
      _pesoController.text = _editedBez.peso.toString();
      _origemController.text = _editedBez.origem;
      loteSelecionado = _editedBez.nomeLote;
      _cecController.text = _editedBez.cec;
      _pesoDesmamaController.text = _editedBez.pesoDesmama.toString();
      _dataDesmama.text = _editedBez.idadeDesmama;
      numeroData = _editedBez.dataNascimento;
      _dataNasc.text = numeroData;
      if (_editedBez.situacao == "Viva") {
        _radioValue = 0;
      } else if (_editedBez.situacao == "Morta") {
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
                    _bezEdited = true;
                    setState(() {
                      _editedBez.pai = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    _bezEdited = true;
                    setState(() {
                      _editedBez.mae = text;
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
                    _bezEdited = true;
                    setState(() {
                      _editedBez.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _bezEdited = true;
                    setState(() {
                      _editedBez.dataAcontecido = text;
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
                    _bezEdited = true;
                    setState(() {
                      _editedBez.dataAcontecido = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoFinalController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _bezEdited = true;
                    setState(() {
                      _editedBez.pesoFinal = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _compradorController,
                  decoration: InputDecoration(labelText: "Comprador"),
                  onChanged: (text) {
                    _bezEdited = true;
                    setState(() {
                      _editedBez.comprador = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _precoVivoController,
                  decoration: InputDecoration(labelText: "Preço Vivo/@"),
                  onChanged: (text) {
                    _bezEdited = true;
                    setState(() {
                      _editedBez.precoVivo = double.parse(text);
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
            _editedBez.nome ?? "Cadastrar Bezerra",
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
              if (_editedBez.situacao == "Abate") {
                BezerraCorteDB bezerraCorteDB = BezerraCorteDB();
                CorteAbatidosDB corteAbatidosDB = CorteAbatidosDB();
                CortesAbatidos cortesAbatidos = CortesAbatidos();
                cortesAbatidos.categoria = "Bezerra";
                cortesAbatidos.comprador = _editedBez.comprador;
                cortesAbatidos.data = _editedBez.dataAcontecido;
                cortesAbatidos.nomeAnimal = _editedBez.nome;
                cortesAbatidos.idade = idadeFinal;
                cortesAbatidos.pesoArroba = _editedBez.pesoFinal;
                cortesAbatidos.precoKgArroba = _editedBez.precoVivo;
                corteAbatidosDB.insert(cortesAbatidos);
                _editedBez.animalAbatido = 1;
                bezerraCorteDB.updateItem(_editedBez);
              }
              Navigator.pop(context, _editedBez);
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
                    _bezEdited = true;
                    setState(() {
                      _editedBez.nome = text;
                    });
                  },
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _bezEdited = true;
                    setState(() {
                      numeroData = _dataNasc.text;
                      _editedBez.dataNascimento = _dataNasc.text;
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
                      _editedBez.idLote = value.id;
                      _editedBez.nomeLote = value.nome;
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
                    _bezEdited = true;
                    setState(() {
                      _editedBez.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _cecController,
                  decoration: InputDecoration(
                      labelText: "Condição de Escore Corporal (CEC)"),
                  onChanged: (text) {
                    _bezEdited = true;
                    setState(() {
                      _editedBez.cec = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _origemController,
                  decoration: InputDecoration(labelText: "Origem"),
                  onChanged: (text) {
                    _bezEdited = true;
                    setState(() {
                      _editedBez.origem = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _bezEdited = true;
                    setState(() {
                      _editedBez.peso = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoDesmamaController,
                  decoration: InputDecoration(labelText: "Peso Desmama"),
                  onChanged: (text) {
                    _bezEdited = true;
                    setState(() {
                      _editedBez.pesoDesmama = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataDesmama,
                  decoration: InputDecoration(labelText: "Data Desmama"),
                  onChanged: (text) {
                    _bezEdited = true;
                    setState(() {
                      _editedBez.idadeDesmama = text;
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
                            _editedBez.situacao = "Viva";
                          });
                        }),
                    Text("Viva"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedBez.situacao = "Morta";
                            if (_editedBez.situacao == "Morta")
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
                            _editedBez.situacao = "Abate";
                            if (_editedBez.situacao == "Abate")
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
    if (_bezEdited) {
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

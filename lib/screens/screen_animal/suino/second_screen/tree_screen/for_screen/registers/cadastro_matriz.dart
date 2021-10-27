import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/abatidos_db.dart';
import 'package:gerenciamento_rural/models/abatidos.dart';
import 'package:gerenciamento_rural/models/matriz.dart';
import 'package:intl/intl.dart';

import 'package:toast/toast.dart';

class CadastroMatriz extends StatefulWidget {
  final Matriz matriz;
  CadastroMatriz({this.matriz});
  @override
  _CadastroMatrizState createState() => _CadastroMatrizState();
}

class _CadastroMatrizState extends State<CadastroMatriz> {
  String idadeFinal = "";
  String numeroData = "";
  int numPartos = 0;
  String partoPrevisto = "";
  String nomeD = "";
  List<String> diagnosticos = ["Vazia", "Prenha", "Aborto"];
  String diagnostico = "";
  int _radioValue = 0;
  String estado;
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _pesoController = TextEditingController();
  final _maeController = TextEditingController();
  final _precoVendidoController = TextEditingController();
  final _baiaController = TextEditingController();
  final _procedenciaController = TextEditingController();
  final _loteController = TextEditingController();
  final _diasprenhaController = TextEditingController();
  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  var _dataAcontecidoController = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final df = new DateFormat("dd-MM-yyyy");
  bool _matrizEdited = false;
  Matriz _editedMatriz;

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  void _reset() {
    setState(() {
      _formKey = GlobalKey();
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.matriz == null) {
      _editedMatriz = Matriz();
      _editedMatriz.estado = "Viva";
      _editedMatriz.diagnosticoGestacao = "Vazia";
    } else {
      _editedMatriz = Matriz.fromMap(widget.matriz.toMap());
      _nomeController.text = _editedMatriz.nomeAnimal;
      _racaController.text = _editedMatriz.raca;
      _paiController.text = _editedMatriz.pai;
      _maeController.text = _editedMatriz.mae;
      _procedenciaController.text = _editedMatriz.procedencia;
      if (_editedMatriz.estado == "Viva") {
        _radioValue = 0;
      } else if (_editedMatriz.estado == "Morta") {
        _radioValue = 1;
      } else if (_editedMatriz.estado == "Abatida") {
        _radioValue = 2;
      } else {
        _radioValue = 3;
      }

      partoPrevisto = dataPrevistaPartoString(_editedMatriz.diasPrenha);
      _diasprenhaController.text = _editedMatriz.diasPrenha.toString();
      nomeD = _editedMatriz.diagnosticoGestacao;
      numPartos = _editedMatriz.numeroPartos;
      _baiaController.text = _editedMatriz.baia;
      _loteController.text = _editedMatriz.lote;
      numeroData = _editedMatriz.dataNascimento;
      _dataNasc.text = numeroData;
      idadeFinal = calculaIdadeAnimal(numeroData);
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Genealogia'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _paiController,
                  decoration: InputDecoration(labelText: "Pai"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.pai = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.mae = text;
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
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.dataAcontecido = text;
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

  Future<void> _showVendidoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vendido'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _paiController,
                  decoration: InputDecoration(labelText: "Comprador"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.dataAcontecido = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _precoVendidoController,
                  decoration: InputDecoration(labelText: "Preço"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.precoFinal = double.parse(text);
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
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.dataAcontecido = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.peso = double.parse(text);
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
            "Cadastrar Matriz",
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
              if (_diasprenhaController.text == null) {
                _editedMatriz.diasPrenha = 0;
              }
              if (_editedMatriz.estado != "Viva") {
                AbatidosDB abatidosDB = AbatidosDB();
                Abatido abatido;
                _editedMatriz.estado = "Abatida";
                abatido = Abatido.fromMap(_editedMatriz.toMap());
                abatidosDB.insert(abatido);
                Navigator.pop(context, _editedMatriz);
              } else {
                Navigator.pop(context, _editedMatriz);
              }
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
                  decoration: InputDecoration(labelText: "Nome ou Número"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.nomeAnimal = text;
                    });
                  },
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.dataNascimento = text;
                      numeroData = _dataNasc.text;
                      idadeFinal = calculaIdadeAnimal(numeroData);
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Idade do animal:  $idadeFinal",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.baia = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Origem"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.origem = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _procedenciaController,
                  decoration: InputDecoration(labelText: "Procedência"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.procedencia = text;
                    });
                  },
                ),
                TextField(
                  controller: _loteController,
                  decoration: InputDecoration(labelText: "Lote"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.lote = text;
                    });
                  },
                ),
                CustomSearchableDropDown(
                  items: diagnosticos,
                  label: 'Selecione um diagnóstico',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: diagnosticos?.map((item) {
                        return item;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    _editedMatriz.diagnosticoGestacao = value;
                    nomeD = value;
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Diagnóstico selecionado:  $nomeD",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  enabled: nomeD == "Prenha" ? true : false,
                  keyboardType: TextInputType.number,
                  controller: _diasprenhaController,
                  decoration:
                      InputDecoration(labelText: "Dias que está prenha"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.diasPrenha = int.parse(text);
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Número de partos:  $numPartos",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 20.0,
                ),
                Text("Parto Previsto:  $partoPrevisto",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                ElevatedButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: Text("Genealogia"),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: (int value) {
                        setState(() {
                          _radioValue = value;
                          _editedMatriz.estado = "Viva";
                        });
                      }),
                  Text("Viva"),
                  Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: (int value) {
                        setState(() {
                          _radioValue = value;
                          _editedMatriz.estado = "Morta";
                          if (_editedMatriz.estado == "Morta")
                            _showMortoDialog();
                        });
                      }),
                  Text("Morta"),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedMatriz.estado = "Abatida";
                            if (_editedMatriz.estado == "Abatida")
                              _showAbatidoDialog();
                          });
                        }),
                    Text("Abatida"),
                    Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedMatriz.estado = "Vendida";
                            if (_editedMatriz.estado == "Vendida")
                              _showVendidoDialog();
                          });
                        }),
                    Text("Vendida"),
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
    if (_matrizEdited) {
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

  String dataPrevistaPartoString(int dias) {
    if (_editedMatriz.partoPrevisto == null) {
      return null;
    } else {
      String num = _editedMatriz.partoPrevisto.split('-').reversed.join();
      DateTime dates = DateTime.parse(num);
      DateTime dateParto = dates.add(new Duration(days: -dias));
      var format = new DateFormat("dd-MM-yyyy");
      String dataParto = format.format(dateParto);
      _editedMatriz.partoPrevisto = dataParto;
    }

    return _editedMatriz.partoPrevisto;
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
}

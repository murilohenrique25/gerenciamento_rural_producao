import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/models/cavalo.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class CadastroCavalo extends StatefulWidget {
  final Cavalo cavalo;
  CadastroCavalo({this.cavalo});
  @override
  _CadastroCavaloState createState() => _CadastroCavaloState();
}

class _CadastroCavaloState extends State<CadastroCavalo> {
  String idadeFinal = "";
  String numeroData = "";
  int _radioValue = 0;
  String estado;
  final _nomeController = TextEditingController();
  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  var _dataAcontecidoController = MaskedTextController(mask: '00-00-0000');
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _obsController = TextEditingController();
  final _estadoController = TextEditingController();
  final _origemController = TextEditingController();
  final _loteController = TextEditingController();
  final _baiaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _pelagemController = TextEditingController();
  final _valorVendidoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _compradorController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final df = new DateFormat("dd-MM-yyyy");

  Cavalo _editedCavalo;
  bool _cavaloEdited = false;
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
    if (widget.cavalo == null) {
      _editedCavalo = Cavalo();
      _editedCavalo.vm = "Vivo";
      _radioValue = 0;
    } else {
      _editedCavalo = Cavalo.fromMap(widget.cavalo.toMap());
      _nomeController.text = _editedCavalo.nome;
      if (_editedCavalo.vm == "Vivo") {
        _radioValue = 0;
      } else {
        _radioValue = 1;
      }
      _racaController.text = _editedCavalo.raca;
      _paiController.text = _editedCavalo.pai;
      _maeController.text = _editedCavalo.mae;
      _obsController.text = _editedCavalo.observacao;
      _estadoController.text = _editedCavalo.estado;
      _origemController.text = _editedCavalo.origem;
      _baiaController.text = _editedCavalo.baia;
      _pesoController.text = _editedCavalo.peso.toString();
      _loteController.text = _editedCavalo.lote;
      numeroData = _editedCavalo.dataNascimento;
      _pelagemController.text = _editedCavalo.pelagem;
      _dataNasc.text = numeroData;
      idadeFinal = calculaIdadeAnimal(numeroData);
    }
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
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.dataAcontecido = text;
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
                  controller: _compradorController,
                  decoration: InputDecoration(labelText: "Comprador"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.dataAcontecido = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _valorVendidoController,
                  decoration: InputDecoration(labelText: "Preço"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.valorVendido = double.parse(text);
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
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.pai = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.mae = text;
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
            "Cadastrar Cavalo",
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
              Navigator.pop(context, _editedCavalo);
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
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.nome = text;
                    });
                  },
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.dataNascimento = text;
                      numeroData = _dataNasc.text;
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
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _loteController,
                  decoration: InputDecoration(labelText: "Lote"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.lote = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.baia = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso Kg"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.peso = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _origemController,
                  decoration: InputDecoration(labelText: "Origem"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.origem = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _estadoController,
                  decoration: InputDecoration(labelText: "Estado"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.estado = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pelagemController,
                  decoration: InputDecoration(labelText: "Pelagem"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.pelagem = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _obsController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _cavaloEdited = true;
                    setState(() {
                      _editedCavalo.observacao = text;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: Text("Genealogia"),
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
                            _editedCavalo.vm = "Vivo";
                          });
                        }),
                    Text("Vivo"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedCavalo.vm = "Morto";
                            if (_editedCavalo.vm == "Morto") _showMortoDialog();
                          });
                        }),
                    Text("Morto"),
                    Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedCavalo.vm = "Vendido";
                            if (_editedCavalo.vm == "Vendido")
                              _showVendidoDialog();
                          });
                        }),
                    Text("Vendido"),
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
    if (_cavaloEdited) {
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
}

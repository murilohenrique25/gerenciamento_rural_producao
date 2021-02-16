import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/models/touro.dart';
import 'package:intl/intl.dart';

class CadastroTouro extends StatefulWidget {
  final Touro touro;
  CadastroTouro({this.touro});
  @override
  _CadastroTouroState createState() => _CadastroTouroState();
}

class _CadastroTouroState extends State<CadastroTouro> {
  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  String numeroData;
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _avoMMaternoController = TextEditingController();
  final _avoFMaternoController = TextEditingController();
  final _avoFPaternoController = TextEditingController();
  final _avoMPaternoController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _idadeAnimal = "1 ano";

  String idadeFinal = "";

  bool _touroEdited = false;

  int _radioValue = 0;

  Touro _editedTouro;

  final _nameFocus = FocusNode();

  final df = new DateFormat("dd-MM-yyyy");

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  void _reset() {
    setState(() {
      _formKey = GlobalKey();
      numeroData = "";
      _dataNasc = MaskedTextController(mask: '00-00-0000');
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.touro == null) {
      _editedTouro = Touro();
      _editedTouro.estado = "Vivo";
    } else {
      _editedTouro = Touro.fromMap(widget.touro.toMap());
      _nomeController.text = _editedTouro.nome;
      _racaController.text = _editedTouro.raca;
      _paiController.text = _editedTouro.pai;
      _maeController.text = _editedTouro.mae;
      if (_editedTouro.estado == "Vivo") {
        _radioValue = 0;
      } else {
        _radioValue = 1;
      }
      numeroData = _editedTouro.dataNascimento;
      _dataNasc.text = _editedTouro.dataNascimento;
      _avoMMaternoController.text = _editedTouro.avoMMaterno;
      _avoFMaternoController.text = _editedTouro.avoFMaterno;
      _avoFPaternoController.text = _editedTouro.avoFPaterno;
      _avoMPaternoController.text = _editedTouro.avoMPaterno;
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
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoFPaternoController,
                  decoration: InputDecoration(labelText: "Avó Paterno"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.avoFPaterno = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoMPaternoController,
                  decoration: InputDecoration(labelText: "Avô Paterno"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.avoMPaterno = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoFMaternoController,
                  decoration: InputDecoration(labelText: "Avó Materno"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.avoFMaterno = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoMMaternoController,
                  decoration: InputDecoration(labelText: "Avô Materno"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.avoMMaterno = text;
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
            Navigator.pop(context, _editedTouro);
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
                TextField(
                  controller: _nomeController,
                  focusNode: _nameFocus,
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      _editedTouro.nome = text;
                    });
                  },
                ),
                TextField(
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
                  controller: _dataNasc,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _touroEdited = true;
                    setState(() {
                      numeroData = text;
                      _editedTouro.dataNascimento = text;
                      idadeFinal = differenceDate();
                    });
                  },
                ),
                // TextFormField(
                //   onChanged: (text) {
                //     numeroData = text;
                //     setState(() {
                //       idadeFinal = differenceDate();
                //       print(idadeFinal);
                //     });
                //   },
                //   keyboardType: TextInputType.number,
                //   decoration: InputDecoration(
                //       labelText: "Data de Nascimento",
                //       labelStyle:
                //           TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                //   textAlign: TextAlign.left,
                //   style: TextStyle(
                //       color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                //   controller: _dataNasc,
                //   // ignore: missing_return
                //   validator: (value) {
                //     if (value.isEmpty) {
                //       return "Informe o data denascimento do animal";
                //     }
                //   },
                // ),
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
                RaisedButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: Text("Pedigree"),
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
                            _editedTouro.estado = "Vivo";
                          });
                        }),
                    Text("Vivo"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedTouro.estado = "Morto";
                          });
                        }),
                    Text("Morto"),
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
      _idadeAnimal = "1 ano";
    } else if (quant > 731 && quant < 1096) {
      _idadeAnimal = "2 anos";
    } else if (quant > 1095 && quant < 1461) {
      _idadeAnimal = "3 anos";
    } else if (quant > 1460 && quant < 1826) {
      _idadeAnimal = "4 anos";
    } else if (quant > 1825 && quant < 2191) {
      _idadeAnimal = "5 anos";
    } else if (quant > 2190 && quant < 2556) {
      _idadeAnimal = "6 anos";
    } else {
      _idadeAnimal = "Ohh já está idoso";
    }
    return _idadeAnimal;
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
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
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
}

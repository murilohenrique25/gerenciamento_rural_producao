import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/models/aleitamento.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroCachaco extends StatefulWidget {
  final Aleitamento aleitamento;
  CadastroCachaco({this.aleitamento});
  @override
  _CadastroCachacoState createState() => _CadastroCachacoState();
}

class _CadastroCachacoState extends State<CadastroCachaco> {
  String idadeFinal = "";
  List lotes = [];
  int _radioValue = 0;
  String estado;
  final _nomeController = TextEditingController();
  final _pesoController = TextEditingController();
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _obsController = TextEditingController();
  final _procedenciaController = TextEditingController();
  final _estadoController = TextEditingController();
  final _baiaController = TextEditingController();
  var _dataNasc = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final df = new DateFormat("dd-MM-yyyy");

  String _idadeAnimal = "1ano e 2meses";

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
    _getAllLotes();
    // if (widget.aleitamento == null) {
    //   _editedBezerra = Bezerra();
    //   _editedBezerra.virouNovilha = 0;
    //   _editedBezerra.estado = "Vivo";
    // } else {
    //   _editedBezerra = Bezerra.fromMap(widget.aleitamento.toMap());
    //   _ninhadaController.text = _editedBezerra.nome;
    //   _racaController.text = _editedBezerra.raca;
    //   if (_editedBezerra?.pesoDesmama?.isNaN ?? false) {
    //     _pesoDesmamaController.text = _editedBezerra.pesoDesmama.toString();
    //   }
    //   if (_editedBezerra?.pesoNascimento?.isNaN ?? false) {
    //     _pesoController.text = _editedBezerra.pesoNascimento.toString();
    //   }

    //   _dataDesmamaController.text = _editedBezerra.dataDesmama;
    //   _paiController.text = _editedBezerra.pai;
    //   _maeController.text = _editedBezerra.mae;
    //   if (_editedBezerra.estado == "Vivo") {
    //     _radioValue = 0;
    //   } else {
    //     _radioValue = 1;
    //   }
    //   _avoMMaternoController.text = _editedBezerra.avoMMaterno;
    //   _avoFMaternoController.text = _editedBezerra.avoFMaterno;
    //   _avoFPaternoController.text = _editedBezerra.avoFPaterno;
    //   _avoMPaternoController.text = _editedBezerra.avoMPaterno;
    //   selectedLotes = _editedBezerra.idLote;
    //   numeroData = _editedBezerra.dataNascimento;
    //   _dataNasc.text = numeroData;
    //   idadeFinal = differenceDate();
    // }
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
                  onChanged: (text) {},
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {},
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
            "Cadastrar Cachaço",
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
              // Navigator.pop(context, _editedBezerra);
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
                  onChanged: (text) {},
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   numeroData = _dataNasc.text;
                    //   _editedBezerra.dataNascimento = _dataNasc.text;
                    //   idadeFinal = differenceDate();
                    // });
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
                      value: lote.id,
                      child: Row(
                        children: [
                          Text(lote.name),
                        ],
                      ),
                    );
                  }).toList(),
                  value: "lote",
                  hint: "Selecione um Estado",
                  searchHint: "Selecione um Estado",
                  onChanged: (value) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.idLote = value;
                    //   selectedLotes = value;
                    // });
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
                  height: 10.0,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _procedenciaController,
                  decoration: InputDecoration(labelText: "Procêdencia"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.raca = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.raca = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.raca = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _estadoController,
                  decoration: InputDecoration(labelText: "Estado"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.raca = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.pesoNascimento = double.parse(text);
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _obsController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.dataDesmama = text;
                    // });
                  },
                ),
                RaisedButton(
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
                            estado = "Vivo";
                          });
                        }),
                    Text("Vivo"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            estado = "Morto";
                          });
                        }),
                    Text("Morto"),
                    Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            estado = "Vendido";
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
    if (false) {
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

  String differenceDate() {
    String num = "";
    DateTime dt = DateTime.now();
    // if (numeroData.isNotEmpty) {
    //   num = numeroData.split('-').reversed.join();
    // }

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
    // helperLote.getAllItems().then((list) {
    //   setState(() {
    //     lotes = list;
    //   });
    // });
  }
}

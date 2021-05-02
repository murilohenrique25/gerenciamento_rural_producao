import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/models/cavalo.dart';
import 'package:gerenciamento_rural/models/potro.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroJovemMacho extends StatefulWidget {
  final Potro potro;
  CadastroJovemMacho({this.potro});
  @override
  _CadastroJovemMachoState createState() => _CadastroJovemMachoState();
}

class _CadastroJovemMachoState extends State<CadastroJovemMacho> {
  String idadeFinal = "";
  String numeroData = "";
  int _radioValue = 0;
  int _radioValueSetor = 0;
  String estado;
  List<String> situacao = ["Jovens Fêmeas", "Abatido", "Matriz"];
  final _nomeController = TextEditingController();
  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  var _dataDesmamaController = MaskedTextController(mask: '00-00-0000');
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _baiaController = TextEditingController();
  final _loteController = TextEditingController();
  final _origemController = TextEditingController();
  final _obsController = TextEditingController();
  final _pesoDesmamaController = TextEditingController();
  final _pesoNascimentoController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final df = new DateFormat("dd-MM-yyyy");

  String _idadeAnimal = "1ano e 2meses";
  Cavalo _editedCavalo;
  bool _cachadoEdited = false;
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
    if (widget.potro == null) {
      _editedCavalo = Cavalo();
      _editedCavalo.vm = "Vivo";
      _radioValue = 0;
    } else {
      _editedCavalo = Cavalo.fromMap(widget.potro.toMap());
      _nomeController.text = _editedCavalo.nome;
      if (_editedCavalo.vm == "Vivo") {
        _radioValue = 0;
      } else {
        _radioValue = 1;
      }
      _racaController.text = _editedCavalo.raca;
      _paiController.text = _editedCavalo.pai;
      _maeController.text = _editedCavalo.mae;
      _baiaController.text = _editedCavalo.observacao;
      _loteController.text = _editedCavalo.estado;
      _origemController.text = _editedCavalo.origem;
      numeroData = _editedCavalo.dataNascimento;
      _dataNasc.text = numeroData;
      idadeFinal = differenceDate();
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
                    _cachadoEdited = true;
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
                    _cachadoEdited = true;
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
            "Cadastrar Jovem Fêmea",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 0,
                        groupValue: _radioValueSetor,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueSetor = value;
                            _editedCavalo.vm = "Caprino";
                          });
                        }),
                    Text("Caprino"),
                    Radio(
                        value: 1,
                        groupValue: _radioValueSetor,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueSetor = value;
                            _editedCavalo.vm = "Ovino";
                          });
                        }),
                    Text("Ovino"),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: "Nome ou Nº Brinco"),
                  onChanged: (text) {
                    _cachadoEdited = true;
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
                    _cachadoEdited = true;
                    setState(() {
                      _editedCavalo.dataNascimento = text;
                      numeroData = _dataNasc.text;
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
                SearchableDropdown.single(
                  items: situacao.map((estado) {
                    return DropdownMenuItem(
                      value: estado,
                      child: Row(
                        children: [
                          Text(estado),
                        ],
                      ),
                    );
                  }).toList(),
                  value: estado,
                  hint: "Selecione uma situação",
                  searchHint: "Selecione uma situação",
                  onChanged: (value) {
                    // _crecheEdited = true;
                    setState(() {
                      // _editedCreche.estado = value;
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
                  height: 10.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    _cachadoEdited = true;
                    setState(() {
                      _editedCavalo.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _origemController,
                  decoration: InputDecoration(labelText: "Origem"),
                  onChanged: (text) {
                    _cachadoEdited = true;
                    setState(() {
                      _editedCavalo.origem = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _loteController,
                  decoration: InputDecoration(labelText: "Lote"),
                  onChanged: (text) {
                    _cachadoEdited = true;
                    setState(() {
                      _editedCavalo.estado = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _cachadoEdited = true;
                    setState(() {
                      _editedCavalo.observacao = text;
                    });
                  },
                ),
                TextField(
                  controller: _dataDesmamaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data da desmama"),
                  onChanged: (text) {
                    _cachadoEdited = true;
                    setState(() {
                      _editedCavalo.dataNascimento = text;
                      numeroData = _dataNasc.text;
                      idadeFinal = differenceDate();
                    });
                  },
                ),
                TextField(
                  controller: _pesoNascimentoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Peso ao Nascimento"),
                  onChanged: (text) {
                    _cachadoEdited = true;
                    setState(() {
                      _editedCavalo.dataNascimento = text;
                      numeroData = _dataNasc.text;
                      idadeFinal = differenceDate();
                    });
                  },
                ),
                TextField(
                  controller: _pesoDesmamaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Peso na desmama"),
                  onChanged: (text) {
                    _cachadoEdited = true;
                    setState(() {
                      _editedCavalo.dataNascimento = text;
                      numeroData = _dataNasc.text;
                      idadeFinal = differenceDate();
                    });
                  },
                ),
                TextField(
                  controller: _obsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _cachadoEdited = true;
                    setState(() {
                      _editedCavalo.dataNascimento = text;
                      numeroData = _dataNasc.text;
                      idadeFinal = differenceDate();
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

  Future<bool> _requestPop() {
    if (_cachadoEdited) {
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
}

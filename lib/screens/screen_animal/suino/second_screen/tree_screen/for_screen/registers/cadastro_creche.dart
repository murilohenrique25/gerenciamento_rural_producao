import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/models/cachaco.dart';
import 'package:gerenciamento_rural/models/creche.dart';
import 'package:gerenciamento_rural/models/matriz.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroCreche extends StatefulWidget {
  final Creche creche;
  CadastroCreche({this.creche});
  @override
  _CadastroCrecheState createState() => _CadastroCrecheState();
}

class _CadastroCrecheState extends State<CadastroCreche> {
  String idadeFinal = "";
  List<Matriz> matrizes = List();
  List<Cachaco> cachacos = List();
  List<String> estado = ["Aleitamento", "Creche", "Terminação", "Abatidos"];
  final _ninhadaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _pesoDesmamaController = TextEditingController();
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _obsController = TextEditingController();
  final _identificacaoController = TextEditingController();
  final _sexoMachoController = TextEditingController();
  final _sexoFemeaController = TextEditingController();
  final _vivosController = TextEditingController();
  final _mortosController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _loteController = TextEditingController();
  final _baiaController = TextEditingController();
  var _dataNasc = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _dataDesmamaController = MaskedTextController(mask: '00-00-0000');

  final df = new DateFormat("dd-MM-yyyy");

  String _idadeAnimal = "1ano e 2meses";
  Creche _editedCreche;
  bool _crecheEdited = false;

  Cachaco cachaco = Cachaco();
  Matriz matriz = Matriz();
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
    if (widget.creche == null) {
      _editedCreche = Creche();
      _editedCreche.estado = estado[1];
      _estadoController.text = estado[1];
    } else {
      _editedCreche = Creche.fromMap(widget.creche.toMap());
      _ninhadaController.text = _editedCreche.nomeAnimal;
      _pesoController.text = _editedCreche.pesoNascimento;
      _pesoDesmamaController.text = _editedCreche.pesoDesmama;
      _racaController.text = _editedCreche.raca;
      _paiController.text = _editedCreche.pai;
      _maeController.text = _editedCreche.mae;
      _obsController.text = _editedCreche.observacao;
      _identificacaoController.text = _editedCreche.identificacao;
      _sexoMachoController.text = _editedCreche.sexoM;
      _sexoFemeaController.text = _editedCreche.sexoF;
      _vivosController.text = _editedCreche.vivos;
      _mortosController.text = _editedCreche.mortos;
      _quantidadeController.text = _editedCreche.quantidade.toString();
      _estadoController.text = _editedCreche.estado;
      _loteController.text = _editedCreche.lote;
      _baiaController.text = _editedCreche.baia;
      _dataNasc.text = _editedCreche.dataNascimento;
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Geneologia'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SearchableDropdown.single(
                  items: cachacos.map((cachaco) {
                    return DropdownMenuItem(
                      value: cachaco,
                      child: Row(
                        children: [
                          Text(cachaco.nomeAnimal),
                        ],
                      ),
                    );
                  }).toList(),
                  value: cachaco,
                  hint: "Selecione um cachaço",
                  searchHint: "Selecione um cachaço",
                  onChanged: (value) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.mae = value.nomeAnimal;
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
                SearchableDropdown.single(
                  items: matrizes.map((matriz) {
                    return DropdownMenuItem(
                      value: matriz,
                      child: Row(
                        children: [
                          Text(matriz.nomeAnimal),
                        ],
                      ),
                    );
                  }).toList(),
                  value: matriz,
                  hint: "Selecione uma matriz",
                  searchHint: "Selecione uma matriz",
                  onChanged: (value) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.pai = value.nomeAnimal;
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
            "Cadastrar Aleitamento",
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
            if (_ninhadaController.text.isEmpty) {
              Toast.show("Ninhada inválido.", context,
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
                  controller: _ninhadaController,
                  decoration: InputDecoration(labelText: "Ninhada"),
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
                TextField(
                  controller: _quantidadeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Quantidade"),
                  onChanged: (text) {},
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
                  items: estado.map((estado) {
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
                  hint: "Selecione um Estado",
                  searchHint: "Selecione um Estado",
                  onChanged: (value) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.estado = value;
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
                  controller: _identificacaoController,
                  decoration: InputDecoration(labelText: "Identificação"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.raca = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _vivosController,
                  decoration: InputDecoration(labelText: "Vivos"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.raca = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _mortosController,
                  decoration: InputDecoration(labelText: "Mortos"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.raca = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _sexoMachoController,
                  decoration: InputDecoration(labelText: "Machos"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.raca = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _sexoFemeaController,
                  decoration: InputDecoration(labelText: "Fêmeas"),
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
                  controller: _loteController,
                  decoration: InputDecoration(labelText: "Lote"),
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
                  decoration: InputDecoration(labelText: "Peso ao nascimento"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.pesoNascimento = double.parse(text);
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoDesmamaController,
                  decoration: InputDecoration(labelText: "Peso na desmama"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.pesoDesmama = double.parse(text);
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataDesmamaController,
                  decoration: InputDecoration(labelText: "Data da desmama"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.dataDesmama = text;
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
                  child: Text("Geneologia"),
                ),
                SizedBox(
                  height: 15.0,
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
    if (_crecheEdited) {
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

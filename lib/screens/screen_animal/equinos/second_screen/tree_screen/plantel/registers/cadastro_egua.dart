import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/models/egua.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroEgua extends StatefulWidget {
  final Egua egua;
  CadastroEgua({this.egua});
  @override
  _CadastroEguaState createState() => _CadastroEguaState();
}

class _CadastroEguaState extends State<CadastroEgua> {
  String idadeFinal = "";
  String numeroData = "";
  String nomeEstado = "";
  String partoPrevisto = "";
  int _radioValue = 0;
  String nomeD = "";
  String diagnostic = "";
  List<String> diagnosticos = ["Vazia", "Prenha", "Aborto"];
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _obsController = TextEditingController();
  final _ciosController = TextEditingController();
  final _valorVendidoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _origemController = TextEditingController();
  final _estadoController = TextEditingController();
  final _diasprenhaController = TextEditingController();
  final _tdPartosController = TextEditingController();
  final _loteController = TextEditingController();
  final _baiaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _pelagemController = TextEditingController();
  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  var _dataAcontecidoController = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final df = new DateFormat("dd-MM-yyyy");

  String _idadeAnimal = "1ano e 2meses";
  Egua _editedEgua;
  bool _eguaEdited = false;

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  void _reset() {
    setState(() {
      _formKey = GlobalKey();
    });
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
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.dataAcontecido = text;
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
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.dataAcontecido = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _valorVendidoController,
                  decoration: InputDecoration(labelText: "Preço"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.valorVendido = double.parse(text);
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
  void initState() {
    super.initState();
    _getAllLotes();
    if (widget.egua == null) {
      _editedEgua = Egua();
      _editedEgua.vm = "Vivo";
    } else {
      _editedEgua = Egua.fromMap(widget.egua.toMap());
      _nomeController.text = _editedEgua.nome;
      _racaController.text = _editedEgua.raca;
      _paiController.text = _editedEgua.pai;
      _maeController.text = _editedEgua.mae;
      _obsController.text = _editedEgua.observacao;
      _ciosController.text = _editedEgua.cios;
      _origemController.text = _editedEgua.origem;
      _estadoController.text = _editedEgua.estado;
      _baiaController.text = _editedEgua.baia;
      _pesoController.text = _editedEgua.peso.toString();
      _loteController.text = _editedEgua.lote;
      _pelagemController.text = _editedEgua.pelagem;
      _tdPartosController.text = _editedEgua.totalPartos;
      nomeD = _editedEgua.diagnosticoGestacao;
      _diasprenhaController.text = _editedEgua.diasPrenha.toString();
      partoPrevisto = dataPrevistaPartoString(_editedEgua.diasPrenha);
      numeroData = _editedEgua.dataNascimento;
      _dataNasc.text = numeroData;
      idadeFinal = differenceDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        key: _scaffoldstate,
        appBar: AppBar(
          title: Text(
            "Cadastrar Égua",
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
              Toast.show("Ninhada inválido.", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            }
            // else if (_dataNasc.text.isEmpty) {
            //   Toast.show("Data nascimento inválida.", context,
            //       duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            // }
            else {
              Navigator.pop(context, _editedEgua);
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
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.nome = text;
                    });
                  },
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      numeroData = _dataNasc.text;
                      _editedEgua.dataNascimento = _dataNasc.text;
                      idadeFinal = differenceDate();
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Idade do animal:  $idadeFinal",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _origemController,
                  decoration: InputDecoration(labelText: "Origem"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {});
                  },
                ),
                SearchableDropdown.single(
                  items: diagnosticos.map((diagnostic) {
                    return DropdownMenuItem(
                      value: diagnostic,
                      child: Row(
                        children: [
                          Text(diagnostic),
                        ],
                      ),
                    );
                  }).toList(),
                  value: diagnostic,
                  hint: "Selecione um diagnostico",
                  searchHint: "Selecione um diagnostico",
                  onChanged: (value) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.diagnosticoGestacao = value;
                      nomeD = value;
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
                  keyboardType: TextInputType.text,
                  controller: _loteController,
                  decoration: InputDecoration(labelText: "Lote"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.lote = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.baia = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso Kg"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.peso = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _estadoController,
                  decoration: InputDecoration(labelText: "Estado"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.estado = text;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Parto previsto :  $partoPrevisto",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color.fromARGB(255, 4, 125, 141),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _ciosController,
                  decoration: InputDecoration(labelText: "Cios"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.cios = text;
                    });
                  },
                ),
                TextField(
                  enabled: nomeD == "Prenha" ? true : false,
                  keyboardType: TextInputType.number,
                  controller: _diasprenhaController,
                  decoration:
                      InputDecoration(labelText: "Dias que está prenha"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.diasPrenha = int.parse(text);
                      partoPrevisto = dataPrevistaPartoString(int.parse(text));
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pelagemController,
                  decoration: InputDecoration(labelText: "Pelagem"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.pelagem = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _obsController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.observacao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _tdPartosController,
                  decoration: InputDecoration(labelText: "Todos os Partos"),
                  onChanged: (text) {
                    _eguaEdited = true;
                    setState(() {
                      _editedEgua.totalPartos = text;
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
                  height: 10.0,
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
                            _editedEgua.vm = "Vivo";
                          });
                        }),
                    Text("Vivo"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedEgua.vm = "Morto";
                            if (_editedEgua.vm == "Morto") _showMortoDialog();
                          });
                        }),
                    Text("Morto"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedEgua.vm = "Vendido";
                            if (_editedEgua.vm == "Vendido")
                              _showVendidoDialog();
                          });
                        }),
                    Text("Vendido"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String dataPrevistaPartoString(int dias) {
    if (_editedEgua.partoPrevisto == null) {
      return null;
    } else {
      String num = _editedEgua.partoPrevisto.split('-').reversed.join();
      DateTime dates = DateTime.parse(num);
      DateTime dateParto = dates.add(new Duration(days: -dias));
      var format = new DateFormat("dd-MM-yyyy");
      String dataParto = format.format(dateParto);
      _editedEgua.partoPrevisto = dataParto;
    }

    return _editedEgua.partoPrevisto;
  }

  Future<bool> _requestPop() {
    if (_eguaEdited) {
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
    // matrizDB.getAllItems().then((value) {
    //   setState(() {
    //     matrizes = value;
    //   });
    // });
    // cachacoDB.getAllItems().then((value) {
    //   setState(() {
    //     cachacos = value;
    //   });
    // });
  }
}

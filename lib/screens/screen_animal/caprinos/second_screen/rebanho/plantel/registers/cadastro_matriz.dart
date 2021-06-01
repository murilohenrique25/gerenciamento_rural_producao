import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/caprino_abatido_db.dart';
import 'package:gerenciamento_rural/helpers/lote_caprino_db.dart';
import 'package:gerenciamento_rural/models/caprino_abatido.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/models/matriz_caprino.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroMatrizCaprino extends StatefulWidget {
  final MatrizCaprino matrizCaprino;
  CadastroMatrizCaprino({this.matrizCaprino});
  @override
  _CadastroMatrizCaprinoState createState() => _CadastroMatrizCaprinoState();
}

class _CadastroMatrizCaprinoState extends State<CadastroMatrizCaprino> {
  LoteCaprinoDB loteCaprinoDB = LoteCaprinoDB();
  Lote lote;
  List<Lote> lotes = [];
  String idadeFinal = "";
  String numeroData = "";
  String nomeEstado = "Vazia";
  String nomePai = "";
  String nomeMae = "";
  String nomeLote = "";
  int _radioValue = 0;
  int _radioValueSetor = 0;
  String nomeD = "";
  String diagnostic = "";
  String ultimainseminacao = "";
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _obsController = TextEditingController();
  final _baiaController = TextEditingController();
  final _origemController = TextEditingController();
  final _pesoController = TextEditingController();
  final _loteController = TextEditingController();
  final _diasprenhaController = TextEditingController();
  final _pesoPrimeiroPartoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _dataAcontecidoController = TextEditingController();
  final _valorVendidoController = TextEditingController();
  final _pesoVendidoController = TextEditingController();
  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  var _idadePrimeiroPartoController = MaskedTextController(mask: '00-00-0000');
  List<String> diagnosticos = ["Vazia", "Prenha", "Aborto"];
  String d;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final df = new DateFormat("dd-MM-yyyy");

  String _idadeAnimal = "1ano e 2meses";
  MatrizCaprino _editedMatriz;
  bool _matrizEdited = false;

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  void _reset() {
    setState(() {
      _formKey = GlobalKey();
    });
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
                    _editedMatriz.pai = text;
                    nomePai = text;
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    _editedMatriz.mae = text;
                    nomeMae = text;
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
                  controller: _valorVendidoController,
                  decoration: InputDecoration(labelText: "Preço"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.valorVendido = double.parse(text);
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

  Future<void> _showDoadoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Doado'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _descricaoController,
                  decoration: InputDecoration(labelText: "Recebedor"),
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
                      _editedMatriz.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoVendidoController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.pesoFinal = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _valorVendidoController,
                  decoration: InputDecoration(labelText: "Preço"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.valorVendido = double.parse(text);
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
  void initState() {
    super.initState();
    getAllLotes();
    if (widget.matrizCaprino == null) {
      _editedMatriz = MatrizCaprino();
      _editedMatriz.situacao = "Vivo";
      _radioValue = 0;
      _editedMatriz.setor = "Caprino";
      _radioValueSetor = 0;
    } else {
      _editedMatriz = MatrizCaprino.fromMap(widget.matrizCaprino.toMap());
      _nomeController.text = _editedMatriz.nomeAnimal;
      _racaController.text = _editedMatriz.raca;
      _paiController.text = _editedMatriz.pai;
      _maeController.text = _editedMatriz.mae;
      _obsController.text = _editedMatriz.observacao;
      _pesoController.text = _editedMatriz.peso.toString();
      _baiaController.text = _editedMatriz.baia;
      _origemController.text = _editedMatriz.origem;
      _loteController.text = _editedMatriz.lote;
      _idadePrimeiroPartoController.text = _editedMatriz.idadePrimeiroParto;
      nomeD = _editedMatriz.diagnosticoGestacao;
      _diasprenhaController.text = _editedMatriz.diasPrenha.toString();
      _descricaoController.text = _editedMatriz.descricao;
      _dataAcontecidoController.text = _editedMatriz.dataAcontecido;
      _valorVendidoController.text = _editedMatriz.valorVendido.toString();
      numeroData = _editedMatriz.dataNascimento;
      _dataNasc.text = numeroData;
      idadeFinal = differenceDate();

      if (_editedMatriz.situacao == "Viva") {
        _radioValue = 0;
      } else if (_editedMatriz.situacao == "Morta") {
        _radioValue = 1;
      } else if (_editedMatriz.situacao == "Vendida") {
        _radioValue = 2;
      } else if (_editedMatriz.situacao == "Doada") {
        _radioValue = 3;
      } else {
        _radioValue = 4;
      }
      if (_editedMatriz.setor == "Caprino") {
        _radioValueSetor = 0;
      } else {
        _radioValueSetor = 1;
      }
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
              Toast.show("Ninhada inválido.", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            }
            // else if (_dataNasc.text.isEmpty) {
            //   Toast.show("Data nascimento inválida.", context,
            //       duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            // }
            else {
              if (_editedMatriz.situacao == "Abatida") {
                CaprinoAbatido caprinoAbatido = CaprinoAbatido();
                CaprinoAbatidoDB caprinoAbatidoDB = CaprinoAbatidoDB();
                caprinoAbatido.idLote = _editedMatriz.idLote;
                caprinoAbatido.nome = _editedMatriz.nomeAnimal;
                caprinoAbatido.peso = _editedMatriz.pesoFinal;
                caprinoAbatido.data = _editedMatriz.dataAcontecido;
                caprinoAbatido.tipo = "Matriz";
                caprinoAbatidoDB.insert(caprinoAbatido);
              }
              Navigator.pop(context, _editedMatriz);
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
                            _editedMatriz.setor = "Caprino";
                          });
                        }),
                    Text("Caprino"),
                    Radio(
                        value: 1,
                        groupValue: _radioValueSetor,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueSetor = value;
                            _editedMatriz.setor = "Ovino";
                          });
                        }),
                    Text("Ovino"),
                  ],
                ),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.nomeAnimal = text;
                    });
                  },
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
                  hint: "Selecione um lote",
                  searchHint: "Selecione um lote",
                  onChanged: (value) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.idLote = value.id;
                      _editedMatriz.lote = value.nome;
                      nomeLote = value.nome;
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
                Text("Lote:  $nomeLote",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      numeroData = _dataNasc.text;
                      _editedMatriz.dataNascimento = _dataNasc.text;
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
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _origemController,
                  decoration: InputDecoration(labelText: "Origem"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.origem = text;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                SearchableDropdown.single(
                  items: diagnosticos.map((d) {
                    return DropdownMenuItem(
                      value: d,
                      child: Row(
                        children: [
                          Text(d),
                        ],
                      ),
                    );
                  }).toList(),
                  value: d,
                  hint: "Selecione um diagnostico",
                  searchHint: "Selecione um diagnostico",
                  onChanged: (value) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.diagnosticoGestacao = value;
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
                Text("Diagnóstico:  $nomeD",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 20.0,
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
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Última inseminação: $ultimainseminacao",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color.fromARGB(255, 4, 125, 141),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Idade 1º parto:  ",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color.fromARGB(255, 4, 125, 141),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Parto previsto:  ",
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
                  controller: _pesoPrimeiroPartoController,
                  decoration: InputDecoration(labelText: "Peso ao 1º parto"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {});
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
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
                  controller: _idadePrimeiroPartoController,
                  decoration: InputDecoration(labelText: "Idade 1º Parto"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.idadePrimeiroParto = text;
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
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _obsController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _matrizEdited = true;
                    setState(() {
                      _editedMatriz.observacao = text;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: Text("Genealogia"),
                ),
                Text("Pai:  $nomePai",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                Text("Mãe:  $nomeMae",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
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
                            _editedMatriz.situacao = "Viva";
                          });
                        }),
                    Text("Viva"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedMatriz.situacao = "Morta";
                            if (_editedMatriz.situacao == "Morta")
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
                            _editedMatriz.situacao = "Vendida";
                            if (_editedMatriz.situacao == "Vendida")
                              _showVendidoDialog();
                          });
                        }),
                    Text("Vendida"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 3,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedMatriz.situacao = "Doada";
                            if (_editedMatriz.situacao == "Doada")
                              _showDoadoDialog();
                          });
                        }),
                    Text("Doada"),
                    Radio(
                        value: 4,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedMatriz.situacao = "Abatida";
                            if (_editedMatriz.situacao == "Abatida")
                              _showAbatidoDialog();
                          });
                        }),
                    Text("Abatida"),
                  ],
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

  void getAllLotes() {
    loteCaprinoDB.getAllItems().then((value) {
      setState(() {
        lotes = value;
      });
    });
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

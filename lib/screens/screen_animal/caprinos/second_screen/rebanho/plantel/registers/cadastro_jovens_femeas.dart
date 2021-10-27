import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/caprino_abatido_db.dart';
import 'package:gerenciamento_rural/helpers/lote_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/matriz_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/todos_caprinos_db.dart';
import 'package:gerenciamento_rural/models/caprino_abatido.dart';
import 'package:gerenciamento_rural/models/jovem_femea_caprino.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/models/matriz_caprino.dart';
import 'package:intl/intl.dart';

import 'package:toast/toast.dart';

class CadastroJovemFemea extends StatefulWidget {
  final JovemFemeaCaprino jovemFemeaCaprino;
  CadastroJovemFemea({this.jovemFemeaCaprino});
  @override
  _CadastroJovemFemeaState createState() => _CadastroJovemFemeaState();
}

class _CadastroJovemFemeaState extends State<CadastroJovemFemea> {
  TodosCaprinosDB todosCaprinosDB = TodosCaprinosDB();
  LoteCaprinoDB loteCaprinoDB = LoteCaprinoDB();

  Lote lote;
  List<Lote> lotes = [];
  String idadeFinal = "";
  String numeroData = "";
  String nomePai = "";
  String nomeMae = "";
  String nomeLote = "";
  int _radioValue = 0;
  int _radioValueSetor = 0;
  String estado;
  final _nomeController = TextEditingController();
  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  var _dataDesmamaController = MaskedTextController(mask: '00-00-0000');
  var _dataAcontecidoController = MaskedTextController(mask: '00-00-0000');
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _baiaController = TextEditingController();
  final _loteController = TextEditingController();
  final _pesoAtualController = TextEditingController();
  final _origemController = TextEditingController();
  final _obsController = TextEditingController();
  final _pesoDesmamaController = TextEditingController();
  final _pesoNascimentoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorVendidoController = TextEditingController();
  final _pesoVendidoController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final df = new DateFormat("dd-MM-yyyy");

  JovemFemeaCaprino _editedJF;
  bool _jfEdited = false;
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
    getAllLotes();
    if (widget.jovemFemeaCaprino == null) {
      _editedJF = JovemFemeaCaprino();
      _editedJF.situacao = "Viva";
      _radioValue = 0;
      _editedJF.setor = "Caprino";
      _radioValueSetor = 0;
      _editedJF.virouAdulto = 0;
    } else {
      _editedJF = JovemFemeaCaprino.fromMap(widget.jovemFemeaCaprino.toMap());
      _nomeController.text = _editedJF.nomeAnimal;
      if (_editedJF.situacao == "Viva") {
        _radioValue = 0;
      } else if (_editedJF.situacao == "Morta") {
        _radioValue = 1;
      } else if (_editedJF.situacao == "Abatida") {
        _radioValue = 2;
      } else {
        _radioValue = 3;
      }

      if (_editedJF.setor == "Caprino") {
        _radioValueSetor = 0;
      } else {
        _radioValueSetor = 1;
      }
      _racaController.text = _editedJF.raca;
      _paiController.text = _editedJF.pai;
      _maeController.text = _editedJF.mae;
      _baiaController.text = _editedJF.baia;
      _loteController.text = _editedJF.lote;
      _pesoAtualController.text = _editedJF.peso.toString();
      _origemController.text = _editedJF.origem;
      _obsController.text = _editedJF.observacao;
      _descricaoController.text = _editedJF.descricao;
      _dataAcontecidoController.text = _editedJF.dataAcontecido;
      _valorVendidoController.text = _editedJF.valorVendido.toString();
      numeroData = _editedJF.dataNascimento;
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
                    _jfEdited = true;
                    setState(() {
                      _editedJF.pai = text;
                      nomePai = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.mae = text;
                      nomeMae = text;
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
                    _jfEdited = true;
                    setState(() {
                      _editedJF.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.dataAcontecido = text;
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
                    _jfEdited = true;
                    setState(() {
                      _editedJF.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.dataAcontecido = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _valorVendidoController,
                  decoration: InputDecoration(labelText: "Preço"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.valorVendido = double.parse(text);
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
                    _jfEdited = true;
                    setState(() {
                      _editedJF.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoVendidoController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.pesoFinal = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _valorVendidoController,
                  decoration: InputDecoration(labelText: "Preço"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.valorVendido = double.parse(text);
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
                    _jfEdited = true;
                    setState(() {
                      _editedJF.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.dataAcontecido = text;
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

  Future<void> _showLBDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Virar Matriz'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
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
                    _editedJF.idLote = value.id;
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.baia = text;
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
              if (_editedJF.situacao != "Viva") {
                CaprinoAbatido caprinoAbatido = CaprinoAbatido();
                CaprinoAbatidoDB caprinoAbatidoDB = CaprinoAbatidoDB();
                caprinoAbatido.idLote = _editedJF.idLote;
                caprinoAbatido.nome = _editedJF.nomeAnimal;
                caprinoAbatido.peso = _editedJF.pesoFinal;
                caprinoAbatido.data = _editedJF.dataAcontecido;
                caprinoAbatido.tipo = "Fêmea Jovem";
                caprinoAbatidoDB.insert(caprinoAbatido);
              }
              if (_editedJF.situacao == "Matriz") {
                MatrizCaprinoDB matrizCaprinoDB = MatrizCaprinoDB();
                MatrizCaprino matrizCaprino =
                    MatrizCaprino.fromMap(_editedJF.toMap());
                matrizCaprinoDB.insert(matrizCaprino);
                _editedJF.virouAdulto = 1;
              }
              Navigator.pop(context, _editedJF);
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
                            _editedJF.setor = "Caprino";
                          });
                        }),
                    Text("Caprino"),
                    Radio(
                        value: 1,
                        groupValue: _radioValueSetor,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueSetor = value;
                            _editedJF.setor = "Ovino";
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
                    _jfEdited = true;
                    setState(() {
                      _editedJF.nomeAnimal = text;
                    });
                  },
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
                      _editedJF.idLote = value.id;
                      _editedJF.lote = value.nome;
                      nomeLote = value.nome;
                    }
                  },
                ),
                SizedBox(
                  height: 5.0,
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
                    _jfEdited = true;
                    setState(() {
                      _editedJF.dataNascimento = text;
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
                    _jfEdited = true;
                    setState(() {
                      _editedJF.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _origemController,
                  decoration: InputDecoration(labelText: "Origem"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.origem = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.baia = text;
                    });
                  },
                ),
                TextField(
                  controller: _dataDesmamaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data da desmama"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.dataDesmama = text;
                    });
                  },
                ),
                TextField(
                  controller: _pesoNascimentoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Peso ao Nascimento"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.pesoNascimento = text;
                    });
                  },
                ),
                TextField(
                  controller: _pesoAtualController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Peso Atual"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.peso = double.parse(text);
                    });
                  },
                ),
                TextField(
                  controller: _pesoDesmamaController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Peso na desmama"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.pesoDesmama = text;
                    });
                  },
                ),
                TextField(
                  controller: _obsController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _jfEdited = true;
                    setState(() {
                      _editedJF.observacao = text;
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
                            _editedJF.situacao = "Viva";
                          });
                        }),
                    Text("Viva"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedJF.situacao = "Morta";
                            if (_editedJF.situacao == "Morta")
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
                            _editedJF.situacao = "Abatida";
                            if (_editedJF.situacao == "Abatida")
                              _showAbatidoDialog();
                          });
                        }),
                    Text("Abatida"),
                    Radio(
                        value: 3,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedJF.situacao = "Matriz";
                            if (_editedJF.situacao == "Matriz") _showLBDialog();
                          });
                        }),
                    Text("Matriz"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 4,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedJF.situacao = "Vendida";
                            if (_editedJF.situacao == "Vendida")
                              _showVendidoDialog();
                          });
                        }),
                    Text("Vendida"),
                    Radio(
                        value: 5,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedJF.situacao = "Doada";
                            if (_editedJF.situacao == "Doada")
                              _showDoadoDialog();
                          });
                        }),
                    Text("Doada"),
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
    if (_jfEdited) {
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

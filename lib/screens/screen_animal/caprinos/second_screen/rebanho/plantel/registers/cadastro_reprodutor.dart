import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/caprino_abatido_db.dart';
import 'package:gerenciamento_rural/helpers/lote_caprino_db.dart';
import 'package:gerenciamento_rural/models/caprino_abatido.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/models/reprodutor.dart';
import 'package:intl/intl.dart';

import 'package:toast/toast.dart';

class CadastroReprodutor extends StatefulWidget {
  final Reprodutor reprodutor;
  CadastroReprodutor({this.reprodutor});
  @override
  _CadastroReprodutorState createState() => _CadastroReprodutorState();
}

class _CadastroReprodutorState extends State<CadastroReprodutor> {
  LoteCaprinoDB loteCaprinoDB = LoteCaprinoDB();
  Lote lote;
  List<Lote> lotes = [];
  String idadeFinal = "";
  String numeroData = "";
  String diagnostico = "";
  String nomePai = "";
  String nomeMae = "";
  String nomeLote = "";
  int _radioValue = 0;
  int _radioValueSetor = 0;
  String estado;
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _loteController = TextEditingController();
  final _baiaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _obsController = TextEditingController();
  final _procedenciaController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorVendidoController = TextEditingController();
  final _pesoVendidoController = TextEditingController();
  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  var _dataAcontecidoController = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final df = new DateFormat("dd-MM-yyyy");
  bool _reprodutorEdited = false;
  Reprodutor _editedReprodutor;

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
    if (widget.reprodutor == null) {
      _editedReprodutor = Reprodutor();
      _editedReprodutor.situacao = "Vivo";
      _radioValue = 0;
      _editedReprodutor.setor = "Caprino";
      _radioValueSetor = 0;
    } else {
      _editedReprodutor = Reprodutor.fromMap(widget.reprodutor.toMap());
      _nomeController.text = _editedReprodutor.nomeAnimal;
      _baiaController.text = _editedReprodutor.baia;
      _racaController.text = _editedReprodutor.raca;
      _pesoController.text = _editedReprodutor.peso.toString();
      nomePai = _editedReprodutor.pai;
      nomeMae = _editedReprodutor.mae;
      nomeLote = _editedReprodutor.lote;
      _procedenciaController.text = _editedReprodutor.procedencia;
      _obsController.text = _editedReprodutor.observacao;
      if (_editedReprodutor.situacao == "Vivo") {
        _radioValue = 0;
      } else if (_editedReprodutor.situacao == "Morto") {
        _radioValue = 1;
      } else if (_editedReprodutor.situacao == "Abatido") {
        _radioValue = 2;
      } else if ((_editedReprodutor.situacao == "Reprodutor")) {
        _radioValue = 0;
      } else {
        _radioValue = 3;
      }
      if (_editedReprodutor.setor == "Caprino") {
        _radioValueSetor = 0;
      } else {
        _radioValueSetor = 1;
      }
      if (_editedReprodutor.valorVendido == null) {
        _valorVendidoController.text = "";
      }
      _descricaoController.text = _editedReprodutor.descricao;
      _dataAcontecidoController.text = _editedReprodutor.dataAcontecido;
      _valorVendidoController.text = _editedReprodutor.valorVendido.toString();
      _loteController.text = _editedReprodutor.lote;
      numeroData = _editedReprodutor.dataNascimento;
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
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.pai = text;
                      nomePai = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.mae = text;
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
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.dataAcontecido = text;
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
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.dataAcontecido = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _valorVendidoController,
                  decoration: InputDecoration(labelText: "Preço"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.dataAcontecido = text;
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
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.dataAcontecido = text;
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
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoVendidoController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.pesoFinal = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _valorVendidoController,
                  decoration: InputDecoration(labelText: "Preço"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.valorVendido = double.parse(text);
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
            "Cadastrar Reprodutor",
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
              if (_editedReprodutor.situacao != "Vivo") {
                CaprinoAbatido caprinoAbatido = CaprinoAbatido();
                CaprinoAbatidoDB caprinoAbatidoDB = CaprinoAbatidoDB();
                caprinoAbatido.idLote = _editedReprodutor.idLote;
                caprinoAbatido.nome = _editedReprodutor.nomeAnimal;
                caprinoAbatido.peso = _editedReprodutor.pesoFinal;
                caprinoAbatido.data = _editedReprodutor.dataAcontecido;
                caprinoAbatido.tipo = "Reprodutor";
                caprinoAbatidoDB.insert(caprinoAbatido);
              }
              if (_editedReprodutor.peso == null) {
                _editedReprodutor.peso = 0;
              }
              Navigator.pop(context, _editedReprodutor);
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
                            _editedReprodutor.setor = "Caprino";
                          });
                        }),
                    Text("Caprino"),
                    Radio(
                        value: 1,
                        groupValue: _radioValueSetor,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueSetor = value;
                            _editedReprodutor.setor = "Ovino";
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
                  decoration: InputDecoration(labelText: "Nome"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.nomeAnimal = text;
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
                      _editedReprodutor.idLote = value.id;
                      _editedReprodutor.lote = value.nome;
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
                  height: 20.0,
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.dataNascimento = text;
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
                  keyboardType: TextInputType.text,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.baia = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.peso = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _procedenciaController,
                  decoration: InputDecoration(labelText: "Procedência"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.procedencia = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _obsController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _reprodutorEdited = true;
                    setState(() {
                      _editedReprodutor.observacao = text;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
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
                            _editedReprodutor.situacao = "Vivo";
                          });
                        }),
                    Text("Vivo"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedReprodutor.situacao = "Morto";
                            if (_editedReprodutor.situacao == "Morto")
                              _showMortoDialog();
                          });
                        }),
                    Text("Morto"),
                    Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedReprodutor.situacao = "Vendido";
                            if (_editedReprodutor.situacao == "Vendido")
                              _showVendidoDialog();
                          });
                        }),
                    Text("Vendido"),
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
                            _editedReprodutor.situacao = "Abatido";
                            if (_editedReprodutor.situacao == "Abatido")
                              _showAbatidoDialog();
                          });
                        }),
                    Text("Abatido"),
                    Radio(
                        value: 4,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedReprodutor.situacao = "Doado";
                            if (_editedReprodutor.situacao == "Doado")
                              _showDoadoDialog();
                          });
                        }),
                    Text("Doado"),
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
    if (_reprodutorEdited) {
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

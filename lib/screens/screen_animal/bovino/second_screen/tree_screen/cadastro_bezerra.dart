import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/bezerra_db.dart';
import 'package:gerenciamento_rural/helpers/lote_db.dart';
import 'package:gerenciamento_rural/models/bezerra.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:intl/intl.dart';
//
import 'package:toast/toast.dart';

class CadastroBezerra extends StatefulWidget {
  final Bezerra bezerra;
  CadastroBezerra({this.bezerra});
  @override
  _CadastroBezerraState createState() => _CadastroBezerraState();
}

class _CadastroBezerraState extends State<CadastroBezerra> {
  LoteDB helperLote = LoteDB();
  List<Lote> lotes = [];
  BezerraDB helper = BezerraDB();
  List<Bezerra> bezerras = [];
  final _nameFocus = FocusNode();

  bool _bezerraEdited = false;
  Bezerra _editedBezerra;
  String idadeFinal = "";
  String numeroData;
  String nomeLote = "";
  Lote lote;
  int _radioValue = 0;

  final _nomeController = TextEditingController();
  final _origemController = TextEditingController();
  final _obsController = TextEditingController();
  final _pesoController = TextEditingController();
  final _cecController = TextEditingController();
  final _pesoDesmamaController = TextEditingController();
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _avoMMaternoController = TextEditingController();
  final _avoFMaternoController = TextEditingController();
  final _avoFPaternoController = TextEditingController();
  final _avoMPaternoController = TextEditingController();

  var _dataNasc = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _dataDesmamaController = MaskedTextController(mask: '00-00-0000');

  final df = new DateFormat("dd-MM-yyyy");

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
    if (widget.bezerra == null) {
      _editedBezerra = Bezerra();
      _editedBezerra.virouNovilha = 0;
      _editedBezerra.estado = "Vivo";
    } else {
      _editedBezerra = Bezerra.fromMap(widget.bezerra.toMap());
      _nomeController.text = _editedBezerra.nome;
      _racaController.text = _editedBezerra.raca;
      if (_editedBezerra?.pesoDesmama?.isNaN ?? false) {
        _pesoDesmamaController.text = _editedBezerra.pesoDesmama.toString();
      }
      if (_editedBezerra?.pesoNascimento?.isNaN ?? false) {
        _pesoController.text = _editedBezerra.pesoNascimento.toString();
      }

      _dataDesmamaController.text = _editedBezerra.dataDesmama;
      _paiController.text = _editedBezerra.pai;
      _maeController.text = _editedBezerra.mae;
      if (_editedBezerra.estado == "Vivo") {
        _radioValue = 0;
      } else {
        _radioValue = 1;
      }
      _avoMMaternoController.text = _editedBezerra.avoMMaterno;
      _avoFMaternoController.text = _editedBezerra.avoFMaterno;
      _avoFPaternoController.text = _editedBezerra.avoFPaterno;
      _avoMPaternoController.text = _editedBezerra.avoMPaterno;
      if (_editedBezerra.idLote != null) lote.id = _editedBezerra.idLote;
      _origemController.text = _editedBezerra.origem;
      _pesoController.text = _editedBezerra.peso.toString();
      _obsController.text = _editedBezerra.observacao;
      _cecController.text = _editedBezerra.cec;
      numeroData = _editedBezerra.dataNascimento;
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
          title: Text('Pedigree'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _paiController,
                  decoration: InputDecoration(labelText: "Pai"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.pai = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.mae = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoFPaternoController,
                  decoration: InputDecoration(labelText: "Avó Paterno"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.avoFPaterno = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoMPaternoController,
                  decoration: InputDecoration(labelText: "Avô Paterno"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.avoMPaterno = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoFMaternoController,
                  decoration: InputDecoration(labelText: "Avó Materno"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.avoFMaterno = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoMMaternoController,
                  decoration: InputDecoration(labelText: "Avô Materno"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.avoMMaterno = text;
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
            _editedBezerra.nome ?? "Cadastrar Bezerra",
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
              Navigator.pop(context, _editedBezerra);
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
                  focusNode: _nameFocus,
                  decoration: InputDecoration(labelText: "Nome / Nº Brinco"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.nome = text;
                    });
                  },
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      numeroData = _dataNasc.text;
                      _editedBezerra.dataNascimento = _dataNasc.text;
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
                SizedBox(
                  height: 20.0,
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
                      _editedBezerra.idLote = value.id;
                      nomeLote = value.nome;
                    }
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Lote:  $nomeLote",
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
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _origemController,
                  decoration: InputDecoration(labelText: "Procedência"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.origem = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.peso = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _cecController,
                  decoration: InputDecoration(labelText: "CEC"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.cec = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _obsController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.observacao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso ao nascimento"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.pesoNascimento = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoDesmamaController,
                  decoration: InputDecoration(labelText: "Peso na desmama"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.pesoDesmama = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataDesmamaController,
                  decoration: InputDecoration(labelText: "Data da desmama"),
                  onChanged: (text) {
                    _bezerraEdited = true;
                    setState(() {
                      _editedBezerra.dataDesmama = text;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: Text("Pedigree"),
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
                            _editedBezerra.estado = "Vivo";
                          });
                        }),
                    Text("Vivo"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedBezerra.estado = "Morto";
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
    if (_bezerraEdited) {
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

  void _getAllLotes() {
    helperLote.getAllItems().then((list) {
      setState(() {
        lotes = list;
      });
    });
  }
}

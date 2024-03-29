import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/lote_db.dart';
import 'package:gerenciamento_rural/helpers/novilha_db.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/models/novilha.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class CadastroNovilha extends StatefulWidget {
  final Novilha novilha;
  CadastroNovilha({this.novilha});
  @override
  _CadastroNovilhaState createState() => _CadastroNovilhaState();
}

class _CadastroNovilhaState extends State<CadastroNovilha> {
  LoteDB helperLote = LoteDB();
  List<Lote> lotes = [];
  NovilhaDB helper = NovilhaDB();
  List<Novilha> novilhas = [];
  final _nameFocus = FocusNode();

  bool _novilhaEdited = false;
  Novilha _editedNovilha;
  String idadeFinal = "";
  String numeroData = "";
  String nomeLote = "";
  Lote lote;
  int _radioValue = 0;
  int _radioValueGestacao = 0;
  final _nomeController = TextEditingController();
  final _pesoController = TextEditingController();
  final _pesoDesmamaController = TextEditingController();
  final _pesoPrimCoberturaController = TextEditingController();
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
  String dataCobertura = "Não inseminada";
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
    if (widget.novilha == null) {
      _editedNovilha = Novilha();
      _editedNovilha.virouVaca = 0;
      _editedNovilha.diagnosticoGestacao = "Vazia";
      _editedNovilha.estado = "Vivo";
    } else {
      _editedNovilha = Novilha.fromMap(widget.novilha.toMap());
      _nomeController.text = _editedNovilha.nome;
      _racaController.text = _editedNovilha.raca;
      if (_editedNovilha?.pesoNascimento?.isNaN ?? false) {
        _pesoController.text = _editedNovilha.pesoNascimento.toString();
      }
      if (_editedNovilha?.pesoDesmama?.isNaN ?? false) {
        _pesoDesmamaController.text = _editedNovilha.pesoDesmama.toString();
      }
      if (_editedNovilha?.pesoPrimeiraCobertura?.isNaN ?? false) {
        _pesoPrimCoberturaController.text =
            _editedNovilha.pesoPrimeiraCobertura.toString();
      }

      _dataDesmamaController.text = _editedNovilha.dataDesmama;

      if (_editedNovilha.estado == "Vivo") {
        _radioValue = 0;
      } else {
        _radioValue = 1;
      }
      if (_editedNovilha.diagnosticoGestacao == "Vazia") {
        _radioValueGestacao = 0;
      } else if (_editedNovilha.diagnosticoGestacao == "Gestante") {
        _radioValueGestacao = 1;
      } else {
        _radioValueGestacao = 2;
      }
      if (_editedNovilha?.dataCobertura?.isNotEmpty ?? false) {
        dataCobertura = _editedNovilha.dataCobertura;
      }
      _paiController.text = _editedNovilha.pai;
      _maeController.text = _editedNovilha.mae;
      _avoMMaternoController.text = _editedNovilha.avoMMaterno;
      _avoFMaternoController.text = _editedNovilha.avoFMaterno;
      _avoFPaternoController.text = _editedNovilha.avoFPaterno;
      _avoMPaternoController.text = _editedNovilha.avoMPaterno;
      lote.id = _editedNovilha.idLote;
      numeroData = _editedNovilha.dataNascimento;
      _dataNasc.text = numeroData;
      idadeFinal = calculaIdadeAnimal(_editedNovilha.dataNascimento);
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
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.pai = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.mae = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoFPaternoController,
                  decoration: InputDecoration(labelText: "Avó Paterno"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.avoFPaterno = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoMPaternoController,
                  decoration: InputDecoration(labelText: "Avô Paterno"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.avoMPaterno = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoFMaternoController,
                  decoration: InputDecoration(labelText: "Avó Materno"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.avoFMaterno = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoMMaternoController,
                  decoration: InputDecoration(labelText: "Avô Materno"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.avoMMaterno = text;
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
            _editedNovilha.nome ?? "Cadastrar Novilha",
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
              Navigator.pop(context, _editedNovilha);
              Toast.show("Salvo!", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
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
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.nome = text;
                    });
                  },
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      numeroData = _dataNasc.text;
                      _editedNovilha.dataNascimento = _dataNasc.text;
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
                      _editedNovilha.idLote = value.id;
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
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso ao nascimento"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.pesoNascimento = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoDesmamaController,
                  decoration: InputDecoration(labelText: "Peso na desmama"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.pesoDesmama = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataDesmamaController,
                  decoration: InputDecoration(labelText: "Data da desmama"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.dataDesmama = text;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Text(
                    "Data primeira cobertura: " + dataCobertura,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141)),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoPrimCoberturaController,
                  decoration:
                      InputDecoration(labelText: "Peso primeira cobertura"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.pesoPrimeiraCobertura = double.parse(text);
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 0,
                        groupValue: _radioValueGestacao,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueGestacao = value;
                            _editedNovilha.diagnosticoGestacao = "Vazia";
                          });
                        }),
                    Text("Vazia"),
                    Radio(
                        value: 1,
                        groupValue: _radioValueGestacao,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueGestacao = value;
                            _editedNovilha.diagnosticoGestacao = "Gestante";
                          });
                        }),
                    Text("Gestante"),
                    Radio(
                        value: 2,
                        groupValue: _radioValueGestacao,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueGestacao = value;
                            _editedNovilha.diagnosticoGestacao = "Aborto";
                          });
                        }),
                    Text("Aborto"),
                  ],
                ),
                SizedBox(
                  height: 20.0,
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
                            _editedNovilha.estado = "Vivo";
                          });
                        }),
                    Text("Vivo"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedNovilha.estado = "Morto";
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
    if (_novilhaEdited) {
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

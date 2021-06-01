import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/lote_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/pesagem_lote_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/todos_caprinos_db.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/models/pesagem_lote_caprina.dart';
import 'package:gerenciamento_rural/models/todoscaprino.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CadastroPesagemLoteCaprino extends StatefulWidget {
  final PesagemLoteCaprina pesagemLoteCaprina;
  CadastroPesagemLoteCaprino({this.pesagemLoteCaprina});
  @override
  _CadastroPesagemLoteCaprinoState createState() =>
      _CadastroPesagemLoteCaprinoState();
}

class _CadastroPesagemLoteCaprinoState
    extends State<CadastroPesagemLoteCaprino> {
  PesagemLoteCaprinaDB _pesagemLoteCaprinaDB = PesagemLoteCaprinaDB();
  LoteCaprinoDB _loteCaprinoDB = LoteCaprinoDB();
  TodosCaprinosDB _todosAnimaisDB = TodosCaprinosDB();
  List<Lote> lotes = [];
  List<TodosCaprino> animais = [];
  Lote lote;
  TodosCaprino animal;
  List<PesagemLoteCaprina> pesagens = [];
  PesagemLoteCaprina pesagemLoteCaprina;
  final loteController = TextEditingController();
  final baiaController = TextEditingController();
  final pesoController = TextEditingController();
  final obsController = TextEditingController();
  String nomeAnimal = "";
  String nomeLote = "";
  bool _producaoCarneEdited = false;
  PesagemLoteCaprina _editedPesagem;
  var data = MaskedTextController(mask: '00-00-0000');

  @override
  void initState() {
    super.initState();
    _getAll();
    if (widget.pesagemLoteCaprina == null) {
      _editedPesagem = PesagemLoteCaprina();
    } else {
      _editedPesagem =
          PesagemLoteCaprina.fromMap(widget.pesagemLoteCaprina.toMap());
      loteController.text = _editedPesagem.lote;
      baiaController.text = _editedPesagem.baia;
      pesoController.text = _editedPesagem.peso.toString();
      data.text = _editedPesagem.data;
      obsController.text = _editedPesagem.observacao;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cadastrar Pesagem"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              Navigator.pop(context, _editedPesagem);
            });
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.green[700],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Form(
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
                    _producaoCarneEdited = true;
                    setState(() {
                      _editedPesagem.lote = value.nome;
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
                SizedBox(
                  height: 5.0,
                ),
                Text("Animal:  $nomeLote",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                TextField(
                  controller: data,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _producaoCarneEdited = true;
                    setState(() {
                      _editedPesagem.data = text;
                    });
                  },
                ),
                TextField(
                  controller: baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _producaoCarneEdited = true;
                    setState(() {
                      _editedPesagem.baia = text;
                    });
                  },
                ),
                SearchableDropdown.single(
                  items: animais.map((animal) {
                    return DropdownMenuItem(
                      value: animal,
                      child: Row(
                        children: [
                          Text(animal.nome),
                        ],
                      ),
                    );
                  }).toList(),
                  value: animal,
                  hint: "Selecione um animal",
                  searchHint: "Selecione um animal",
                  onChanged: (value) {
                    _producaoCarneEdited = true;
                    setState(() {
                      _editedPesagem.animal = value.nome;
                      nomeAnimal = value.nome;
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
                  height: 5.0,
                ),
                Text("Animal:  $nomeAnimal",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                TextField(
                  controller: pesoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Peso Kg"),
                  onChanged: (text) {
                    _producaoCarneEdited = true;
                    setState(() {
                      _editedPesagem.peso = double.parse(text);
                    });
                  },
                ),
                TextField(
                  controller: obsController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _producaoCarneEdited = true;
                    setState(() {
                      _editedPesagem.observacao = text;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getAll() {
    _pesagemLoteCaprinaDB.getAllItems().then((value) {
      setState(() {
        pesagens = value;
      });
    });
    _todosAnimaisDB.getAllItems().then((value) {
      setState(() {
        animais = value;
      });
    });
    _loteCaprinoDB.getAllItems().then((value) {
      setState(() {
        lotes = value;
      });
    });
  }

  Future<bool> _requestPop() {
    if (_producaoCarneEdited) {
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
}

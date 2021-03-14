import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/inventario_semen_db.dart';
import 'package:gerenciamento_rural/helpers/novilha_db.dart';
import 'package:gerenciamento_rural/helpers/vaca_db.dart';
import 'package:gerenciamento_rural/models/inseminacao.dart';
import 'package:gerenciamento_rural/models/inventario_semen.dart';
import 'package:gerenciamento_rural/models/novilha.dart';
import 'package:gerenciamento_rural/models/vaca.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CadastroInseminacao extends StatefulWidget {
  final Inseminacao inseminacao;
  CadastroInseminacao({this.inseminacao});
  @override
  _CadastroInseminacaoState createState() => _CadastroInseminacaoState();
}

class _CadastroInseminacaoState extends State<CadastroInseminacao> {
  //final _nomeVacaController = TextEditingController();
  //final _semenController = TextEditingController();
  final _inseminadorController = TextEditingController();
  final _obsController = TextEditingController();

  var _dataInse = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  VacaDB helperVaca = VacaDB();
  NovilhaDB helperNovilha = NovilhaDB();
  List<Vaca> totalVacas = List();
  List<Novilha> totalNovilhas = List();

  InventarioSemenDB helperInventario = InventarioSemenDB();
  List<InventarioSemen> semens = List();
  bool _inseminacaoEdited = false;
  Inseminacao _editedInseminacao;
  InventarioSemen selectedInseminacao;
  String verificaAnimal;
  Vaca vaca;
  Novilha novilha;
  void _reset() {
    setState(() {
      _formKey = GlobalKey();
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllVacas();
    if (widget.inseminacao == null) {
      _editedInseminacao = Inseminacao();
    } else {
      _editedInseminacao = Inseminacao.fromMap(widget.inseminacao.toMap());
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
            "Cadastrar Inseminação",
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
            selectedInseminacao.quantidade = selectedInseminacao.quantidade - 1;
            helperInventario.updateItem(selectedInseminacao);
            String num = _editedInseminacao.data.split('-').reversed.join();
            DateTime dates = DateTime.parse(num);
            DateTime dateParto = dates.add(new Duration(days: 284));
            DateTime dateSecagem = dates.add(new Duration(days: 222));
            var format = new DateFormat("dd-MM-yyyy");
            String dataParto = format.format(dateParto);
            String dataSecagem = format.format(dateSecagem);

            if (verificaAnimal == "vaca") {
              vaca.ultimaInseminacao = _editedInseminacao.data;
              vaca.partoPrevisto = dataParto;
              vaca.secagemPrevista = dataSecagem;
              helperVaca.updateItem(vaca);
            } else if (verificaAnimal == "novilha") {
              novilha.dataCobertura = _editedInseminacao.data;
              helperNovilha.updateItem(novilha);
            }
            helperInventario.updateItem(selectedInseminacao);

            Navigator.pop(context, _editedInseminacao);
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
                SearchableDropdown.single(
                  items: totalVacas.map((vaca) {
                    return DropdownMenuItem(
                      value: vaca,
                      child: Row(
                        children: [
                          Text(vaca.nome),
                        ],
                      ),
                    );
                  }).toList(),
                  value: vaca,
                  hint: "Selecione uma Vaca",
                  searchHint: "Selecione uma Vaca",
                  onChanged: (value) {
                    setState(() {
                      verificaAnimal = "vaca";
                      vaca = value;
                      _editedInseminacao.idVaca = value.idVaca;
                      _editedInseminacao.nomeVaca = value.nome;
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
                Text("OU"),
                SearchableDropdown.single(
                  items: totalNovilhas.map((novilha) {
                    return DropdownMenuItem(
                      value: novilha,
                      child: Row(
                        children: [
                          Text(novilha.nome),
                        ],
                      ),
                    );
                  }).toList(),
                  value: novilha,
                  hint: "Selecione uma Novilha",
                  searchHint: "Selecione uma Novilha",
                  onChanged: (value) {
                    setState(() {
                      verificaAnimal = "novilha";
                      novilha = value;
                      _editedInseminacao.idVaca = value.idNovilha;
                      _editedInseminacao.nomeVaca = value.nome;
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
                SearchableDropdown.single(
                  items: semens.map((semen) {
                    return DropdownMenuItem(
                      value: semen,
                      child: Row(
                        children: [
                          Text(semen.nomeTouro),
                        ],
                      ),
                    );
                  }).toList(),
                  value: selectedInseminacao,
                  hint: "Selecione um Sêmen",
                  searchHint: "Selecione um Sêmen",
                  onChanged: (value) {
                    setState(() {
                      selectedInseminacao = value;
                      _editedInseminacao.idSemen = value.id;
                      _editedInseminacao.nomeTouro = value.nomeTouro;
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
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Inseminador"),
                  controller: _inseminadorController,
                  onChanged: (value) {
                    setState(() {
                      _editedInseminacao.inseminador = value;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data"),
                  controller: _dataInse,
                  onChanged: (value) {
                    setState(() {
                      _editedInseminacao.data = value;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Observação"),
                  controller: _obsController,
                  onChanged: (value) {
                    setState(() {
                      _editedInseminacao.observacao = value;
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

  Future<bool> _requestPop() {
    if (_inseminacaoEdited) {
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

  void _getAllVacas() {
    helperVaca.getAllItems().then((list) {
      setState(() {
        totalVacas = list;
      });
    });
    helperInventario.getAllItemsEstoque().then((value) {
      setState(() {
        semens = value;
      });
    });
    helperNovilha.getAllItems().then((value) {
      setState(() {
        totalNovilhas = value;
      });
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/bezerra_db.dart';
import 'package:gerenciamento_rural/helpers/medicamento_db.dart';
import 'package:gerenciamento_rural/helpers/novilha_db.dart';
import 'package:gerenciamento_rural/helpers/vaca_db.dart';
import 'package:gerenciamento_rural/models/bezerra.dart';
import 'package:gerenciamento_rural/models/medicamento.dart';
import 'package:gerenciamento_rural/models/novilha.dart';
import 'package:gerenciamento_rural/models/tratamento.dart';
import 'package:gerenciamento_rural/models/vaca.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/medicamentos/tratamento_list.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CadastroTratamento extends StatefulWidget {
  final Tratamento tratamento;
  CadastroTratamento({this.tratamento});
  @override
  _CadastroTratamentoState createState() => _CadastroTratamentoState();
}

class _CadastroTratamentoState extends State<CadastroTratamento> {
  MedicamentoDB medicamentoDB = MedicamentoDB();
  VacaDB vacaDB = VacaDB();
  NovilhaDB novilhaDB = NovilhaDB();
  BezerraDB bezerraDB = BezerraDB();

  List<Vaca> _vacas = List();
  List<Novilha> _novilhas = List();
  List<Bezerra> _bezerras = List();
  List<Medicamento> _medicamento = List();

  String selectedECC;
  final _nomeVacaController = TextEditingController();
  final _idVacaController = TextEditingController();
  final _numeroLoteController = TextEditingController();
  final _enfermidadeController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _viaAplicacaoController = TextEditingController();
  final _duracaoController = TextEditingController();
  var inicioTratamento = MaskedTextController(mask: '00-00-0000');
  var finalTratamento = MaskedTextController(mask: '00-00-0000');
  final _carenciaController = TextEditingController();
  final _obsController = TextEditingController();

  List<TratamentoList> listaMedicamento;
  Vaca vac;
  Novilha nov;
  Bezerra bez;
  Medicamento med;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _tratamentoEdited = false;
  Tratamento _editedTratamento;

  @override
  void initState() {
    super.initState();
    _vacas = List();
    _novilhas = List();
    _bezerras = List();
    _medicamento = List();
    if (widget.tratamento == null) {
      _editedTratamento = Tratamento();
    } else {
      _editedTratamento = Tratamento.fromMap(widget.tratamento.toMap());
      _nomeVacaController.text = _editedTratamento.nomeAnimal;
      _idVacaController.text = _editedTratamento.idAnimal.toString();
      _numeroLoteController.text = _editedTratamento.lote;
      _enfermidadeController.text = _editedTratamento.enfermidade;
      _quantidadeController.text = _editedTratamento.quantidade.toString();
      _viaAplicacaoController.text = _editedTratamento.viaAplicacao;
      _duracaoController.text = _editedTratamento.duracao;
      inicioTratamento.text = _editedTratamento.inicioTratamento;
      finalTratamento.text = _editedTratamento.fimTratamento;
      _carenciaController.text = _editedTratamento.carencia;
      _obsController.text = _editedTratamento.observacao;
    }
    _carregaDados();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Tratamento"),
            centerTitle: true,
            actions: [],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _editedTratamento.tipo = 1;
              Navigator.pop(context, _editedTratamento);
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.green[700],
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.add_circle,
                      size: 80.0,
                      color: Color.fromARGB(255, 4, 125, 141),
                    ),
                    SearchableDropdown.single(
                      items: _vacas.map((vaca) {
                        return DropdownMenuItem(
                          value: vaca,
                          child: Row(
                            children: [
                              Text(vaca.nome),
                            ],
                          ),
                        );
                      }).toList(),
                      value: vac,
                      hint: "Selecione vaca",
                      searchHint: "Selecione vaca",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idAnimal = value.idVaca;
                          _editedTratamento.nomeAnimal = value.nomeVaca;
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
                    Text("OU"),
                    SearchableDropdown.single(
                      items: _novilhas.map((novilha) {
                        return DropdownMenuItem(
                          value: novilha,
                          child: Row(
                            children: [
                              Text(novilha.nome),
                            ],
                          ),
                        );
                      }).toList(),
                      value: nov,
                      hint: "Selecione novilha",
                      searchHint: "Selecione novilha",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idAnimal = value.idNovilha;
                          _editedTratamento.nomeAnimal = value.nome;
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
                    Text("OU"),
                    SearchableDropdown.single(
                      items: _bezerras.map((bezerra) {
                        return DropdownMenuItem(
                          value: bezerra,
                          child: Row(
                            children: [
                              Text(bezerra.nome),
                            ],
                          ),
                        );
                      }).toList(),
                      value: bez,
                      hint: "Selecione bezerra",
                      searchHint: "Selecione bezerra",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idAnimal = value.idBezerra;
                          _editedTratamento.nomeAnimal = value.nome;
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
                    TextField(
                      controller: _numeroLoteController,
                      decoration: InputDecoration(labelText: "Lote"),
                      onChanged: (text) {
                        _tratamentoEdited = true;
                        setState(() {
                          _editedTratamento.lote = text;
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _enfermidadeController,
                      decoration: InputDecoration(labelText: "Enfermidade"),
                      onChanged: (text) {},
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 5.0),
                    SearchableDropdown.single(
                      items: _medicamento.map((medicamento) {
                        return DropdownMenuItem(
                          value: medicamento,
                          child: Row(
                            children: [
                              Text(medicamento.nomeMedicamento),
                            ],
                          ),
                        );
                      }).toList(),
                      value: med,
                      hint: "Selecione um medicamento",
                      searchHint: "Selecione um medicamento",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idMedicamento = value.idMedicamento;
                          _editedTratamento.nomeMedicamento =
                              value.nomeMedicamento;
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
                    TextField(
                      controller: _quantidadeController,
                      decoration: InputDecoration(labelText: "Quantidade"),
                      onChanged: (text) {
                        _tratamentoEdited = true;
                        setState(() {
                          _editedTratamento.quantidade = text as double;
                        });
                      },
                    ),
                    TextField(
                      controller: _viaAplicacaoController,
                      decoration:
                          InputDecoration(labelText: "Via de Aplicação"),
                      onChanged: (text) {
                        _tratamentoEdited = true;
                        setState(() {
                          _editedTratamento.viaAplicacao = text;
                        });
                      },
                    ),
                    TextField(
                      controller: _duracaoController,
                      decoration: InputDecoration(labelText: "Duração"),
                      onChanged: (text) {
                        _tratamentoEdited = true;
                        setState(() {
                          _editedTratamento.duracao = text;
                        });
                      },
                    ),
                    TextField(
                      controller: inicioTratamento,
                      decoration:
                          InputDecoration(labelText: "Início do Tratamento"),
                      onChanged: (text) {
                        _tratamentoEdited = true;
                        setState(() {
                          _editedTratamento.inicioTratamento = text;
                        });
                      },
                    ),
                    TextField(
                      controller: finalTratamento,
                      decoration:
                          InputDecoration(labelText: "Final do Tratamento"),
                      onChanged: (text) {
                        _tratamentoEdited = true;
                        setState(() {
                          _editedTratamento.fimTratamento = text;
                        });
                      },
                    ),
                    TextField(
                      controller: _carenciaController,
                      decoration: InputDecoration(labelText: "Carência"),
                      onChanged: (text) {
                        _tratamentoEdited = true;
                        setState(() {
                          _editedTratamento.carencia = text;
                        });
                      },
                    ),
                    TextField(
                      controller: _obsController,
                      decoration: InputDecoration(labelText: "Observação"),
                      onChanged: (text) {
                        _tratamentoEdited = true;
                        setState(() {
                          _editedTratamento.observacao = text;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<bool> _requestPop() {
    if (_tratamentoEdited) {
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

  void _carregaDados() {
    vacaDB.getAllItems().then((value) {
      setState(() {
        _vacas = value;
      });
    });
    novilhaDB.getAllItems().then((value) {
      setState(() {
        _novilhas = value;
      });
    });
    bezerraDB.getAllItems().then((value) {
      setState(() {
        _bezerras = value;
      });
    });
    medicamentoDB.getAllItems().then((value) {
      setState(() {
        _medicamento = value;
      });
    });
  }
}

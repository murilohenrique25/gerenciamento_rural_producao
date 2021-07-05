import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/bezerra_corte_db.dart';
import 'package:gerenciamento_rural/helpers/bezerro_corte_db.dart';
import 'package:gerenciamento_rural/helpers/garrote_corte_db.dart';
import 'package:gerenciamento_rural/helpers/medicamento_db.dart';
import 'package:gerenciamento_rural/helpers/novilha_corte_db.dart';
import 'package:gerenciamento_rural/helpers/touro_corte_db.dart';
import 'package:gerenciamento_rural/helpers/vaca_corte_db.dart';
import 'package:gerenciamento_rural/models/bezerra_corte.dart';
import 'package:gerenciamento_rural/models/bezerro_corte.dart';
import 'package:gerenciamento_rural/models/garrote_corte.dart';
import 'package:gerenciamento_rural/models/medicamento.dart';
import 'package:gerenciamento_rural/models/novilha_corte.dart';
import 'package:gerenciamento_rural/models/touro_corte.dart';
import 'package:gerenciamento_rural/models/tratamento.dart';
import 'package:gerenciamento_rural/models/vaca_corte.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CadastroTratamentoBovinoCorte extends StatefulWidget {
  final Tratamento tratamento;
  CadastroTratamentoBovinoCorte({this.tratamento});
  @override
  _CadastroTratamentoBovinoCorteState createState() =>
      _CadastroTratamentoBovinoCorteState();
}

class _CadastroTratamentoBovinoCorteState
    extends State<CadastroTratamentoBovinoCorte> {
  TouroCorteDB _touroDB = TouroCorteDB();
  VacaCorteDB _vacaDB = VacaCorteDB();
  BezerraCorteDB _bezerraDB = BezerraCorteDB();
  BezerroCorteDB _bezerroDB = BezerroCorteDB();
  GarroteCorteDB _garroteDB = GarroteCorteDB();
  NovilhaCorteDB _novilhaDB = NovilhaCorteDB();
  MedicamentoDB _medicamentoDB = MedicamentoDB();

  List<Medicamento> _medicamentos = [];
  List<TouroCorte> _touros = [];
  List<VacaCorte> _vacas = [];
  List<BezerraCorte> _bezerras = [];
  List<BezerroCorte> _bezerros = [];
  List<GarroteCorte> _garrotes = [];
  List<NovilhaCorte> _novilhas = [];

  String nomeAnimal = "";
  String nomeMedicamento = "";
  final _nomeAnimalController = TextEditingController();
  final _idAnimalController = TextEditingController();
  final _numeroLoteController = TextEditingController();
  final _enfermidadeController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _viaAplicacaoController = TextEditingController();
  final _duracaoController = TextEditingController();
  var inicioTratamento = MaskedTextController(mask: '00-00-0000');
  var finalTratamento = MaskedTextController(mask: '00-00-0000');
  final _carenciaController = TextEditingController();
  final _obsController = TextEditingController();

  Medicamento med;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _tratamentoEdited = false;
  Tratamento _editedTratamento;
  TouroCorte touro;
  VacaCorte vaca;
  BezerraCorte bezerra;
  BezerroCorte bezerro;
  NovilhaCorte novilha;
  GarroteCorte garrote;

  @override
  void initState() {
    super.initState();
    _touros = [];
    _vacas = [];
    _bezerras = [];
    _bezerros = [];
    _novilhas = [];
    _garrotes = [];
    if (widget.tratamento == null) {
      _editedTratamento = Tratamento();
    } else {
      _editedTratamento = Tratamento.fromMap(widget.tratamento.toMap());
      _nomeAnimalController.text = _editedTratamento.nomeAnimal;
      _idAnimalController.text = _editedTratamento.idAnimal.toString();
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
                      items: _touros.map((touro) {
                        return DropdownMenuItem(
                          value: touro,
                          child: Row(
                            children: [
                              Text(touro.nome),
                            ],
                          ),
                        );
                      }).toList(),
                      value: touro,
                      hint: "Selecione touro",
                      searchHint: "Selecione touro",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nome;
                          nomeAnimal = value.nomel;
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
                      value: vaca,
                      hint: "Selecione vaca",
                      searchHint: "Selecione vaca",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nome;
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
                      value: bezerra,
                      hint: "Selecione bezerra",
                      searchHint: "Selecione bezerra",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nome;
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
                    Text("OU"),
                    SearchableDropdown.single(
                      items: _bezerros.map((bezerro) {
                        return DropdownMenuItem(
                          value: bezerro,
                          child: Row(
                            children: [
                              Text(bezerro.nome),
                            ],
                          ),
                        );
                      }).toList(),
                      value: bezerro,
                      hint: "Selecione bezerro",
                      searchHint: "Selecione bezerro",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nome;
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
                    Text("OU"),
                    SearchableDropdown.single(
                      items: _garrotes.map((garrote) {
                        return DropdownMenuItem(
                          value: garrote,
                          child: Row(
                            children: [
                              Text(garrote.nome),
                            ],
                          ),
                        );
                      }).toList(),
                      value: garrote,
                      hint: "Selecione garrote",
                      searchHint: "Selecione garrote",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nome;
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
                      value: bezerro,
                      hint: "Selecione novilha",
                      searchHint: "Selecione novilha",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nome;
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
                      height: 10.0,
                    ),
                    Text("Animal:  $nomeAnimal",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 4, 125, 141))),
                    SizedBox(
                      height: 10.0,
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
                      keyboardType: TextInputType.text,
                    ),
                    TextField(
                      controller: _enfermidadeController,
                      decoration: InputDecoration(labelText: "Enfermidade"),
                      onChanged: (text) {},
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 5.0),
                    SearchableDropdown.single(
                      items: _medicamentos.map((med) {
                        return DropdownMenuItem(
                          value: med,
                          child: Row(
                            children: [
                              Text(med.nomeMedicamento),
                            ],
                          ),
                        );
                      }).toList(),
                      value: med,
                      hint: "Selecione medicamento",
                      searchHint: "Selecione medicamento",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idMedicamento = value.id;
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
                    TextField(
                      controller: _quantidadeController,
                      decoration: InputDecoration(labelText: "Dose"),
                      onChanged: (text) {
                        _tratamentoEdited = true;
                        setState(() {
                          _editedTratamento.quantidade = double.parse(text);
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

  void _carregaDados() {
    _touroDB.getAllItems().then((value) {
      setState(() {
        _touros = value;
      });
    });
    _vacaDB.getAllItems().then((value) {
      setState(() {
        _vacas = value;
      });
    });
    _bezerraDB.getAllItems().then((value) {
      setState(() {
        _bezerras = value;
      });
    });
    _bezerroDB.getAllItems().then((value) {
      setState(() {
        _bezerros = value;
      });
    });
    _novilhaDB.getAllItems().then((value) {
      setState(() {
        _novilhas = value;
      });
    });
    _garroteDB.getAllItems().then((value) {
      setState(() {
        _garrotes = value;
      });
    });
    _medicamentoDB.getAllItems().then((value) {
      setState(() {
        _medicamentos = value;
      });
    });
  }
}

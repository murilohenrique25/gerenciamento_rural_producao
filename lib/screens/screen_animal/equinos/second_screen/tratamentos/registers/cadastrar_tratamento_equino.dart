import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/cavalo_db.dart';
import 'package:gerenciamento_rural/helpers/egua_db.dart';
import 'package:gerenciamento_rural/helpers/medicamento_equino_db.dart';
import 'package:gerenciamento_rural/helpers/potro_db.dart';
import 'package:gerenciamento_rural/models/cavalo.dart';
import 'package:gerenciamento_rural/models/egua.dart';
import 'package:gerenciamento_rural/models/medicamento.dart';
import 'package:gerenciamento_rural/models/potro.dart';
import 'package:gerenciamento_rural/models/tratamento.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroTratamentoEquino extends StatefulWidget {
  final Tratamento tratamento;
  CadastroTratamentoEquino({this.tratamento});
  @override
  _CadastroTratamentoEquinoState createState() =>
      _CadastroTratamentoEquinoState();
}

class _CadastroTratamentoEquinoState extends State<CadastroTratamentoEquino> {
  MedicamentoEquinoDB medicamentoDB = MedicamentoEquinoDB();
  CavaloDB _cavaloDB = CavaloDB();
  EguaDB _eguaDB = EguaDB();
  PotroDB _potroDB = PotroDB();

  List<Cavalo> _cavalos = [];
  List<Egua> _eguas = [];
  List<Potro> _potros = [];
  List<Medicamento> _medicamentos = [];

  String nomeAnimal = "Vazio";
  String nomeMedicamento = "Vazio";
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
  Cavalo cavalo;
  Egua egua;
  Potro potro;
  @override
  void initState() {
    super.initState();
    _cavalos = [];
    _eguas = [];
    _potros = [];
    _medicamentos = [];
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
              if (med.quantidade >= _editedTratamento.quantidade) {
                med.quantidade = med.quantidade - _editedTratamento.quantidade;
                medicamentoDB.updateItem(med);
                Navigator.pop(context, _editedTratamento);
              } else {
                Toast.show(
                    "Estoque insuficiente.\nEstoque:${med.quantidade}", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
              }
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
                      items: _cavalos.map((cavalo) {
                        return DropdownMenuItem(
                          value: cavalo,
                          child: Row(
                            children: [
                              Text(cavalo.nome),
                            ],
                          ),
                        );
                      }).toList(),
                      value: cavalo,
                      hint: "Selecione cavalo",
                      searchHint: "Selecione cavalo",
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
                      items: _eguas.map((egua) {
                        return DropdownMenuItem(
                          value: egua,
                          child: Row(
                            children: [
                              Text(egua.nome),
                            ],
                          ),
                        );
                      }).toList(),
                      value: egua,
                      hint: "Selecione égua",
                      searchHint: "Selecione égua",
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
                      items: _potros.map((potro) {
                        return DropdownMenuItem(
                          value: potro,
                          child: Row(
                            children: [
                              Text(potro.nome),
                            ],
                          ),
                        );
                      }).toList(),
                      value: egua,
                      hint: "Selecione potro",
                      searchHint: "Selecione potro",
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
                      items: _medicamentos.map((medicamento) {
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
                          med = value;
                          _editedTratamento.idMedicamento = value.id;
                          _editedTratamento.nomeMedicamento =
                              value.nomeMedicamento;
                          nomeMedicamento = value.nomeMedicamento;
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
                    Text("Medicamento selecionado:  $nomeMedicamento",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 4, 125, 141))),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: _quantidadeController,
                      decoration: InputDecoration(labelText: "Quantidade"),
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
    _cavaloDB.getAllItems().then((value) {
      setState(() {
        _cavalos = value;
      });
    });
    _eguaDB.getAllItems().then((value) {
      setState(() {
        _eguas = value;
      });
    });
    _potroDB.getAllItems().then((value) {
      setState(() {
        _potros = value;
      });
    });
    medicamentoDB.getAllItems().then((value) {
      setState(() {
        _medicamentos = value;
      });
    });
  }
}

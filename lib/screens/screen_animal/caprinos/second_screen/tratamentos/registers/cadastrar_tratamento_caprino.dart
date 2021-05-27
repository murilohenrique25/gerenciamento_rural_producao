import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/jovem_femea_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/jovem_macho_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/matriz_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/medicamento_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/reprodutor_db.dart';
import 'package:gerenciamento_rural/models/jovem_femea_caprino.dart';
import 'package:gerenciamento_rural/models/jovem_macho_caprino.dart';
import 'package:gerenciamento_rural/models/matriz_caprino.dart';
import 'package:gerenciamento_rural/models/medicamento.dart';
import 'package:gerenciamento_rural/models/reprodutor.dart';
import 'package:gerenciamento_rural/models/tratamento.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CadastroTratamentoCaprino extends StatefulWidget {
  final Tratamento tratamento;
  CadastroTratamentoCaprino({this.tratamento});
  @override
  _CadastroTratamentoCaprinoState createState() =>
      _CadastroTratamentoCaprinoState();
}

class _CadastroTratamentoCaprinoState extends State<CadastroTratamentoCaprino> {
  ReprodutorDB _reprodutorDB = ReprodutorDB();
  MatrizCaprinoDB _matrizDB = MatrizCaprinoDB();
  JovemFemeaCaprinoDB _jovemFDB = JovemFemeaCaprinoDB();
  JovemMachoCaprinoDB _jovemMDB = JovemMachoCaprinoDB();
  MedicamentoCaprinoDB _medicamentoCaprinoDB = MedicamentoCaprinoDB();

  List<Medicamento> _medicamentos = [];
  List<Reprodutor> _reprodutores = [];
  List<MatrizCaprino> _matrizes = [];
  List<JovemFemeaCaprino> _jovensF = [];
  List<JovemMachoCaprino> _jovensM = [];

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
  Reprodutor reprodutor;
  MatrizCaprino matrizCaprino;
  JovemFemeaCaprino jovemFemeaCaprino;
  JovemMachoCaprino jovemMachoCaprino;

  @override
  void initState() {
    super.initState();
    _reprodutores = [];
    _matrizes = [];
    _jovensF = [];
    _jovensM = [];
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
                      items: _reprodutores.map((reprodutor) {
                        return DropdownMenuItem(
                          value: reprodutor,
                          child: Row(
                            children: [
                              Text(reprodutor.nomeAnimal),
                            ],
                          ),
                        );
                      }).toList(),
                      value: reprodutor,
                      hint: "Selecione reprodutor",
                      searchHint: "Selecione reprodutor",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nomeAnimal;
                          nomeAnimal = value.nomeAnimal;
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
                      items: _matrizes.map((matrizCaprino) {
                        return DropdownMenuItem(
                          value: matrizCaprino,
                          child: Row(
                            children: [
                              Text(matrizCaprino.nomeAnimal),
                            ],
                          ),
                        );
                      }).toList(),
                      value: matrizCaprino,
                      hint: "Selecione matriz",
                      searchHint: "Selecione matriz",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nomeAnimal;
                          nomeAnimal = value.nomeAnimal;
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
                      items: _jovensF.map((jovemFemeaCaprino) {
                        return DropdownMenuItem(
                          value: jovemFemeaCaprino,
                          child: Row(
                            children: [
                              Text(jovemFemeaCaprino.nomeAnimal),
                            ],
                          ),
                        );
                      }).toList(),
                      value: jovemFemeaCaprino,
                      hint: "Selecione jovem fêmea",
                      searchHint: "Selecione jovem fêmea",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nomeAnimal;
                          nomeAnimal = value.nomeAnimal;
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
                      items: _jovensM.map((jovemMachoCaprino) {
                        return DropdownMenuItem(
                          value: jovemMachoCaprino,
                          child: Row(
                            children: [
                              Text(jovemMachoCaprino.nomeAnimal),
                            ],
                          ),
                        );
                      }).toList(),
                      value: jovemMachoCaprino,
                      hint: "Selecione jovem macho",
                      searchHint: "Selecione jovem macho",
                      onChanged: (value) {
                        setState(() {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nomeAnimal;
                          nomeAnimal = value.nomeAnimal;
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
    _reprodutorDB.getAllItems().then((value) {
      setState(() {
        _reprodutores = value;
      });
    });
    _matrizDB.getAllItems().then((value) {
      setState(() {
        _matrizes = value;
      });
    });
    _jovemFDB.getAllItems().then((value) {
      setState(() {
        _jovensF = value;
      });
    });
    _jovemMDB.getAllItems().then((value) {
      setState(() {
        _jovensM = value;
      });
    });
    _medicamentoCaprinoDB.getAllItems().then((value) {
      setState(() {
        _medicamentos = value;
      });
    });
  }
}

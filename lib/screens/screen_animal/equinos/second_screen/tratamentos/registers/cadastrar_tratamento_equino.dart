import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
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
                    CustomSearchableDropDown(
                      items: _cavalos,
                      label: 'Selecione um cavalo',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _cavalos?.map((item) {
                            return item.nome;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        _editedTratamento.idAnimal = value.id;
                        _editedTratamento.nomeAnimal = value.nome;
                        nomeAnimal = value.nome;
                      },
                    ),
                    Text("OU"),
                    CustomSearchableDropDown(
                      items: _eguas,
                      label: 'Selecione uma égua',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _eguas?.map((item) {
                            return item.nome;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        _editedTratamento.idAnimal = value.id;
                        _editedTratamento.nomeAnimal = value.nome;
                        nomeAnimal = value.nome;
                      },
                    ),
                    Text("OU"),
                    CustomSearchableDropDown(
                      items: _potros,
                      label: 'Selecione um potro',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _potros?.map((item) {
                            return item.nome;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        _editedTratamento.idAnimal = value.id;
                        _editedTratamento.nomeAnimal = value.nome;
                        nomeAnimal = value.nome;
                      },
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
                    CustomSearchableDropDown(
                      items: _medicamentos,
                      label: 'Selecione um medicamento',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _medicamentos?.map((item) {
                            return item.nomeMedicamento;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        med = value;
                        _editedTratamento.idMedicamento = value.id;
                        _editedTratamento.nomeMedicamento =
                            value.nomeMedicamento;
                        nomeMedicamento = value.nomeMedicamento;
                      },
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

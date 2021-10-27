import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
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

  List<Vaca> _vacas = [];
  List<Novilha> _novilhas = [];
  List<Bezerra> _bezerras = [];
  List<Medicamento> _medicamento = [];

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
    _vacas = [];
    _novilhas = [];
    _bezerras = [];
    _medicamento = [];
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
                    CustomSearchableDropDown(
                      items: _vacas,
                      label: 'Selecione uma vaca',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _vacas?.map((item) {
                            return item.nome;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        if (value != null) {
                          _editedTratamento.idAnimal = value.idVaca;
                          _editedTratamento.nomeAnimal = value.nome;
                        }
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text("OU"),
                    CustomSearchableDropDown(
                      items: _novilhas,
                      label: 'Selecione uma novilha',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _novilhas?.map((item) {
                            return item.nome;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        if (value != null) {
                          _editedTratamento.idAnimal = value.idNovilha;
                          _editedTratamento.nomeAnimal = value.nome;
                        }
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text("OU"),
                    CustomSearchableDropDown(
                      items: _bezerras,
                      label: 'Selecione uma bezerra',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _bezerras?.map((item) {
                            return item.nome;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        if (value != null) {
                          _editedTratamento.idAnimal = value.idBezerra;
                          _editedTratamento.nomeAnimal = value.nome;
                        }
                      },
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
                      items: _medicamento,
                      label: 'Selecione um medicamento',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _medicamento?.map((item) {
                            return item.nomeMedicamento;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        if (value != null) {
                          _editedTratamento.idMedicamento = value.id;
                          _editedTratamento.nomeMedicamento =
                              value.nomeMedicamento;
                        }
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    TextField(
                      controller: _quantidadeController,
                      decoration: InputDecoration(labelText: "Dose"),
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

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
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
                        _editedTratamento.idAnimal = value.id;
                        _editedTratamento.nomeAnimal = value.nome;
                        nomeAnimal = value.nomel;
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text("OU"),
                    CustomSearchableDropDown(
                      items: _touros,
                      label: 'Selecione um touro',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _touros?.map((item) {
                            return item.nome;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        _editedTratamento.idAnimal = value.id;
                        _editedTratamento.nomeAnimal = value.nome;
                        nomeAnimal = value.nomel;
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
                        _editedTratamento.idAnimal = value.id;
                        _editedTratamento.nomeAnimal = value.nome;
                        nomeAnimal = value.nomel;
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text("OU"),
                    CustomSearchableDropDown(
                      items: _bezerros,
                      label: 'Selecione uma bezerro',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _bezerros?.map((item) {
                            return item.nome;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        _editedTratamento.idAnimal = value.id;
                        _editedTratamento.nomeAnimal = value.nome;
                        nomeAnimal = value.nomel;
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text("OU"),
                    CustomSearchableDropDown(
                      items: _garrotes,
                      label: 'Selecione um garrote',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _garrotes?.map((item) {
                            return item.nome;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        _editedTratamento.idAnimal = value.id;
                        _editedTratamento.nomeAnimal = value.nome;
                        nomeAnimal = value.nomel;
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
                        _editedTratamento.idAnimal = value.id;
                        _editedTratamento.nomeAnimal = value.nome;
                        nomeAnimal = value.nomel;
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
                        _editedTratamento.idMedicamento = value.id;
                        _editedTratamento.nomeMedicamento =
                            value.nomeMedicamento;
                      },
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

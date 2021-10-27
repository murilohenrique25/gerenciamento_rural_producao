import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
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
                    CustomSearchableDropDown(
                      items: _reprodutores,
                      label: 'Selecione reprodutor',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _reprodutores?.map((item) {
                            return item.nomeAnimal;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        if (value != null) {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nomeAnimal;
                          nomeAnimal = value.nomeAnimal;
                        }
                      },
                    ),
                    Text("OU"),
                    CustomSearchableDropDown(
                      items: _matrizes,
                      label: 'Selecione matriz',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _matrizes?.map((item) {
                            return item.nomeAnimal;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        if (value != null) {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nomeAnimal;
                          nomeAnimal = value.nomeAnimal;
                        }
                      },
                    ),
                    Text("OU"),
                    CustomSearchableDropDown(
                      items: _jovensF,
                      label: 'Selecione jovem fêmea',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _jovensF?.map((item) {
                            return item.nomeAnimal;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        if (value != null) {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nomeAnimal;
                          nomeAnimal = value.nomeAnimal;
                        }
                      },
                    ),
                    Text("OU"),
                    CustomSearchableDropDown(
                      items: _jovensM,
                      label: 'Selecione jovem macho',
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(Icons.search),
                      ),
                      dropDownMenuItems: _jovensM?.map((item) {
                            return item.nomeAnimal;
                          })?.toList() ??
                          [],
                      onChanged: (value) {
                        if (value != null) {
                          _editedTratamento.idAnimal = value.id;
                          _editedTratamento.nomeAnimal = value.nomeAnimal;
                          nomeAnimal = value.nomeAnimal;
                        }
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
                        if (value != null) {
                          _editedTratamento.idMedicamento = value.id;
                          _editedTratamento.nomeMedicamento =
                              value.nomeMedicamento;
                          nomeMedicamento = value.nomeMedicamento;
                        }
                      },
                    ),
                    Text("Medicamento:  $nomeMedicamento",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 4, 125, 141))),
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

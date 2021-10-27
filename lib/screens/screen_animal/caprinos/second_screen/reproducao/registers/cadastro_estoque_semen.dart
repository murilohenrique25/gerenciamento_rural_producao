import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/reprodutor_db.dart';
import 'package:gerenciamento_rural/models/inventario_semen_caprino.dart';
import 'package:gerenciamento_rural/models/reprodutor.dart';
import 'package:intl/intl.dart';

import 'package:toast/toast.dart';

class CadastroEstoqueSemenCaprina extends StatefulWidget {
  final InventarioSemenCaprino inventarioSemenCaprino;
  CadastroEstoqueSemenCaprina({this.inventarioSemenCaprino});
  @override
  _CadastroEstoqueSemenCaprinaState createState() =>
      _CadastroEstoqueSemenCaprinaState();
}

class _CadastroEstoqueSemenCaprinaState
    extends State<CadastroEstoqueSemenCaprina> {
  String tipo;
  ReprodutorDB helper = ReprodutorDB();
  List<Reprodutor> reprodutores = [];
  bool _inventarioEdited = false;
  InventarioSemenCaprino _editedInventario;
  Reprodutor reprodutor = Reprodutor();
  String idadeFinal = "";
  String nomeMacho = "";
  final _vigorController = TextEditingController();
  final _obsController = TextEditingController();
  final _palhetaController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _mortilidadeController = TextEditingController();
  final _turbilhamentoController = TextEditingController();
  final _concentracaoController = TextEditingController();
  final _volumeController = TextEditingController();
  final _aspectoController = TextEditingController();
  final _defeitosMaioresController = TextEditingController();
  final _celulasNormaisController = TextEditingController();
  final _defeitosMenoresController = TextEditingController();
  final _corController = TextEditingController();
  var _dataColeta = MaskedTextController(mask: '00-00-0000');
  var _dataValidade = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final df = new DateFormat("dd-MM-yyyy");

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  void _reset() {
    setState(() {
      _formKey = GlobalKey();
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllReprodutores();
    if (widget.inventarioSemenCaprino == null) {
      _editedInventario = InventarioSemenCaprino();
    } else {
      _editedInventario =
          InventarioSemenCaprino.fromMap(widget.inventarioSemenCaprino.toMap());
      _palhetaController.text = _editedInventario.identificacao;
      _quantidadeController.text = _editedInventario.quantidade.toString();
      _corController.text = _editedInventario.cor;
      _dataColeta.text = _editedInventario.dataCadastro;
      _dataValidade.text = _editedInventario.dataValidade;
      _obsController.text = _editedInventario.observacao;
      _vigorController.text = _editedInventario.vigor;
      _aspectoController.text = _editedInventario.aspecto;
      _mortilidadeController.text = _editedInventario.mortalidade;
      _turbilhamentoController.text = _editedInventario.turbilhamento;
      _concentracaoController.text = _editedInventario.concentracao;
      _volumeController.text = _editedInventario.volume.toString();
      _celulasNormaisController.text =
          _editedInventario.celulasNormais.toString();
      _defeitosMaioresController.text = _editedInventario.defeitoMaiores;
      _defeitosMenoresController.text = _editedInventario.defeitoMenores;
      nomeMacho = _editedInventario.nomeReprodutor;
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
            "Cadastrar Estoque",
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
            if (_dataColeta.text.isEmpty) {
              Toast.show("Data inválida.", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else {
              Navigator.pop(context, _editedInventario);
            }
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
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: _dataColeta,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data Coleta"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.dataCadastro = text;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                CustomSearchableDropDown(
                  items: reprodutores,
                  label: 'Selecione um reprodutor',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: reprodutores?.map((item) {
                        return item.nomeAnimal;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    _editedInventario.idReprodutor = value.id;
                    _editedInventario.nomeReprodutor = value.nomeAnimal;
                    nomeMacho = value.nomeAnimal;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Macho:  $nomeMacho",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _quantidadeController,
                  decoration: InputDecoration(labelText: "Quantidade"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.quantidade = int.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _palhetaController,
                  decoration:
                      InputDecoration(labelText: "Identificação da Palheta"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.identificacao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _dataValidade,
                  decoration: InputDecoration(labelText: "Data Validade"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.dataValidade = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _obsController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.observacao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _vigorController,
                  decoration: InputDecoration(labelText: "Vigor"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.vigor = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _mortilidadeController,
                  decoration: InputDecoration(labelText: "Motilidade"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.mortalidade = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _turbilhamentoController,
                  decoration: InputDecoration(labelText: "Turbilhamento"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.turbilhamento = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _concentracaoController,
                  decoration: InputDecoration(labelText: "Concentração"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.concentracao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _volumeController,
                  decoration: InputDecoration(labelText: "Volume"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.volume = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _aspectoController,
                  decoration: InputDecoration(labelText: "Aspecto"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.aspecto = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _celulasNormaisController,
                  decoration: InputDecoration(labelText: "Células normais %"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.celulasNormais = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _defeitosMaioresController,
                  decoration: InputDecoration(labelText: "Defeitos Maiores"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.defeitoMaiores = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _defeitosMenoresController,
                  decoration: InputDecoration(labelText: "Defeitos Menores"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.defeitoMenores = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _corController,
                  decoration: InputDecoration(labelText: "Cor"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.cor = text;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_inventarioEdited) {
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

  void _getAllReprodutores() {
    helper.getAllItemsVivos().then((list) {
      setState(() {
        reprodutores = list;
      });
    });
  }
}

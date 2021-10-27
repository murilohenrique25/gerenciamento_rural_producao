import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/inventario_semen_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/matriz_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/reprodutor_db.dart';
import 'package:gerenciamento_rural/models/inseminacao_caprino.dart';
import 'package:gerenciamento_rural/models/inventario_semen_caprino.dart';
import 'package:gerenciamento_rural/models/matriz_caprino.dart';
import 'package:gerenciamento_rural/models/reprodutor.dart';
import 'package:intl/intl.dart';

import 'package:toast/toast.dart';

class CadastroInseminacaoMonta extends StatefulWidget {
  final InseminacaoCaprino inseminacao;
  CadastroInseminacaoMonta({this.inseminacao});
  @override
  _CadastroInseminacaoMontaState createState() =>
      _CadastroInseminacaoMontaState();
}

class _CadastroInseminacaoMontaState extends State<CadastroInseminacaoMonta> {
  MatrizCaprinoDB matrizDB = MatrizCaprinoDB();
  ReprodutorDB reprodutorDB = ReprodutorDB();
  InventarioSemenCaprinoDB _inventarioSemenDB = InventarioSemenCaprinoDB();
  MatrizCaprino matrizCaprino = MatrizCaprino();
  int _radioValue = 0;
  String tipo;
  List<MatrizCaprino> matrizes = [];
  List<Reprodutor> reprodutores = [];
  List<InventarioSemenCaprino> listaSemens = [];
  InventarioSemenCaprino inventarioSemen;
  InseminacaoCaprino _editedInseminacao;
  bool _inseminacaoEdited = false;
  Reprodutor reprodutor = Reprodutor();
  MatrizCaprino matriz = MatrizCaprino();
  final _inseminadorController = TextEditingController();
  final _obsController = TextEditingController();
  final _palhetaController = TextEditingController();
  var _data = MaskedTextController(mask: '00-00-0000');
  String nomeMatriz = "";
  String nomeMacho = "";
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
    _getAllAnimais();
    if (widget.inseminacao == null) {
      _editedInseminacao = InseminacaoCaprino();
    } else {
      _editedInseminacao =
          InseminacaoCaprino.fromMap(widget.inseminacao.toMap());
      _inseminadorController.text = _editedInseminacao.inseminador;
      _obsController.text = _editedInseminacao.observacao;
      _palhetaController.text = _editedInseminacao.observacao;
      _data.text = _editedInseminacao.data;
      nomeMatriz = _editedInseminacao.nomeMatriz;
      nomeMacho = _editedInseminacao.nomeReprodutor;
      if (_editedInseminacao.tipoReproducao == "Inseminação") {
        _radioValue = 0;
      } else {
        _radioValue = 1;
      }
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
            "Cadastrar Inseminação e Monta Natural",
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
            if (_data.text.isEmpty) {
              Toast.show("Data inválida.", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else {
              if (_radioValue == 0) {
                if (inventarioSemen.quantidade > 0) {
                  int valor = inventarioSemen.quantidade - 1;
                  if (valor <= inventarioSemen.quantidade)
                    inventarioSemen.quantidade = valor;
                  _inventarioSemenDB.updateItem(inventarioSemen);
                } else {}
              }
              matrizCaprino.ultimaInseminacao = _data.text;
              if (matrizCaprino.diasPrenha == null) {
                matrizCaprino.diasPrenha = 0;
              }
              matrizDB.updateItem(matrizCaprino);
              Navigator.pop(context, _editedInseminacao);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 0,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedInseminacao.tipoReproducao = "Inseminação";
                          });
                        }),
                    Text("Inseminação"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedInseminacao.tipoReproducao = "Monta Natural";
                          });
                        }),
                    Text("Monta Natural"),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                CustomSearchableDropDown(
                  items: matrizes,
                  label: 'Selecione uma matriz',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: matrizes?.map((item) {
                        return item.nomeAnimal;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    matrizCaprino = value;
                    _editedInseminacao.idMatriz = value.id;
                    _editedInseminacao.nomeMatriz = value.nomeAnimal;
                    nomeMatriz = value.nomeAnimal;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Matriz selecionada:  $nomeMatriz",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
                ),
                if (_radioValue == 1)
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
                      if (value != null) {
                        _editedInseminacao.idSemen = value.id;
                        _editedInseminacao.nomeReprodutor = value.nomeAnimal;
                        nomeMacho = value.nomeAnimal;
                      }
                    },
                  ),
                if (_radioValue == 0)
                  CustomSearchableDropDown(
                    items: listaSemens,
                    label: 'Selecione um sêmen',
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.blue)),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(Icons.search),
                    ),
                    dropDownMenuItems: listaSemens?.map((item) {
                          return item.nomeReprodutor;
                        })?.toList() ??
                        [],
                    onChanged: (value) {
                      if (value != null) {
                        inventarioSemen = value;
                        _editedInseminacao.idSemen = value.idReprodutor;
                        _editedInseminacao.nomeReprodutor =
                            value.nomeReprodutor;
                        nomeMacho = value.nomeReprodutor;
                      }
                    },
                  ),
                SizedBox(
                  height: 10.0,
                ),
                if (_radioValue == 0)
                  Text("Sêmen selecionado:  $nomeMacho",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 4, 125, 141))),
                if (_radioValue == 1)
                  Text("Macho selecionado:  $nomeMacho",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: _data,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _inseminacaoEdited = true;
                    setState(() {
                      _editedInseminacao.data = text;
                    });
                  },
                ),
                TextField(
                  enabled: _radioValue == 0 ? true : false,
                  keyboardType: TextInputType.text,
                  controller: _palhetaController,
                  decoration: InputDecoration(labelText: "Palheta"),
                  onChanged: (text) {
                    _inseminacaoEdited = true;
                    setState(() {
                      _editedInseminacao.palheta = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _inseminadorController,
                  decoration: InputDecoration(labelText: "Inseminador"),
                  onChanged: (text) {
                    _inseminacaoEdited = true;
                    setState(() {
                      _editedInseminacao.inseminador = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _obsController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _inseminacaoEdited = true;
                    setState(() {
                      _editedInseminacao.observacao = text;
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
    if (_inseminacaoEdited) {
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

  void _getAllAnimais() {
    _inventarioSemenDB.getAllItems().then((list) {
      setState(() {
        listaSemens = list;
      });
    });
    matrizDB.getAllItems().then((list) {
      setState(() {
        matrizes = list;
      });
    });
    reprodutorDB.getAllItemsVivos().then((list) {
      setState(() {
        reprodutores = list;
      });
    });
  }
}

import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/cachaco_db.dart';
import 'package:gerenciamento_rural/helpers/inventario_semen_suina_db.dart';
import 'package:gerenciamento_rural/helpers/matriz_db.dart';
import 'package:gerenciamento_rural/models/cachaco.dart';
import 'package:gerenciamento_rural/models/inseminacao_suino.dart';
import 'package:gerenciamento_rural/models/inventario_semen_suino.dart';
import 'package:gerenciamento_rural/models/matriz.dart';
import 'package:intl/intl.dart';

import 'package:toast/toast.dart';

class CadastroInseminacaoMonta extends StatefulWidget {
  final InseminacaoSuino inseminacao;
  CadastroInseminacaoMonta({this.inseminacao});
  @override
  _CadastroInseminacaoMontaState createState() =>
      _CadastroInseminacaoMontaState();
}

class _CadastroInseminacaoMontaState extends State<CadastroInseminacaoMonta> {
  MatrizDB matrizDB = MatrizDB();
  InventarioSemenSuinaDB _inventarioSemenDB = InventarioSemenSuinaDB();
  CachacoDB cachacoDB = CachacoDB();

  int _radioValue = 0;
  String tipo;
  List<Matriz> matrizes;
  List<Cachaco> cachacos;
  List<InventarioSemenSuina> listaSemens;
  InventarioSemenSuina inventarioSemen;
  InventarioSemenSuina cachacoInv;
  InseminacaoSuino _editedInseminacao;
  bool _inseminacaoEdited = false;
  Cachaco cachaco = Cachaco();
  Matriz matriz = Matriz();
  final _inseminadorController = TextEditingController();
  final _obsController = TextEditingController();
  final _palhetaController = TextEditingController();
  var _data = MaskedTextController(mask: '00-00-0000');
  String nomeMatriz = "";
  String nomeCachaco = "";
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
      _editedInseminacao = InseminacaoSuino();
      _editedInseminacao.tipoReproducao = "Inseminação";
    } else {
      _editedInseminacao = InseminacaoSuino.fromMap(widget.inseminacao.toMap());
      nomeCachaco = _editedInseminacao.nomeCachaco;
      nomeMatriz = _editedInseminacao.nomeMatriz;
      _inseminadorController.text = _editedInseminacao.inseminador;
      _obsController.text = _editedInseminacao.observacao;
      _palhetaController.text = _editedInseminacao.palheta;
      _data.text = _editedInseminacao.data;
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
                inventarioSemen.quantidade = inventarioSemen.quantidade - 1;
                _inventarioSemenDB.updateItem(inventarioSemen);
              }
              matriz.diasPrenha = 0;
              String num = _editedInseminacao.data.split('-').reversed.join();
              DateTime dates = DateTime.parse(num);
              DateTime dateParto = dates.add(new Duration(days: 144));
              var format = new DateFormat("dd-MM-yyyy");
              String dataParto = format.format(dateParto);
              matriz.partoPrevisto = dataParto;
              if (matriz.numeroPartos == null) {
                matriz.numeroPartos = 1;
              } else {
                matriz.numeroPartos += 1;
              }
              matrizDB.updateItem(matriz);
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
                    matriz = value;
                    nomeMatriz = value.nomeAnimal;
                    _editedInseminacao.idMatriz = value.idAnimal;
                    _editedInseminacao.nomeMatriz = value.nomeAnimal;
                  },
                ),
                Text("Matriz selecionada:  $nomeMatriz",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
                ),
                if (_editedInseminacao.tipoReproducao == "Inseminação")
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
                          return item.nomeCachaco;
                        })?.toList() ??
                        [],
                    onChanged: (value) {
                      inventarioSemen = value;
                      _editedInseminacao.idSemen = value.idCachaco;
                      _editedInseminacao.nomeCachaco = value.nomeCachaco;
                      nomeCachaco = value.nomeCachaco;
                    },
                  ),
                if (_editedInseminacao.tipoReproducao == "Monta Natural")
                  CustomSearchableDropDown(
                    items: cachacos,
                    label: 'Selecione um cachaço',
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.blue)),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(Icons.search),
                    ),
                    dropDownMenuItems: cachacos?.map((item) {
                          return item.nomeAnimal;
                        })?.toList() ??
                        [],
                    onChanged: (value) {
                      _editedInseminacao.idSemen = value.idAnimal;
                      _editedInseminacao.nomeCachaco = value.nomeAnimal;
                      nomeCachaco = value.nomeAnimal;
                    },
                  ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Cachaço selecionado:  $nomeCachaco",
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
    cachacoDB.getAllItems().then((list) {
      setState(() {
        cachacos = list;
      });
    });
    matrizDB.getAllItems().then((list) {
      setState(() {
        matrizes = list;
      });
    });
  }
}

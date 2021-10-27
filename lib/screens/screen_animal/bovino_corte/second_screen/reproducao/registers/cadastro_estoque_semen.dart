import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/inventario_semen.dart';
import 'package:gerenciamento_rural/models/touro_corte.dart';
import 'package:gerenciamento_rural/helpers/touro_corte_db.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class CadastroEstoqueSemenBovinoCorte extends StatefulWidget {
  InventarioSemen invet;

  CadastroEstoqueSemenBovinoCorte({this.invet});
  @override
  _CadastroEstoqueSemenBovinoCorteState createState() =>
      _CadastroEstoqueSemenBovinoCorteState();
}

class _CadastroEstoqueSemenBovinoCorteState
    extends State<CadastroEstoqueSemenBovinoCorte> {
  TouroCorteDB touroDB = TouroCorteDB();
  List<TouroCorte> touros = [];

  int _radioValue = 0;
  int _radioValueTamanho = 0;
  int idTouro = 0;
  String nomeTouro = "";
  final _quantidadeController = TextEditingController();
  final _corPalhetaController = TextEditingController();

  TouroCorte selectedTouro = TouroCorte();
  TouroCorte touro = TouroCorte();
  bool _inventarioEdited = false;

  InventarioSemen _editedInventario;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    _getAllTouros();
    if (widget.invet == null) {
      _editedInventario = InventarioSemen();
      _editedInventario.codigoIA = "Sexuado";
      _editedInventario.tamanho = "Pequena";
    } else {
      _editedInventario = InventarioSemen.fromMap(widget.invet.toMap());
      if (_editedInventario.codigoIA == "Sexuado") {
        _radioValue = 0;
      } else {
        _radioValue = 1;
      }
      _quantidadeController.text = _editedInventario.quantidade.toString();
      _corPalhetaController.text = _editedInventario.cor;
      if (_editedInventario.tamanho == "Pequena") {
        _radioValueTamanho = 0;
      } else if (_editedInventario.tamanho == "Media") {
        _radioValueTamanho = 1;
      } else {
        _radioValueTamanho = 2;
      }
      nomeTouro = _editedInventario.nomeTouro;
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
            "Cadastrar Inventário de Sêmen",
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
            DateTime dataAgora = DateTime.now();
            var format = new DateFormat("dd-MM-yyyy");
            String dataCadastro = format.format(dataAgora);
            _editedInventario.dataCadastro = dataCadastro;
            Navigator.pop(context, _editedInventario);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Código IA:"),
                    Radio(
                        value: 0,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedInventario.codigoIA = "Sexado";
                          });
                        }),
                    Text("Sexado"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                          });
                          _editedInventario.codigoIA = "Não Sexado";
                        }),
                    Text("Não Sexado"),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                CustomSearchableDropDown(
                  items: touros,
                  label: 'Selecione um touro',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: touros?.map((item) {
                        return item.nome;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    idTouro = value.id;
                    _editedInventario.idTouro = value.id;
                    _editedInventario.nomeTouro = value.nome;
                    nomeTouro = value.nome;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Touro:  $nomeTouro",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: _quantidadeController,
                  decoration: InputDecoration(labelText: "Estoque de Palheta"),
                  onChanged: (value) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.quantidade = int.parse(value);
                    });
                  },
                  keyboardType: TextInputType.number,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text("Tamanho Palheta:"),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Radio(
                              value: 0,
                              groupValue: _radioValueTamanho,
                              onChanged: (int value) {
                                _inventarioEdited = true;
                                setState(() {
                                  _radioValueTamanho = value;
                                  _editedInventario.tamanho = "Pequena";
                                });
                              }),
                          Text("Pequena"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Radio(
                              value: 1,
                              groupValue: _radioValueTamanho,
                              onChanged: (int value) {
                                _inventarioEdited = true;
                                setState(() {
                                  _radioValueTamanho = value;
                                  _editedInventario.tamanho = "Media";
                                });
                              }),
                          Text("Média"),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Radio(
                              value: 2,
                              groupValue: _radioValueTamanho,
                              onChanged: (int value) {
                                _inventarioEdited = true;
                                setState(() {
                                  _radioValueTamanho = value;
                                  _editedInventario.tamanho = "Grande";
                                });
                              }),
                          Text("Grande"),
                        ],
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: _corPalhetaController,
                  decoration: InputDecoration(labelText: "Cor da Palheta"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedInventario.cor = text;
                    });
                  },
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

  void _getAllTouros() {
    touroDB.getAllItems().then((value) {
      setState(() {
        touros = value;
      });
    });
  }
}

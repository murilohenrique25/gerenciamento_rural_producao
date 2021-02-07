import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/inventario_semen.dart';
import 'package:gerenciamento_rural/models/touro.dart';
import 'package:gerenciamento_rural/helpers/touro_db.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

// ignore: must_be_immutable
class CadastroInventarioSemen extends StatefulWidget {
  InventarioSemen invet;

  CadastroInventarioSemen({this.invet});
  @override
  _CadastroInventarioSemenState createState() =>
      _CadastroInventarioSemenState();
}

class _CadastroInventarioSemenState extends State<CadastroInventarioSemen> {
  TouroDB touroDB = TouroDB();
  List<Touro> touros = List();

  int _radioValue = 0;
  int _radioValueTamanho = 0;
  final _nomeTouroController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _corPalhetaController = TextEditingController();

  final _nameFocus = FocusNode();
  int selectedTouro;
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
    } else {
      _editedInventario = InventarioSemen.fromMap(widget.invet.toMap());
      if (_editedInventario.codigoIA == "Sexuado") {
        _radioValue = 0;
      } else {
        _radioValue = 1;
      }
      _nomeTouroController.text = _editedInventario.touro.nome;
      _quantidadeController.text = _editedInventario.quantidade.toString();
      _corPalhetaController.text = _editedInventario.cor;
      if (_editedInventario.tamanho == "Pequena") {
        _radioValueTamanho = 0;
      } else if (_editedInventario.tamanho == "Media") {
        _radioValueTamanho = 1;
      } else {
        _radioValueTamanho = 2;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      }),
                  Text("Não Sexado"),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              SearchableDropdown.single(
                items: touros.map((Touro touro) {
                  return DropdownMenuItem(
                    value: touro.idTouro,
                    child: Row(
                      children: [
                        Text(touro.nome),
                      ],
                    ),
                  );
                }).toList(),
                value: selectedTouro,
                hint: "Selecione um Touro",
                searchHint: "Selecione um Touro",
                onChanged: (value) {
                  _inventarioEdited = true;
                  setState(() {
                    _editedInventario.touro.idTouro = value;
                    selectedTouro = value;
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
                enabled: _inventarioEdited,
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
                            value: 1,
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
    );
  }

  void _getAllTouros() {
    touroDB.getAllItems().then((value) {
      setState(() {
        touros = value;
      });
    });
  }
}

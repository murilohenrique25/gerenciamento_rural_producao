import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/matriz_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/registro_parto_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/reprodutor_db.dart';
import 'package:gerenciamento_rural/models/matriz_caprino.dart';
import 'package:gerenciamento_rural/models/registro_partos_caprinos.dart';
import 'package:gerenciamento_rural/models/reprodutor.dart';
import 'package:intl/intl.dart';

import 'package:toast/toast.dart';

class CadastroHistoricoPartoCaprino extends StatefulWidget {
  final RegistroPartoCaprino registroPartoCaprino;
  CadastroHistoricoPartoCaprino({this.registroPartoCaprino});
  @override
  _CadastroHistoricoPartoCaprinoState createState() =>
      _CadastroHistoricoPartoCaprinoState();
}

class _CadastroHistoricoPartoCaprinoState
    extends State<CadastroHistoricoPartoCaprino> {
  String tipo;
  RegistroPartoCaprinoDB helper = RegistroPartoCaprinoDB();
  MatrizCaprinoDB matrizDB = MatrizCaprinoDB();
  ReprodutorDB reprodutorDB = ReprodutorDB();
  List<MatrizCaprino> matrizes = [];
  List<Reprodutor> reprodutores = [];
  int _radioValueSetor = 0;
  List<RegistroPartoCaprino> registros = [];
  bool _inventarioEdited = false;
  RegistroPartoCaprino _editedRegistros;
  MatrizCaprino matriz;
  Reprodutor reprodutor;

  String idadeFinal = "";
  String nomeMacho = "";
  String nomeMatriz = "";

  final _quantidadeController = TextEditingController();
  final _quantidadeFController = TextEditingController();
  final _quantidadeMController = TextEditingController();
  final _problemaController = TextEditingController();
  var _data = MaskedTextController(mask: '00-00-0000');

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
    _getAllRegistros();
    if (widget.registroPartoCaprino == null) {
      _editedRegistros = RegistroPartoCaprino();
    } else {
      _editedRegistros =
          RegistroPartoCaprino.fromMap(widget.registroPartoCaprino.toMap());
      nomeMatriz = _editedRegistros.nomeMatriz;
      nomeMacho = _editedRegistros.nomeReprodutor;
      _data.text = _editedRegistros.data;
      _quantidadeController.text = _editedRegistros.quantidade.toString();
      _quantidadeFController.text = _editedRegistros.quantFemeas.toString();
      _quantidadeMController.text = _editedRegistros.quantMachos.toString();
      _problemaController.text = _editedRegistros.problema;
      _quantidadeController.text = _editedRegistros.quantidade.toString();
      if (_editedRegistros.tipoInseminacao == "Inseminação") {
        _radioValueSetor = 0;
      } else {
        _radioValueSetor = 1;
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
            "Cadastrar Registro de Partos",
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
              Navigator.pop(context, _editedRegistros);
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
                    if (value != null) {
                      _editedRegistros.nomeMatriz = value.nomeAnimal;
                      nomeMatriz = value.nomeAnimal;
                    }
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Matriz selecionado:  $nomeMatriz",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
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
                    if (value != null) {
                      _editedRegistros.nomeReprodutor = value.nomeAnimal;
                      nomeMacho = value.nomeAnimal;
                    }
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Macho selecionado:  $nomeMacho",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _data,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedRegistros.data = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _quantidadeController,
                  decoration: InputDecoration(labelText: "Quantidade"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedRegistros.quantidade = int.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _quantidadeMController,
                  decoration: InputDecoration(labelText: "Machos"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedRegistros.quantMachos = int.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _quantidadeFController,
                  decoration: InputDecoration(labelText: "Fêmeas"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedRegistros.quantFemeas = int.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _problemaController,
                  decoration: InputDecoration(labelText: "Problemas"),
                  onChanged: (text) {
                    _inventarioEdited = true;
                    setState(() {
                      _editedRegistros.problema = text;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 0,
                        groupValue: _radioValueSetor,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueSetor = value;
                            _editedRegistros.tipoInseminacao = "Inseminação";
                          });
                        }),
                    Text("Inseminação"),
                    Radio(
                        value: 1,
                        groupValue: _radioValueSetor,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueSetor = value;
                            _editedRegistros.tipoInseminacao = "Monta Natural";
                          });
                        }),
                    Text("Monta Natural"),
                  ],
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

  void _getAllRegistros() {
    helper.getAllItems().then((list) {
      setState(() {
        registros = list;
      });
    });
    matrizDB.getAllItems().then((value) {
      setState(() {
        matrizes = value;
      });
    });
    reprodutorDB.getAllItemsVivos().then((value) {
      setState(() {
        reprodutores = value;
      });
    });
  }
}

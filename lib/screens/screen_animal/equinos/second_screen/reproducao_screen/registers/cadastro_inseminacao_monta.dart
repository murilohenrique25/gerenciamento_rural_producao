import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/cavalo_db.dart';
import 'package:gerenciamento_rural/helpers/egua_db.dart';
import 'package:gerenciamento_rural/helpers/inventario_semen_equino_db.dart';
import 'package:gerenciamento_rural/models/cavalo.dart';
import 'package:gerenciamento_rural/models/egua.dart';
import 'package:gerenciamento_rural/models/inseminacao_equino.dart';
import 'package:gerenciamento_rural/models/inventario_semen_equino.dart';
import 'package:intl/intl.dart';

import 'package:toast/toast.dart';

class CadastroInseminacaoMontaEquino extends StatefulWidget {
  final InseminacaoEquino inseminacao;
  CadastroInseminacaoMontaEquino({this.inseminacao});
  @override
  _CadastroInseminacaoMontaEquinoState createState() =>
      _CadastroInseminacaoMontaEquinoState();
}

class _CadastroInseminacaoMontaEquinoState
    extends State<CadastroInseminacaoMontaEquino> {
  EguaDB eguaDB = EguaDB();
  CavaloDB cavaloDB = CavaloDB();
  InventarioSemenEquinoDB _inventarioSemenDB = InventarioSemenEquinoDB();
  int _radioValue = 0;
  String tipo;
  List<Egua> eguas;
  List<Cavalo> cavalos;
  List<InventarioSemenEquino> listaSemens;
  InventarioSemenEquino inventarioSemen;
  InseminacaoEquino _editedInseminacao;
  bool _inseminacaoEdited = false;
  Cavalo cavalo = Cavalo();
  Egua egua = Egua();
  final _inseminadorController = TextEditingController();
  final _obsController = TextEditingController();
  final _palhetaController = TextEditingController();
  var _data = MaskedTextController(mask: '00-00-0000');
  String nomeEgua = "";
  String nomeCavalo = "";
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
      _editedInseminacao = InseminacaoEquino();
    } else {
      _editedInseminacao =
          InseminacaoEquino.fromMap(widget.inseminacao.toMap());
      _inseminadorController.text = _editedInseminacao.inseminador;
      _obsController.text = _editedInseminacao.observacao;
      _palhetaController.text = _editedInseminacao.observacao;
      _data.text = _editedInseminacao.data;
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
              egua.diasPrenha = 0;
              String num = _editedInseminacao.data.split('-').reversed.join();
              DateTime dates = DateTime.parse(num);
              DateTime dateParto = dates.add(new Duration(days: 335));
              var format = new DateFormat("dd-MM-yyyy");
              String dataParto = format.format(dateParto);
              egua.partoPrevisto = dataParto;
              eguaDB.updateItem(egua);

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
                  items: eguas,
                  label: 'Selecione uma égua',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: eguas?.map((item) {
                        return item.nome;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    nomeEgua = value.nome;
                    _editedInseminacao.idEgua = value.id;
                    _editedInseminacao.nomeEgua = value.nome;
                    nomeEgua = value.nome;
                    egua = value;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Égua selecionada:  $nomeEgua",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
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
                          return item.nomeCavalo;
                        })?.toList() ??
                        [],
                    onChanged: (value) {
                      inventarioSemen = value;
                      _editedInseminacao.idSemen = value.idCavalo;
                      _editedInseminacao.nomeCavalo = value.nomeCavalo;
                      nomeCavalo = value.nomeCavalo;
                    },
                  ),
                if (_radioValue == 1)
                  CustomSearchableDropDown(
                    items: cavalos,
                    label: 'Selecione um cavalo',
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.blue)),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(Icons.search),
                    ),
                    dropDownMenuItems: cavalos?.map((item) {
                          return item.nome;
                        })?.toList() ??
                        [],
                    onChanged: (value) {
                      _editedInseminacao.idSemen = value.id;
                      _editedInseminacao.nomeCavalo = value.nome;
                      nomeCavalo = value.nome;
                    },
                  ),
                Text("Cavalo selecionado:  $nomeCavalo",
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
    eguaDB.getAllItems().then((list) {
      setState(() {
        eguas = list;
      });
    });
    cavaloDB.getAllItems().then((value) {
      setState(() {
        cavalos = value;
      });
    });
  }
}

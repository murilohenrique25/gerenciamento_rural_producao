import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/inventario_semen_bovino_corte_db.dart';
import 'package:gerenciamento_rural/helpers/novilha_corte_db.dart';
import 'package:gerenciamento_rural/helpers/vaca_corte_db.dart';
import 'package:gerenciamento_rural/models/inseminacao.dart';
import 'package:gerenciamento_rural/models/inventario_semen.dart';
import 'package:gerenciamento_rural/models/novilha_corte.dart';
import 'package:gerenciamento_rural/models/vaca_corte.dart';
import 'package:intl/intl.dart';

class CadastroInseminacaoBovinoCorte extends StatefulWidget {
  final Inseminacao inseminacao;
  CadastroInseminacaoBovinoCorte({this.inseminacao});
  @override
  _CadastroInseminacaoBovinoCorteState createState() =>
      _CadastroInseminacaoBovinoCorteState();
}

class _CadastroInseminacaoBovinoCorteState
    extends State<CadastroInseminacaoBovinoCorte> {
  final _inseminadorController = TextEditingController();
  final _obsController = TextEditingController();

  var _dataInse = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  VacaCorteDB helperVaca = VacaCorteDB();
  NovilhaCorteDB helperNovilha = NovilhaCorteDB();
  List<VacaCorte> totalVacas = [];
  List<NovilhaCorte> totalNovilhas = [];

  InventarioSemenBovinoCorteDB helperInventario =
      InventarioSemenBovinoCorteDB();
  List<InventarioSemen> semens = [];
  bool _inseminacaoEdited = false;
  Inseminacao _editedInseminacao;
  InventarioSemen selectedInseminacao;
  String verificaAnimal;
  VacaCorte vaca;
  NovilhaCorte novilha;
  String nomeFemea = "";
  String nomeSemen = "";
  void _reset() {
    setState(() {
      _formKey = GlobalKey();
    });
  }

  @override
  void initState() {
    super.initState();
    _getAllVacas();
    if (widget.inseminacao == null) {
      _editedInseminacao = Inseminacao();
    } else {
      _editedInseminacao = Inseminacao.fromMap(widget.inseminacao.toMap());
      nomeFemea = _editedInseminacao.nomeVaca;
      nomeSemen = _editedInseminacao.nomeTouro;
      _inseminadorController.text = _editedInseminacao.inseminador;
      _obsController.text = _editedInseminacao.observacao;
      _dataInse.text = _editedInseminacao.data;
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
            "Cadastrar Inseminação",
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
            if (_editedInseminacao.id == null) {
              selectedInseminacao.quantidade =
                  selectedInseminacao.quantidade - 1;
              helperInventario.updateItem(selectedInseminacao);
            }
            String num = _editedInseminacao.data.split('-').reversed.join();
            DateTime dates = DateTime.parse(num);
            DateTime dateParto = dates.add(new Duration(days: 284));
            DateTime dateSecagem = dates.add(new Duration(days: 222));
            var format = new DateFormat("dd-MM-yyyy");
            String dataParto = format.format(dateParto);
            String dataSecagem = format.format(dateSecagem);

            if (verificaAnimal == "vaca") {
              vaca.ultimaInseminacao = _editedInseminacao.data;
              vaca.partoPrevisto = dataParto;
              vaca.secagemPrevista = dataSecagem;
              helperVaca.updateItem(vaca);
            } else if (verificaAnimal == "novilha") {
              novilha.dataInseminacao = _editedInseminacao.data;
              helperNovilha.updateItem(novilha);
            }
            helperInventario.updateItem(selectedInseminacao);

            Navigator.pop(context, _editedInseminacao);
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
                  items: totalVacas,
                  label: 'Selecione uma vaca',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: totalVacas?.map((item) {
                        return item.nome;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    verificaAnimal = "vaca";
                    vaca = value;
                    _editedInseminacao.idVaca = value.id;
                    _editedInseminacao.nomeVaca = value.nome;
                    nomeFemea = value.nome;
                  },
                ),
                Text("OU"),
                CustomSearchableDropDown(
                  items: totalNovilhas,
                  label: 'Selecione uma novilha',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: totalNovilhas?.map((item) {
                        return item.nome;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    verificaAnimal = "novilha";
                    novilha = value;
                    _editedInseminacao.idVaca = value.id;
                    _editedInseminacao.nomeVaca = value.nome;
                    nomeFemea = value.nome;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Fêmea:  $nomeFemea",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 20.0,
                ),
                CustomSearchableDropDown(
                  items: semens,
                  label: 'Selecione um Sêmen',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: semens?.map((item) {
                        return item.nomeTouro;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    selectedInseminacao = value;
                    _editedInseminacao.idSemen = value.id;
                    _editedInseminacao.nomeTouro = value.nomeTouro;
                    nomeSemen = value.nomeTouro;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text("Sêmen:  $nomeSemen",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Inseminador"),
                  controller: _inseminadorController,
                  onChanged: (value) {
                    setState(() {
                      _editedInseminacao.inseminador = value;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data"),
                  controller: _dataInse,
                  onChanged: (value) {
                    setState(() {
                      _editedInseminacao.data = value;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Observação"),
                  controller: _obsController,
                  onChanged: (value) {
                    setState(() {
                      _editedInseminacao.observacao = value;
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

  void _getAllVacas() {
    helperVaca.getAllItems().then((list) {
      setState(() {
        totalVacas = list;
      });
    });
    helperInventario.getAllItems().then((value) {
      setState(() {
        semens = value;
      });
    });
    helperNovilha.getAllItems().then((value) {
      setState(() {
        totalNovilhas = value;
      });
    });
  }
}

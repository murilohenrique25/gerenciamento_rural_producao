import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/inventario_semen_db.dart';
import 'package:gerenciamento_rural/helpers/novilha_db.dart';
import 'package:gerenciamento_rural/helpers/vaca_db.dart';
import 'package:gerenciamento_rural/models/inseminacao.dart';
import 'package:gerenciamento_rural/models/inventario_semen.dart';
import 'package:gerenciamento_rural/models/novilha.dart';
import 'package:gerenciamento_rural/models/vaca.dart';
import 'package:intl/intl.dart';

class CadastroInseminacao extends StatefulWidget {
  final Inseminacao inseminacao;
  CadastroInseminacao({this.inseminacao});
  @override
  _CadastroInseminacaoState createState() => _CadastroInseminacaoState();
}

class _CadastroInseminacaoState extends State<CadastroInseminacao> {
  //final _nomeVacaController = TextEditingController();
  //final _semenController = TextEditingController();
  final _inseminadorController = TextEditingController();
  final _obsController = TextEditingController();
  String nomeAnimal = "";
  String nomeTouro = "";
  var _dataInse = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  VacaDB helperVaca = VacaDB();
  NovilhaDB helperNovilha = NovilhaDB();
  List<Vaca> totalVacas = [];
  List<Novilha> totalNovilhas = [];

  InventarioSemenDB helperInventario = InventarioSemenDB();
  List<InventarioSemen> semens = [];
  bool _inseminacaoEdited = false;
  Inseminacao _editedInseminacao;
  InventarioSemen selectedInseminacao;
  String verificaAnimal;
  Vaca vaca;
  Novilha novilha;
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
      nomeAnimal = _editedInseminacao.nomeVaca;
      nomeTouro = _editedInseminacao.nomeTouro;
      _inseminadorController.text = _editedInseminacao.inseminador;
      _dataInse.text = _editedInseminacao.data;
      _obsController.text = _editedInseminacao.observacao;
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
            selectedInseminacao.quantidade = selectedInseminacao.quantidade - 1;
            helperInventario.updateItem(selectedInseminacao);
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
              novilha.dataCobertura = _editedInseminacao.data;
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
                    _editedInseminacao.idVaca = value.idVaca;
                    _editedInseminacao.nomeVaca = value.nome;
                    nomeAnimal = value.nome;
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
                    _editedInseminacao.idVaca = value.idNovilha;
                    _editedInseminacao.nomeVaca = value.nome;
                    nomeAnimal = value.nome;
                  },
                ),
                CustomSearchableDropDown(
                  items: semens,
                  label: 'Selecione uma sêmen',
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
                    nomeTouro = value.nomeTouro;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Text(
                    "Touro: " + nomeTouro,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141)),
                  ),
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
    helperInventario.getAllItemsEstoque().then((value) {
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

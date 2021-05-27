import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/preco_carne_caprino_db.dart';
import 'package:gerenciamento_rural/models/preco_carne_caprina.dart';
import 'package:gerenciamento_rural/models/producao_carne_caprina.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroProducaoCarneCaprina extends StatefulWidget {
  final ProducaoCarneCaprina producaoCarneCaprina;
  CadastroProducaoCarneCaprina({this.producaoCarneCaprina});
  @override
  _CadastroProducaoCarneCaprinaState createState() =>
      _CadastroProducaoCarneCaprinaState();
}

class _CadastroProducaoCarneCaprinaState
    extends State<CadastroProducaoCarneCaprina> {
  PrecoCarneCaprinaDB _precoCarneCaprinaDB = PrecoCarneCaprinaDB();
  List<PrecoCarneCaprina> precoCarne = [];
  PrecoCarneCaprina precoCarneCaprina;
  final precoController = TextEditingController();
  String nomeMes = "";
  double nomePreco = 0.0;
  bool _producaoCarneEdited = false;
  ProducaoCarneCaprina _editedProducaoCarne;

  @override
  void initState() {
    super.initState();
    _getAllPreco();
    if (widget.producaoCarneCaprina == null) {
      _editedProducaoCarne = ProducaoCarneCaprina();
    } else {
      _editedProducaoCarne =
          ProducaoCarneCaprina.fromMap(widget.producaoCarneCaprina.toMap());
      precoController.text = _editedProducaoCarne.preco.toString();
      nomeMes = _editedProducaoCarne.data;
      nomePreco = _editedProducaoCarne.preco;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cadastrar Produção Carne Caprina"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              if (_editedProducaoCarne.preco.isNaN) {
                Toast.show("Informe o preço", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
              } else if (_editedProducaoCarne.data == "" ||
                  _editedProducaoCarne.data.length < 7) {
                Toast.show("Informe a data", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
              } else if (_editedProducaoCarne.quantidade == null) {
                Toast.show("Informe a quantidade", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
              } else {
                double t = _editedProducaoCarne.quantidade * nomePreco;
                _editedProducaoCarne.total = t;
                Navigator.pop(context, _editedProducaoCarne);
              }
            });
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.green[700],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Form(
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
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Quantidade Kg"),
                  onChanged: (text) {
                    _producaoCarneEdited = true;
                    setState(() {
                      _editedProducaoCarne.quantidade = double.parse(text);
                    });
                  },
                ),
                SearchableDropdown.single(
                  items: precoCarne.map((preco) {
                    return DropdownMenuItem(
                      value: preco,
                      child: Row(
                        children: [
                          Text(preco.data),
                        ],
                      ),
                    );
                  }).toList(),
                  value: precoCarneCaprina,
                  hint: "Selecione um mês",
                  searchHint: "Selecione um mês",
                  onChanged: (value) {
                    _producaoCarneEdited = true;
                    setState(() {
                      _editedProducaoCarne.data = value.data;
                      nomeMes = value.data;
                      _editedProducaoCarne.preco = value.preco;
                      nomePreco = value.preco;
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
                SizedBox(
                  height: 5.0,
                ),
                Text("Mês selecionado:  $nomeMes\nPreço por Kg: $nomePreco",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                Divider(),
                Text("Total: ${nomePreco * _editedProducaoCarne.quantidade}",
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getAllPreco() {
    _precoCarneCaprinaDB.getAllItems().then((value) {
      setState(() {
        precoCarne = value;
      });
    });
  }

  Future<bool> _requestPop() {
    if (_producaoCarneEdited) {
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
}

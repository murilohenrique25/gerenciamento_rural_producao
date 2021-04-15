import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/preco_carne_suina_db.dart';
import 'package:gerenciamento_rural/models/preco_carne_suina.dart';
import 'package:gerenciamento_rural/models/producao_carne_suina.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroProducaoCarneSuina extends StatefulWidget {
  final ProducaoCarneSuina producaoCarneSuina;
  CadastroProducaoCarneSuina({this.producaoCarneSuina});
  @override
  _CadastroProducaoCarneSuinaState createState() =>
      _CadastroProducaoCarneSuinaState();
}

class _CadastroProducaoCarneSuinaState
    extends State<CadastroProducaoCarneSuina> {
  PrecoCarneSuinaDB _precoCarneSuinaDB = PrecoCarneSuinaDB();
  List<PrecoCarneSuina> precoCarne = [];
  PrecoCarneSuina precoCarneSuina;
  final precoController = TextEditingController();
  String nomeMes = "Vazio";
  double nomePreco = 0.0;
  bool _producaoCarneEdited = false;
  ProducaoCarneSuina _editedProducaoCarne;

  @override
  void initState() {
    super.initState();
    _getAllPreco();
    if (widget.producaoCarneSuina == null) {
      _editedProducaoCarne = ProducaoCarneSuina();
    } else {
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
          title: Text("Cadastrar Preço Carne Suína"),
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
                  decoration: InputDecoration(labelText: "Quantidade"),
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
                  value: precoCarneSuina,
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
                Text(
                    "Mês selecionado:  $nomeMes\nPreço selecionado: $nomePreco",
                    style: TextStyle(
                        fontSize: 16.0,
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
    _precoCarneSuinaDB.getAllItems().then((value) {
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

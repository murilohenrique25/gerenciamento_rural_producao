import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/preco_carne_suina.dart';
import 'package:gerenciamento_rural/models/producao_carne_suina.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroProducaoCarneSuina extends StatefulWidget {
  final ProducaoCarneSuina precoCarneSuina;
  CadastroProducaoCarneSuina({this.precoCarneSuina});
  @override
  _CadastroProducaoCarneSuinaState createState() =>
      _CadastroProducaoCarneSuinaState();
}

class _CadastroProducaoCarneSuinaState
    extends State<CadastroProducaoCarneSuina> {
  List<PrecoCarneSuina> precoCarne = List();
  PrecoCarneSuina precoCarneSuina = PrecoCarneSuina();
  final precoController = TextEditingController();

  bool _precoCarneEdited = false;
  PrecoCarneSuina _editedPrecoCarne;

  @override
  void initState() {
    super.initState();
    if (widget.precoCarneSuina == null) {
      _editedPrecoCarne = PrecoCarneSuina();
    } else {
      precoController.text = _editedPrecoCarne.preco.toString();
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
              if (_editedPrecoCarne.preco.isNaN) {
                Toast.show("Informe o preço", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
              } else if (_editedPrecoCarne.data.isEmpty ||
                  _editedPrecoCarne.data.length < 7) {
                Toast.show("Informe a data", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
              } else {
                Navigator.pop(context, _editedPrecoCarne);
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
                    setState(() {
                      _editedPrecoCarne.preco = double.parse(text);
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
                    setState(() {
                      precoCarneSuina.data = value.data;
                      precoCarneSuina.preco = value.preco;
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_precoCarneEdited) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: [
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
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

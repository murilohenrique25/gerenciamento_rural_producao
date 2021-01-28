import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/lote.dart';

class CadastroEconomiaGasto extends StatefulWidget {
  @override
  _CadastroEconomiaGastoState createState() => _CadastroEconomiaGastoState();
}

class _CadastroEconomiaGastoState extends State<CadastroEconomiaGasto> {
  final _nomeLoteController = TextEditingController();
  final _valorController = TextEditingController();
  final _quantidadeController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _loteEdited = false;

  Lote _editedLote;

  double valorTotal = 0.0;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Cadastrar Gastos"),
            centerTitle: true,
            actions: [],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                try {
                  int quant = int.parse(_quantidadeController.text);
                  double valor = double.parse(_valorController.text);
                  valorTotal = quant * valor;
                } catch (Expetion) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: new Text("Erro"),
                        content: new Text("Algum valor está incorreto"),
                        actions: [
                          new FlatButton(
                            child: new Text("Fechar"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ],
                      );
                    },
                  );
                }
              });
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.green[700],
          ),
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.add_circle,
                    size: 80.0,
                    color: Color.fromARGB(255, 4, 125, 141),
                  ),
                  TextField(
                    controller: _nomeLoteController,
                    focusNode: _nameFocus,
                    decoration: InputDecoration(labelText: "Gasto"),
                    onChanged: (text) {
                      _loteEdited = true;
                      setState(() {
                        _editedLote.name = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _valorController,
                    decoration: InputDecoration(labelText: "Valor"),
                    onChanged: (text) {
                      _loteEdited = true;
                      setState(() {
                        _editedLote.quantidade = int.parse(text);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _quantidadeController,
                    decoration: InputDecoration(labelText: "Quantidade"),
                    onChanged: (text) {
                      _loteEdited = true;
                      setState(() {
                        _editedLote.quantidade = int.parse(text);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    decoration: InputDecoration(labelText: "Observação"),
                    onChanged: (text) {
                      _loteEdited = true;
                      setState(() {
                        _editedLote.quantidade = int.parse(text);
                      });
                    },
                    keyboardType: TextInputType.text,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      "Valor Total: $valorTotal",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<bool> _requestPop() {
    if (_loteEdited) {
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
    } else {
      return Future.value(true);
    }
  }
}

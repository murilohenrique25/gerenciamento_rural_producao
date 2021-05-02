import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/models/gasto.dart';

class CadastroEconomiaGasto extends StatefulWidget {
  final Gasto gasto;
  CadastroEconomiaGasto({this.gasto});
  @override
  _CadastroEconomiaGastoState createState() => _CadastroEconomiaGastoState();
}

class _CadastroEconomiaGastoState extends State<CadastroEconomiaGasto> {
  String valorTipo;
  final _nomeLoteController = TextEditingController();
  final _valorController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _obsController = TextEditingController();
  double quantidadeTotal = 0;
  int quantidadeInd = 0;
  var _dataCadastro = MaskedTextController(mask: '00-00-0000');
  final _nameFocus = FocusNode();

  bool _gastoEdited = false;

  Gasto _editedGasto;

  double valorTotal = 0.0;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.gasto == null) {
      _editedGasto = Gasto();
    } else {
      _editedGasto = Gasto.fromMap(widget.gasto.toMap());
      _dataCadastro.text = _editedGasto.data;
      _nomeLoteController.text = _editedGasto.nome;
      _valorController.text = _editedGasto.valorUnitario.toString();
      _quantidadeController.text = _editedGasto.quantidade.toString();
      _obsController.text = _editedGasto.observacao;
      quantidadeTotal = _editedGasto.valorUnitario;
      quantidadeInd = _editedGasto.quantidade;
    }
  }

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
                  double t = quant * valor;
                  _editedGasto.valorTotal = t;
                  Navigator.pop(context, _editedGasto);
                } catch (Expetion) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: new Text("Erro"),
                        content: new Text("Algum valor está incorreto"),
                        actions: [
                          new ElevatedButton(
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
                    controller: _dataCadastro,
                    decoration: InputDecoration(labelText: "Data"),
                    onChanged: (text) {
                      _gastoEdited = true;
                      setState(() {
                        _editedGasto.data = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _nomeLoteController,
                    focusNode: _nameFocus,
                    decoration: InputDecoration(labelText: "Gasto - Descrição"),
                    onChanged: (text) {
                      _gastoEdited = true;
                      setState(() {
                        _editedGasto.nome = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _valorController,
                    decoration: InputDecoration(labelText: "Valor"),
                    onChanged: (text) {
                      _gastoEdited = true;
                      setState(() {
                        quantidadeTotal = double.parse(text);
                        _editedGasto.valorUnitario = double.parse(text);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _quantidadeController,
                    decoration: InputDecoration(labelText: "Quantidade"),
                    onChanged: (text) {
                      _gastoEdited = true;
                      setState(() {
                        quantidadeInd = int.parse(text);
                        _editedGasto.quantidade = int.parse(text);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _obsController,
                    decoration: InputDecoration(labelText: "Observação"),
                    onChanged: (text) {
                      _gastoEdited = true;
                      setState(() {
                        _editedGasto.observacao = text;
                      });
                    },
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Total: ${calcularTotal()}",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141)),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  String calcularTotal() {
    double animal = 0;
    int individual = 0;
    String total = '';
    double t = 0.0;
    if (quantidadeInd > 0) {
      individual = quantidadeInd;
    }
    if (quantidadeTotal > 0) {
      animal = quantidadeTotal;
    }
    t = animal * individual;
    total = t.toStringAsFixed(2);
    return total;
  }

  Future<bool> _requestPop() {
    if (_gastoEdited) {
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
    } else {
      return Future.value(true);
    }
  }
}

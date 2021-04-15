import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/lote.dart';

class CadastroLote extends StatefulWidget {
  final Lote lote;

  CadastroLote({this.lote});

  @override
  _CadastroLoteState createState() => _CadastroLoteState();
}

class _CadastroLoteState extends State<CadastroLote> {
  final _nomeLoteController = TextEditingController();
  final _quantidadeController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _loteEdited = false;

  Lote _editedLote;

  @override
  void initState() {
    super.initState();

    if (widget.lote == null) {
      _editedLote = Lote();
    } else {
      _editedLote = Lote.fromMap(widget.lote.toMap());
      _nomeLoteController.text = _editedLote.name;
      _quantidadeController.text = _editedLote.quantidade.toString();
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_editedLote.name ?? "Cadastrar Lote"),
            centerTitle: true,
            actions: [],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedLote.name != null && _editedLote.name.isNotEmpty) {
                Navigator.pop(context, _editedLote);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
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
                    decoration: InputDecoration(labelText: "Nome"),
                    onChanged: (text) {
                      _loteEdited = true;
                      setState(() {
                        _editedLote.name = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _quantidadeController,
                    decoration:
                        InputDecoration(labelText: "Quantidade de animais"),
                    onChanged: (text) {
                      _loteEdited = true;
                      setState(() {
                        _editedLote.quantidade = int.parse(text);
                      });
                    },
                    keyboardType: TextInputType.number,
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

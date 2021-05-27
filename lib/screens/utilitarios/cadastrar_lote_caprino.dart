import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/lote.dart';

class CadastroCaprinoLote extends StatefulWidget {
  final Lote lote;

  CadastroCaprinoLote({this.lote});

  @override
  _CadastroCaprinoLoteState createState() => _CadastroCaprinoLoteState();
}

class _CadastroCaprinoLoteState extends State<CadastroCaprinoLote> {
  final _nomeLoteController = TextEditingController();

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
      _nomeLoteController.text = _editedLote.nome;
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text(_editedLote.nome ?? "Cadastrar Lote"),
            centerTitle: true,
            actions: [],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (_editedLote.nome != null && _editedLote.nome.isNotEmpty) {
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
                        _editedLote.nome = text;
                      });
                    },
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

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/models/preco_leite.dart';
import 'package:toast/toast.dart';

class CadastroPrecoLeite extends StatefulWidget {
  final PrecoLeite precoLeite;
  CadastroPrecoLeite({this.precoLeite});
  @override
  _CadastroPrecoLeiteState createState() => _CadastroPrecoLeiteState();
}

class _CadastroPrecoLeiteState extends State<CadastroPrecoLeite> {
  final dataPrecoLeite = MaskedTextController(mask: "00-0000");
  final precoController = TextEditingController();

  bool _precoLeiteEdited = false;
  PrecoLeite _editedPrecoLeite;

  @override
  void initState() {
    super.initState();
    if (widget.precoLeite == null) {
      _editedPrecoLeite = PrecoLeite();
    } else {
      _editedPrecoLeite = PrecoLeite.fromMap(widget.precoLeite.toMap());
      dataPrecoLeite.text = _editedPrecoLeite.data;
      precoController.text = _editedPrecoLeite.preco.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cadastrar Preço Leite"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              if (_editedPrecoLeite.preco.isNaN) {
                Toast.show("Informe o preço", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
              } else if (_editedPrecoLeite.data.isEmpty ||
                  _editedPrecoLeite.data.length < 7) {
                Toast.show("Informe a data", context,
                    duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
              } else {
                Navigator.pop(context, _editedPrecoLeite);
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
                  controller: dataPrecoLeite,
                  maxLength: 7,
                  decoration: InputDecoration(labelText: "Informe o mês e ano"),
                  onChanged: (text) {
                    setState(() {
                      _editedPrecoLeite.data = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Preço por litro"),
                  onChanged: (text) {
                    setState(() {
                      _editedPrecoLeite.preco = double.parse(text);
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
    if (_precoLeiteEdited) {
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

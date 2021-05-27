import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/models/preco_carne_caprina.dart';
import 'package:toast/toast.dart';

class CadastroPrecoCarneCaprina extends StatefulWidget {
  final PrecoCarneCaprina precoCarneCaprina;
  CadastroPrecoCarneCaprina({this.precoCarneCaprina});
  @override
  _CadastroPrecoCarneCaprinaState createState() =>
      _CadastroPrecoCarneCaprinaState();
}

class _CadastroPrecoCarneCaprinaState extends State<CadastroPrecoCarneCaprina> {
  final dataPrecoCarne = MaskedTextController(mask: "00-0000");
  final precoController = TextEditingController();

  bool _precoCarneEdited = false;
  PrecoCarneCaprina _editedPrecoCarne;

  @override
  void initState() {
    super.initState();
    if (widget.precoCarneCaprina == null) {
      _editedPrecoCarne = PrecoCarneCaprina();
    } else {
      _editedPrecoCarne =
          PrecoCarneCaprina.fromMap(widget.precoCarneCaprina.toMap());
      dataPrecoCarne.text = _editedPrecoCarne.data;
      precoController.text = _editedPrecoCarne.preco.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cadastrar Preço Carne Caprina"),
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
                  controller: dataPrecoCarne,
                  maxLength: 7,
                  decoration: InputDecoration(labelText: "Informe o mês e ano"),
                  onChanged: (text) {
                    setState(() {
                      _editedPrecoCarne.data = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Preço por kilo"),
                  onChanged: (text) {
                    setState(() {
                      _editedPrecoCarne.preco = double.parse(text);
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
    if (_precoCarneEdited) {
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

import 'package:flutter/material.dart';

class CadastroReceitaLeite extends StatefulWidget {
  @override
  _CadastroReceitaLeiteState createState() => _CadastroReceitaLeiteState();
}

class _CadastroReceitaLeiteState extends State<CadastroReceitaLeite> {
  final _nameFocus = FocusNode();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _quantidadeController = TextEditingController();
  TextEditingController _precoController = TextEditingController();

  void _reset() {
    setState(() {
      _formKey = GlobalKey<FormState>();
      _dateController.text = "";
      _quantidadeController.text = "";
      _precoController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cadastrar Receita do Leite",
              style: TextStyle(fontSize: 15.0)),
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _reset();
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.save),
          backgroundColor: Colors.green[700],
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(
                  Icons.add_circle,
                  size: 80.0,
                  color: Color.fromARGB(255, 4, 125, 141),
                ),
                TextField(
                  controller: _dateController,
                  focusNode: _nameFocus,
                  decoration: InputDecoration(labelText: "Data coleta"),
                  onChanged: (text) {},
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _quantidadeController,
                  decoration:
                      InputDecoration(labelText: "Quantidade de Leite Mês XX"),
                  onChanged: (text) {},
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _precoController,
                  decoration:
                      InputDecoration(labelText: "Preço por litro leite"),
                  onChanged: (text) {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (true) {
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

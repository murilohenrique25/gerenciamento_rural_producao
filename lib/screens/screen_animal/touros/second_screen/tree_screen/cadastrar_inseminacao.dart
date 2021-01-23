import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CadastroInseminacao extends StatefulWidget {
  @override
  _CadastroInseminacaoState createState() => _CadastroInseminacaoState();
}

class _CadastroInseminacaoState extends State<CadastroInseminacao> {
  TextEditingController _nomeVacaController = TextEditingController();
  TextEditingController _semenController = TextEditingController();
  TextEditingController _inseminadorController = TextEditingController();
  TextEditingController _obsController = TextEditingController();

  var _dataInse = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  void _reset() {
    setState(() {
      _formKey = GlobalKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        title: Text(
          "Cadastrar Inseminação",
          style: TextStyle(fontSize: 15.0),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _reset,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.add_circle,
                size: 80.0,
                color: Color.fromARGB(255, 4, 125, 141),
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Vaca",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: _nomeVacaController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe o numero da vaca";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Sêmen",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: _semenController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe o sêmen";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Inseminador(a)",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: _inseminadorController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe o(a) inseminador(a)";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Data",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: _dataInse,
                // ignore: missing_return
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Observação",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: _obsController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe a Observação";
                  }
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Text(
                      "Salvar Inseminação",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
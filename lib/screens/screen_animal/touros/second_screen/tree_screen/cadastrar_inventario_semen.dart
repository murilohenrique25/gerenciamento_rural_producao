import 'package:flutter/material.dart';

class CadastroInventarioSemen extends StatefulWidget {
  @override
  _CadastroInventarioSemenState createState() =>
      _CadastroInventarioSemenState();
}

class _CadastroInventarioSemenState extends State<CadastroInventarioSemen> {
  int _radioValue = 0;
  int _radioValueTamanho = 0;
  TextEditingController _nomeTouroController = TextEditingController();
  TextEditingController _quantidadeController = TextEditingController();
  TextEditingController _corPalhetaController = TextEditingController();

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
          "Cadastrar Inventário de Sêmen",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Código IA:"),
                  Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: (int value) {
                        setState(() {
                          _radioValue = value;
                        });
                      }),
                  Text("Sexado"),
                  Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: (int value) {
                        setState(() {
                          _radioValue = value;
                        });
                      }),
                  Text("Não Sexado"),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Touro",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: _nomeTouroController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe o touro";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Estoque de Palheta",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: _quantidadeController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe a quantidade";
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text("Tamanho Palheta:"),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Radio(
                            value: 0,
                            groupValue: _radioValueTamanho,
                            onChanged: (int value) {
                              setState(() {
                                _radioValueTamanho = value;
                              });
                            }),
                        Text("Pequena"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Radio(
                            value: 1,
                            groupValue: _radioValueTamanho,
                            onChanged: (int value) {
                              setState(() {
                                _radioValueTamanho = value;
                              });
                            }),
                        Text("Média"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Radio(
                            value: 1,
                            groupValue: _radioValueTamanho,
                            onChanged: (int value) {
                              setState(() {
                                _radioValueTamanho = value;
                              });
                            }),
                        Text("Grande"),
                      ],
                    ),
                  ),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Cor da Palheta",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: _corPalhetaController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe a Observação";
                  }
                },
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
                      "Salvar Animal",
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

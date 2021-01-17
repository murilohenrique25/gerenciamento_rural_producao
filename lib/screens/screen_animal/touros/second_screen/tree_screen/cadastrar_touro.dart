import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

class CadastroTouro extends StatefulWidget {
  @override
  _CadastroTouroState createState() => _CadastroTouroState();
}

class _CadastroTouroState extends State<CadastroTouro> {
  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  String numeroData;
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _racaController = TextEditingController();
  TextEditingController _geneologiaController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _idadeAnimal = "1 ano";

  DateTime _selectedDate = DateTime.now();

  DateFormat _conversor = DateFormat();

  int _radioValue = 0;

  final df = new DateFormat("dd-MM-yyyy");

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  void _reset() {
    setState(() {
      _formKey = GlobalKey();
      numeroData = "";
      _dataNasc = MaskedTextController(mask: '00-00-0000');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        title: Text(
          "Cadastrar Touro",
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
                    labelText: "Nome",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: _nomeController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe o nome do animal";
                  }
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Raça",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: _racaController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe a raça do animal";
                  }
                },
              ),
              TextFormField(
                onChanged: (text) {
                  numeroData = text;
                  setState(() {
                    differenceDate();
                  });
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Data de Nascimento",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: _dataNasc,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe o data denascimento do animal";
                  }
                },
              ),
              SizedBox(
                height: 15.0,
              ),
              Text("Idade do Animal" ?? "Idade do animal:  ${differenceDate()}",
                  style: TextStyle(
                      fontSize: 16.0, color: Color.fromARGB(255, 4, 125, 141))),
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Geneologia",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: _geneologiaController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe a geneologia";
                  }
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: (int value) {
                        setState(() {
                          _radioValue = value;
                        });
                      }),
                  Text("Vivo"),
                  Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: (int value) {
                        setState(() {
                          _radioValue = value;
                        });
                      }),
                  Text("Morto"),
                ],
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

  // _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate, // Refer step 1
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime(2022),
  //   );

  //   if (picked != null && picked != _selectedDate)
  //     setState(() {
  //       _selectedDate = picked;
  //       differenceDate();
  //     });
  // }
  String differenceDate() {
    String num = "";
    DateTime dt = DateTime.now();
    if (numeroData.isNotEmpty) {
      num = numeroData.split('-').reversed.join();
    }

    DateTime date = DateTime.parse(num);
    int quant = dt.difference(date).inDays;
    if (quant < 0) {
      _idadeAnimal = "Data incorreta";
    } else if (quant < 365) {
      _idadeAnimal = "$quant dias";
    } else if (quant == 365) {
      _idadeAnimal = "1 ano";
    } else if (quant > 365 && quant < 731) {
      _idadeAnimal = "1 ano";
    } else if (quant > 731 && quant < 1096) {
      _idadeAnimal = "2 anos";
    } else if (quant > 1095 && quant < 1461) {
      _idadeAnimal = "3 anos";
    } else if (quant > 1460 && quant < 1826) {
      _idadeAnimal = "4 anos";
    } else if (quant > 1825 && quant < 2191) {
      _idadeAnimal = "5 anos";
    } else if (quant > 2190 && quant < 2556) {
      _idadeAnimal = "6 anos";
    } else {
      _idadeAnimal = "Ohh já está idoso";
    }
    return _idadeAnimal;
  }
}

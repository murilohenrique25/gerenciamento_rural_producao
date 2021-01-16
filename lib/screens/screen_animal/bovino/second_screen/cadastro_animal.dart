import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/lote_db.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:intl/intl.dart';

class CadastroAnimal extends StatefulWidget {
  @override
  _CadastroAnimalState createState() => _CadastroAnimalState();
}

class _CadastroAnimalState extends State<CadastroAnimal> {
  LoteDB helper = LoteDB();
  List<Lote> lotes = List();

  @override
  void initState() {
    super.initState();
    _getAllLotes();
  }

  void _getAllLotes() {
    helper.getAllItems().then((list) {
      setState(() {
        lotes = list;
      });
    });
  }

  List<Item> _ecc = <Item>[
    const Item("Não especificado"),
    const Item("1 - Raquítico"),
    const Item("2 - Magro"),
    const Item("3 - Ideal"),
    const Item("4 - Gordo"),
    const Item("5 - Obeso"),
  ];

  List<Item> _status = <Item>[
    const Item("Não especificado"),
    const Item("F. Solteira"),
    const Item("F. Em Protocolo"),
    const Item("F. Inseminada"),
    const Item("M. Em Serviço Rm"),
    const Item("M. Em Serviço Ru"),
    const Item("M. Desncaso"),
  ];
  Item selectedECC;

  Item selectedStatus;

  Item selectedLote;
  int selectedLotes;

  //String _infoText = "Informe os dados!";

  TextEditingController nomeController = TextEditingController();

  TextEditingController brincoController = TextEditingController();

  TextEditingController pesoController = TextEditingController();

  TextEditingController racaController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();

  int _radioValue = 0;

  final df = new DateFormat("dd-MM-yyyy");

  String _idadeAnimal = "1ano e 2meses";

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  void _reset() {
    nomeController.text = "";
    pesoController.text = "";
    setState(() {
      _formKey = GlobalKey();
      selectedECC = _ecc[0];
      selectedStatus = _status[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldstate,
      appBar: AppBar(
        title: Text(
          "Cadastrar Bovino de Corte",
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
                  Radio(
                      value: 0,
                      groupValue: _radioValue,
                      onChanged: (int value) {
                        setState(() {
                          _radioValue = value;
                        });
                      }),
                  Text("Vaca"),
                  Radio(
                      value: 1,
                      groupValue: _radioValue,
                      onChanged: (int value) {
                        setState(() {
                          _radioValue = value;
                        });
                      }),
                  Text("Novilha"),
                  Radio(
                      value: 2,
                      groupValue: _radioValue,
                      onChanged: (int value) {
                        setState(() {
                          _radioValue = value;
                        });
                      }),
                  Text("Bezerra"),
                ],
              ),
              SizedBox(
                height: 20,
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
                controller: nomeController,
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
              Row(
                children: [
                  RaisedButton(
                    onPressed: () => _selectDate(context), // Refer step 3
                    child: Text(
                      'Selecione a data de nascimento',
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    color: Color.fromARGB(255, 4, 125, 141),
                  ),
                  Text(
                    " :" + df.format(_selectedDate),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                "Idade animal:  ${differenceDate()}",
                style: TextStyle(
                    fontSize: 16.0, color: Color.fromARGB(255, 4, 125, 141)),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Raça",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: racaController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe a raça do animal";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Peso (Kg)",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: brincoController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe o peso do animal";
                  }
                },
              ),
              TextFormField(
                enabled: false,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: "Número do brinco",
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 4, 125, 141))),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Color.fromARGB(255, 4, 125, 141), fontSize: 15.0),
                controller: pesoController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe o número do brinco";
                  }
                },
              ),
              DropdownButton(
                hint: Text("Selecione o Lote"),
                value: selectedLotes,
                onChanged: (value) {
                  setState(() {
                    selectedLotes = value;
                  });
                },
                items: lotes.map((value) {
                  return DropdownMenuItem(
                    value: value.id,
                    child: Row(
                      children: [
                        Text(value.name),
                      ],
                    ),
                  );
                }).toList(),
              ),
              DropdownButton<Item>(
                hint: Text("Selecione o ECC"),
                value: selectedECC,
                onChanged: (Item value) {
                  setState(() {
                    selectedECC = value;
                  });
                },
                items: _ecc.map((Item ecc) {
                  return DropdownMenuItem(
                    value: ecc,
                    child: Row(
                      children: [
                        Text(ecc.name),
                      ],
                    ),
                  );
                }).toList(),
              ),
              DropdownButton<Item>(
                hint: Text("Selecione o Status"),
                value: selectedStatus,
                onChanged: (Item value) {
                  setState(() {
                    selectedStatus = value;
                  });
                },
                items: _status.map((Item status) {
                  return DropdownMenuItem(
                    value: status,
                    child: Row(
                      children: [
                        Text(status.name),
                      ],
                    ),
                  );
                }).toList(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (selectedECC == _ecc[0] || selectedECC == null) {
                        _scaffoldstate.currentState.showSnackBar(
                          new SnackBar(
                            duration: new Duration(seconds: 2),
                            content: new Text("Selecione um ECC"),
                          ),
                        );
                      }
                      if (selectedStatus == _status[0]) {
                        _scaffoldstate.currentState.showSnackBar(
                          new SnackBar(
                            duration: new Duration(seconds: 2),
                            content: new Text("Selecione um Status"),
                          ),
                        );
                      }
                      if (_formKey.currentState.validate()) {}
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

  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Refer step 1
      firstDate: DateTime(1900),
      lastDate: DateTime(2022),
    );

    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        differenceDate();
      });
  }

  String differenceDate() {
    DateTime dt = DateTime.now();

    int quant = dt.difference(_selectedDate).inDays;
    if (quant < 0) {
      _idadeAnimal = "Data incorreta";
    } else if (quant < 365) {
      _idadeAnimal = "$quant dias";
    } else if (quant == 365) {
      _idadeAnimal = "1 ano";
    } else if (quant > 365 && quant < 731) {
      int dias = quant - 365;
      _idadeAnimal = "1 ano e $dias dias";
    } else if (quant > 731 && quant < 1096) {
      int dias = quant - 731;
      _idadeAnimal = "2 ano e $dias dias";
    } else if (quant > 1095 && quant < 1461) {
      int dias = quant - 1095;
      _idadeAnimal = "3 ano e $dias dias";
    } else if (quant > 1460 && quant < 1826) {
      int dias = quant - 1460;
      _idadeAnimal = "4 ano e $dias dias";
    } else if (quant > 1825 && quant < 2191) {
      int dias = quant - 1825;
      _idadeAnimal = "5 ano e $dias dias";
    } else if (quant > 2190 && quant < 2.556) {
      int dias = quant - 2190;
      _idadeAnimal = "6 ano e $dias dias";
    }
    return _idadeAnimal;
  }
}

class Item {
  const Item(this.name);
  final String name;
}

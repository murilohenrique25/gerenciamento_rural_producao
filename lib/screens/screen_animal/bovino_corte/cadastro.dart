import 'package:flutter/material.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
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

  TextEditingController nomeController = TextEditingController();

  TextEditingController brincoController = TextEditingController();

  TextEditingController pesoController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          "Cadastrar Bovino de Leite",
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
                controller: nomeController,
                // ignore: missing_return
                validator: (value) {
                  if (value.isEmpty) {
                    return "Informe o nome do animal";
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
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedECC == _ecc[0] || selectedECC == null) {
                        // ignore: deprecated_member_use
                        _scaffoldstate.currentState.showSnackBar(
                          new SnackBar(
                            duration: new Duration(seconds: 2),
                            content: new Text("Selecione um ECC"),
                          ),
                        );
                      }
                      if (selectedStatus == _status[0]) {
                        // ignore: deprecated_member_use
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

class Item {
  const Item(this.name);
  final String name;
}

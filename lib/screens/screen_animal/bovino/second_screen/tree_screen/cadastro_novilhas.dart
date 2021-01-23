import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/lote_db.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CadastroNovilha extends StatefulWidget {
  @override
  _CadastroNovilhaState createState() => _CadastroNovilhaState();
}

class _CadastroNovilhaState extends State<CadastroNovilha> {
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
    const Item("M. Descanso"),
  ];
  Item selectedECC;

  Item selectedStatus;

  Item selectedLote;
  int selectedLotes;

  //String _infoText = "Informe os dados!";

  final nomeController = TextEditingController();
  final pesoController = TextEditingController();
  final pesoDesmamaController = TextEditingController();
  final pesoPrimeiraCoberturaController = TextEditingController();
  final racaController = TextEditingController();
  final diagnosticogestacaoController = TextEditingController();
  final pedigreeController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var dataDesmamaController = MaskedTextController(mask: '00-00-0000');
  var dataUltimaInseminacaoController =
      MaskedTextController(mask: '00-00-0000');

  DateTime _selectedDate = DateTime.now();

  final _nameFocus = FocusNode();

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
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        key: _scaffoldstate,
        appBar: AppBar(
          title: Text(
            "Cadastrar Novilha",
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.save),
          backgroundColor: Colors.green[700],
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

                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: nomeController,
                  focusNode: _nameFocus,
                  decoration: InputDecoration(labelText: "Nome / Nº Brinco"),
                  onChanged: (text) {},
                ),
                SearchableDropdown.single(
                  items: lotes.map((Lote lote) {
                    return DropdownMenuItem(
                      value: lote.id,
                      child: Row(
                        children: [
                          Text(lote.name),
                        ],
                      ),
                    );
                  }).toList(),
                  value: selectedLotes,
                  hint: "Selecione um Lote",
                  searchHint: "Selecione um Lote",
                  onChanged: (value) {
                    setState(() {
                      selectedLotes = value;
                    });
                  },
                  doneButton: "Pronto",
                  displayItem: (item, selected) {
                    return (Row(children: [
                      selected
                          ? Icon(
                              Icons.radio_button_checked,
                              color: Colors.grey,
                            )
                          : Icon(
                              Icons.radio_button_unchecked,
                              color: Colors.grey,
                            ),
                      SizedBox(width: 7),
                      Expanded(
                        child: item,
                      ),
                    ]));
                  },
                  isExpanded: true,
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Text(
                  "Idade animal:  ${differenceDate()}",
                  style: TextStyle(
                      fontSize: 16.0, color: Color.fromARGB(255, 4, 125, 141)),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {},
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: pesoController,
                  decoration: InputDecoration(labelText: "Peso ao nascimento"),
                  onChanged: (text) {},
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: pesoDesmamaController,
                  decoration: InputDecoration(labelText: "Peso na desmama"),
                  onChanged: (text) {},
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: pesoPrimeiraCoberturaController,
                  decoration:
                      InputDecoration(labelText: "Peso na 1ª cobertura"),
                  onChanged: (text) {},
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: pedigreeController,
                  decoration: InputDecoration(labelText: "Pedigree"),
                  onChanged: (text) {},
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Text(
                    "Idade 1ª cobertura: xx-xx-xxxx",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141)),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Text(
                    "Idade primeiro: xx-xx-xxxx",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141)),
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: diagnosticogestacaoController,
                  decoration:
                      InputDecoration(labelText: "Diagnóstico de gestação"),
                  onChanged: (text) {},
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 30.0),
                ),
                // DropdownButton<Item>(
                //   hint: Text("Selecione o ECC"),
                //   value: selectedECC,
                //   onChanged: (Item value) {
                //     setState(() {
                //       selectedECC = value;
                //     });
                //   },
                //   items: _ecc.map((Item ecc) {
                //     return DropdownMenuItem(
                //       value: ecc,
                //       child: Row(
                //         children: [
                //           Text(ecc.name),
                //         ],
                //       ),
                //     );
                //   }).toList(),
                // ),
                // DropdownButton<Item>(
                //   hint: Text("Selecione o Status"),
                //   value: selectedStatus,
                //   onChanged: (Item value) {
                //     setState(() {
                //       selectedStatus = value;
                //     });
                //   },
                //   items: _status.map((Item status) {
                //     return DropdownMenuItem(
                //       value: status,
                //       child: Row(
                //         children: [
                //           Text(status.name),
                //         ],
                //       ),
                //     );
                //   }).toList(),
                // ),
              ],
            ),
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

  Future<bool> _requestPop() {
    if (true) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: [
                FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
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

class Item {
  const Item(this.name);
  final String name;
}

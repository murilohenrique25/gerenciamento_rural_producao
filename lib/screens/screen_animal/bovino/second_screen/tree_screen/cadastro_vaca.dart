import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/lote_db.dart';
import 'package:gerenciamento_rural/helpers/vaca_db.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/models/vaca.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CadastroVaca extends StatefulWidget {
  final Vaca vaca;

  CadastroVaca({this.vaca});
  @override
  _CadastroVacaState createState() => _CadastroVacaState();
}

class _CadastroVacaState extends State<CadastroVaca> {
  LoteDB helperLote = LoteDB();
  List<Lote> lotes = List();

  VacaDB helper = VacaDB();
  List<Vaca> vacas = List();
  final _nameFocus = FocusNode();

  bool _vacasEdited = false;

  Vaca _editedVaca;

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

  int selectedLote;

  int selectedLotes;

  void _reset() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getAllLotes();
    if (widget.vaca == null) {
      _editedVaca = Vaca();
    } else {
      _editedVaca = Vaca.fromMap(widget.vaca.toMap());
    }
  }

  var dataUltInsemiController = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nomeController = TextEditingController();
  TextEditingController _racaController = TextEditingController();
  TextEditingController _paiController = TextEditingController();
  TextEditingController _maeController = TextEditingController();
  TextEditingController _avoMMaternoController = TextEditingController();
  TextEditingController _avoFMaternoController = TextEditingController();
  TextEditingController _avoFPaternoController = TextEditingController();
  TextEditingController _avoMPaternoController = TextEditingController();
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pedigree'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _paiController,
                  decoration: InputDecoration(labelText: "Pai"),
                  onChanged: (text) {},
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    print(text);
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoFPaternoController,
                  decoration: InputDecoration(labelText: "Avó Paterno"),
                  onChanged: (text) {
                    print(text);
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoMPaternoController,
                  decoration: InputDecoration(labelText: "Avô Paterno"),
                  onChanged: (text) {
                    print(text);
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoFMaternoController,
                  decoration: InputDecoration(labelText: "Avó Materno"),
                  onChanged: (text) {
                    print(text);
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoMMaternoController,
                  decoration: InputDecoration(labelText: "Avô Materno"),
                  onChanged: (text) {
                    print(text);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Feito'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  final df = new DateFormat("dd-MM-yyyy");

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        key: _scaffoldstate,
        appBar: AppBar(
          title: Text(
            "Cadastrar Vaca",
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
                  controller: _nomeController,
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
                // Row(
                //   children: [
                //     RaisedButton(
                //       onPressed: () => _selectDate(context), // Refer step 3
                //       child: Text(
                //         'Selecione a data de nascimento',
                //         style: TextStyle(
                //             color: Colors.black, fontWeight: FontWeight.bold),
                //       ),
                //       color: Color.fromARGB(255, 4, 125, 141),
                //     ),
                //     Text(
                //       " :" + df.format(_selectedDate),
                //       style:
                //           TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                //     ),
                //   ],
                // ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {},
                ),

                TextField(
                  keyboardType: TextInputType.text,
                  controller: dataUltInsemiController,
                  decoration: InputDecoration(labelText: "Última inseminação"),
                  onChanged: (text) {},
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Text(
                    "Secagem Prevista: xx-xx-xxxx",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141)),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Text(
                    "Parto Previsto: xx-xx-xxxx",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141)),
                  ),
                ),

                SizedBox(height: 5.0),
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

                RaisedButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: Text("Pedigree"),
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

  void _getAllLotes() {
    helperLote.getAllItems().then((list) {
      setState(() {
        lotes = list;
      });
    });
  }
}

class Item {
  const Item(this.name);
  final String name;
}

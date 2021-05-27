import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/nutricao_suina.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CadastroNutricaoSuino extends StatefulWidget {
  final NutricaoSuina nutricaoSuina;
  CadastroNutricaoSuino({this.nutricaoSuina});
  @override
  _CadastroNutricaoSuinoState createState() => _CadastroNutricaoSuinoState();
}

class _CadastroNutricaoSuinoState extends State<CadastroNutricaoSuino> {
  List<String> estado = [
    "Aleitamento",
    "Creche",
    "Terminação",
    "Matrizes",
    "Cachaços"
  ];
  String nomeEstado = "";
  double quantidadeTotal = 0;
  double quantidadeInd = 0;
  bool _nutricaoEdited = false;
  NutricaoSuina _editedNutricao;
  final _loteController = TextEditingController();
  final _ingredientesController = TextEditingController();
  final _quantidadeIndividualController = TextEditingController();
  final _baiaController = TextEditingController();
  final _ndtController = TextEditingController();
  final _pbController = TextEditingController();
  final _edController = TextEditingController();
  final _quantidadeAnimalController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final df = new DateFormat("dd-MM-yyyy");

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

  void _reset() {
    setState(() {
      _formKey = GlobalKey();
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.nutricaoSuina == null) {
      _editedNutricao = NutricaoSuina();
    } else {
      _editedNutricao = NutricaoSuina.fromMap(widget.nutricaoSuina.toMap());
      _loteController.text = _editedNutricao.nomeLote;
      nomeEstado = _editedNutricao.fase;
      _ingredientesController.text = _editedNutricao.ingredientes;
      _baiaController.text = _editedNutricao.baia;
      _ndtController.text = _editedNutricao.ndt.toString();
      _pbController.text = _editedNutricao.pb.toString();
      _edController.text = _editedNutricao.ed.toString();
      quantidadeInd = _editedNutricao.quantidadeInd;
      _quantidadeIndividualController.text =
          _editedNutricao.quantidadeInd.toString();
      quantidadeTotal = _editedNutricao.quantidadeAnimais;
      _quantidadeAnimalController.text =
          _editedNutricao.quantidadeAnimais.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        key: _scaffoldstate,
        appBar: AppBar(
          title: Text(
            "Cadastrar Nutrição",
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
          onPressed: () {
            double total = double.parse(calcularTotal());
            _editedNutricao.quantidadeTotal = total;
            DateTime dataAgora = DateTime.now();
            var formatData = new DateFormat("dd-MM-yyyy");
            String dataCadastro = formatData.format(dataAgora);
            _editedNutricao.data = dataCadastro;
            Navigator.pop(context, _editedNutricao);
          },
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
                  controller: _loteController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Lote"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.nomeLote = text;
                    });
                  },
                ),
                SearchableDropdown.single(
                  items: estado.map((estado) {
                    return DropdownMenuItem(
                      value: estado,
                      child: Row(
                        children: [
                          Text(estado),
                        ],
                      ),
                    );
                  }).toList(),
                  value: estado,
                  hint: "Selecione um Estado",
                  searchHint: "Selecione um Estado",
                  onChanged: (value) {
                    _nutricaoEdited = true;
                    setState(() {
                      nomeEstado = value;
                      _editedNutricao.fase = value;
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
                Text("Estado selecionado:  $nomeEstado",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _ingredientesController,
                  decoration: InputDecoration(labelText: "Ingredientes"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.ingredientes = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.baia = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _ndtController,
                  decoration: InputDecoration(labelText: "NDT %"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.ndt = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pbController,
                  decoration: InputDecoration(labelText: "PB %"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.pb = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _edController,
                  decoration: InputDecoration(labelText: "ED %"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.ed = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _quantidadeIndividualController,
                  decoration:
                      InputDecoration(labelText: "Quantidade por dia Kg"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      quantidadeInd = double.parse(text);
                      _editedNutricao.quantidadeInd = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _quantidadeAnimalController,
                  decoration:
                      InputDecoration(labelText: "Quantidade de animais"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      quantidadeTotal = double.parse(text);
                      _editedNutricao.quantidadeAnimais = double.parse(text);
                    });
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "Quantidade total por dia Kg: ${calcularTotal()}",
                  style: TextStyle(
                      fontSize: 16.0, color: Color.fromARGB(255, 4, 125, 141)),
                ),
                SizedBox(
                  height: 20.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String calcularTotal() {
    double animal = 0;
    double individual = 0.0;
    String total = '';
    double t = 0.0;
    if (quantidadeInd > 0) {
      individual = quantidadeInd;
    }
    if (quantidadeTotal > 0) {
      animal = quantidadeTotal;
    }
    t = animal * individual;
    total = t.toStringAsFixed(2);
    return total;
  }

  Future<bool> _requestPop() {
    if (_nutricaoEdited) {
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

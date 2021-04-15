import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/lote_db.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/models/nutricao_suplementar.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CadastroNutricaoSuplemento extends StatefulWidget {
  final NutricaoSuplementar nutricaoSuplementar;
  CadastroNutricaoSuplemento({this.nutricaoSuplementar});
  @override
  _CadastroNutricaoSuplementoState createState() =>
      _CadastroNutricaoSuplementoState();
}

class _CadastroNutricaoSuplementoState
    extends State<CadastroNutricaoSuplemento> {
  LoteDB helperLote = LoteDB();
  List<Lote> lotes = [];
  NutricaoSuplementar _editedNutricao;
  bool _nutricaoEdited = false;
  final _nameFocus = FocusNode();

  Lote lote;

  final _quantIndController = TextEditingController();
  final _quantTotalController = TextEditingController();
  final _ingredientesController = TextEditingController();
  final _obsController = TextEditingController();

  final df = new DateFormat("dd-MM-yyyy");

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    _getAllLotes();
    if (widget.nutricaoSuplementar == null) {
      _editedNutricao = NutricaoSuplementar();
    } else {
      _editedNutricao =
          NutricaoSuplementar.fromMap(widget.nutricaoSuplementar.toMap());
      _quantIndController.text = _editedNutricao.quantidadeInd.toString();
      _quantTotalController.text = _editedNutricao.quantidadeTotal.toString();
      _ingredientesController.text = _editedNutricao.ingredientes;
      _obsController.text = _editedNutricao.observacao;
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
            "Suplemento Mineral",
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
            DateTime dt = DateTime.now();
            df.format(dt);
            String dataAgora = df.format(dt);
            _editedNutricao.data = dataAgora;
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
                SearchableDropdown.single(
                  items: lotes.map((lote) {
                    return DropdownMenuItem(
                      value: lote,
                      child: Row(
                        children: [
                          Text(lote.name),
                        ],
                      ),
                    );
                  }).toList(),
                  value: lote,
                  hint: "Selecione um Lote",
                  searchHint: "Selecione um Lote",
                  onChanged: (value) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.id = value.id;
                      _editedNutricao.nomeLote = value.name;
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
                TextField(
                  focusNode: _nameFocus,
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
                  keyboardType: TextInputType.text,
                  controller: _quantIndController,
                  decoration: InputDecoration(
                      labelText: "Quantidade individual por dia"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.quantidadeInd = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _quantTotalController,
                  decoration:
                      InputDecoration(labelText: "Quantidade total por dia"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.quantidadeTotal = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _obsController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.observacao = text;
                    });
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

  void _getAllLotes() {
    helperLote.getAllItems().then((list) {
      setState(() {
        lotes = list;
      });
    });
  }
}

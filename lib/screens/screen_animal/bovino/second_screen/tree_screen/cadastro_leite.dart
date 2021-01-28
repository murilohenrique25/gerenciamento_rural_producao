import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/producao_leite.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CadastroLeite extends StatefulWidget {
  final ProducaoLeite producaoLeite;

  CadastroLeite({this.producaoLeite});
  @override
  _CadastroLeiteState createState() => _CadastroLeiteState();
}

class _CadastroLeiteState extends State<CadastroLeite> {
  List<Mes> meses = <Mes>[
    const Mes(0, "Janeiro"),
    const Mes(1, "Fevereiro"),
    const Mes(2, "Março"),
    const Mes(3, "Abril"),
    const Mes(4, "Maio"),
    const Mes(5, "Junho"),
    const Mes(6, "Julho"),
    const Mes(7, "Agosto"),
    const Mes(8, "Setembro"),
    const Mes(9, "Outubro"),
    const Mes(10, "Novembro"),
    const Mes(11, "Dezembro"),
  ];
  final _nameFocus = FocusNode();

  bool _producaoLeiteEdited = false;

  ProducaoLeite _editedProdLeite;

  int selectedValue;

  @override
  void initState() {
    super.initState();

    if (widget.producaoLeite == null) {
      _editedProdLeite = ProducaoLeite();
    } else {
      _editedProdLeite = ProducaoLeite.fromMap(widget.producaoLeite.toMap());
      _quantidadeController.text = _editedProdLeite.quantidade.toString();
      _gorduraController.text = _editedProdLeite.gordura.toString();
      _proteinaController.text = _editedProdLeite.proteina.toString();
      _lactoseController.text = _editedProdLeite.lactose.toString();
      _ureiaController.text = _editedProdLeite.ureia.toString();
      _ccsController.text = _editedProdLeite.ccs.toString();
      _cbtController.text = _editedProdLeite.cbt.toString();
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _quantidadeController = TextEditingController();
  TextEditingController _gorduraController = TextEditingController();
  TextEditingController _proteinaController = TextEditingController();
  TextEditingController _lactoseController = TextEditingController();
  TextEditingController _ureiaController = TextEditingController();
  TextEditingController _ccsController = TextEditingController();
  TextEditingController _cbtController = TextEditingController();
  void _reset() {
    setState(() {
      _formKey = GlobalKey<FormState>();
      _dateController.text = "";
      _quantidadeController.text = "";
      _gorduraController.text = "";
      _proteinaController.text = "";
      _lactoseController.text = "";
      _ureiaController.text = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Cadastrar Produção do Leite",
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
          onPressed: () {
            if (_editedProdLeite.quantidade != null &&
                _editedProdLeite.quantidade.toString().isNotEmpty) {
              Navigator.pop(context, _editedProdLeite);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.green[700],
        ),
        body: SingleChildScrollView(
          child: Form(
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
                  SizedBox(height: 5.0),
                  SearchableDropdown.single(
                    items: meses.map((Mes mes) {
                      return DropdownMenuItem(
                        value: mes.numeroMes,
                        child: Row(
                          children: [
                            Text(mes.nomeMes),
                          ],
                        ),
                      );
                    }).toList(),
                    value: selectedValue,
                    hint: "Selecione o mês",
                    searchHint: "Selecione o mês",
                    onChanged: (value) {
                      setState(() {
                        selectedValue = value;
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
                    height: 5.0,
                  ),
                  TextField(
                    enabled: false,
                    controller: _dateController,
                    focusNode: _nameFocus,
                    decoration: InputDecoration(labelText: "Data coleta"),
                    onChanged: (text) {
                      _producaoLeiteEdited = true;
                      setState(() {
                        _editedProdLeite.dataColeta = text;
                      });
                    },
                  ),
                  TextField(
                    controller: _quantidadeController,
                    decoration:
                        InputDecoration(labelText: "Quantidade de Leite LT"),
                    onChanged: (text) {
                      _producaoLeiteEdited = true;
                      setState(() {
                        _editedProdLeite.quantidade = double.parse(text);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _gorduraController,
                    decoration: InputDecoration(labelText: "Gordura %"),
                    onChanged: (text) {
                      _producaoLeiteEdited = true;
                      setState(() {
                        _editedProdLeite.gordura = double.parse(text);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _proteinaController,
                    decoration: InputDecoration(labelText: "Proteínas %"),
                    onChanged: (text) {
                      _producaoLeiteEdited = true;
                      setState(() {
                        _editedProdLeite.proteina = double.parse(text);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _lactoseController,
                    decoration: InputDecoration(labelText: "Lactose %"),
                    onChanged: (text) {
                      _producaoLeiteEdited = true;
                      setState(() {
                        _editedProdLeite.lactose = double.parse(text);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _ureiaController,
                    decoration: InputDecoration(labelText: "Ureia %"),
                    onChanged: (text) {
                      _producaoLeiteEdited = true;
                      setState(() {
                        _editedProdLeite.ureia = double.parse(text);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _ccsController,
                    decoration: InputDecoration(labelText: "CCS"),
                    onChanged: (text) {
                      _producaoLeiteEdited = true;
                      setState(() {
                        _editedProdLeite.ccs = double.parse(text);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: _cbtController,
                    decoration: InputDecoration(labelText: "CBT"),
                    onChanged: (text) {
                      _producaoLeiteEdited = true;
                      setState(() {
                        _editedProdLeite.cbt = double.parse(text);
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_producaoLeiteEdited) {
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
    } else {
      return Future.value(true);
    }
  }
}

class Mes {
  final int numeroMes;
  final String nomeMes;
  const Mes(this.numeroMes, this.nomeMes);
}

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/models/leite.dart';
//
import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroLeite extends StatefulWidget {
  final Leite producaoLeite;

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

  Leite _editedProdLeite;

  var dataColeta = MaskedTextController(mask: '00-00-0000');

  @override
  void initState() {
    super.initState();

    if (widget.producaoLeite == null) {
      _editedProdLeite = Leite();
    } else {
      _editedProdLeite = Leite.fromMap(widget.producaoLeite.toMap());
      _quantidadeController.text = _editedProdLeite.quantidade.toString();
      _gorduraController.text = _editedProdLeite.gordura.toString();
      _proteinaController.text = _editedProdLeite.proteina.toString();
      _lactoseController.text = _editedProdLeite.lactose.toString();
      _ureiaController.text = _editedProdLeite.ureia.toString();
      _ccsController.text = _editedProdLeite.ccs.toString();
      _cbtController.text = _editedProdLeite.cbt.toString();
      _idMesController.text = _editedProdLeite.idMes.toString();
      dataColeta.text = _editedProdLeite.dataColeta;
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _quantidadeController = TextEditingController();
  TextEditingController _gorduraController = TextEditingController();
  TextEditingController _proteinaController = TextEditingController();
  TextEditingController _lactoseController = TextEditingController();
  TextEditingController _ureiaController = TextEditingController();
  TextEditingController _ccsController = TextEditingController();
  TextEditingController _cbtController = TextEditingController();
  TextEditingController _idMesController = TextEditingController();
  void _reset() {
    setState(() {
      _formKey = GlobalKey<FormState>();
      _quantidadeController.text = "";
      _gorduraController.text = "";
      _proteinaController.text = "";
      _lactoseController.text = "";
      _ureiaController.text = "";
      _idMesController.text = "";
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
            if (_editedProdLeite.idMes == null) {
              Toast.show("Informe o mês", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else if (dataColeta.text.isEmpty || dataColeta.text.length < 10) {
              Toast.show("Informe a data completa", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else if (_quantidadeController.text.isEmpty) {
              Toast.show("Informe a quantidade", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else {
              if (_editedProdLeite.quantidade != null &&
                  _editedProdLeite.quantidade.toString().isNotEmpty) {
                Navigator.pop(context, _editedProdLeite);
              } else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
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
                  CustomSearchableDropDown(
                    items: meses,
                    label: 'Selecione um mês',
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.blue)),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(Icons.search),
                    ),
                    dropDownMenuItems: meses?.map((item) {
                          return item.nomeMes;
                        })?.toList() ??
                        [],
                    onChanged: (value) {
                      if (value != null) {
                        _editedProdLeite.idMes = value.numeroMes;
                      }
                    },
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: dataColeta,
                    focusNode: _nameFocus,
                    maxLength: 10,
                    decoration: InputDecoration(labelText: "Data coleta"),
                    onChanged: (text) {
                      _producaoLeiteEdited = false;
                      setState(() {
                        _editedProdLeite.dataColeta = dataColeta.text;
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

import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/aleitamento.dart';
import 'package:intl/intl.dart';

class CadastroNutricaoSuino extends StatefulWidget {
  final Aleitamento aleitamento;
  CadastroNutricaoSuino({this.aleitamento});
  @override
  _CadastroNutricaoSuinoState createState() => _CadastroNutricaoSuinoState();
}

class _CadastroNutricaoSuinoState extends State<CadastroNutricaoSuino> {
  String tipo;
  List cachacos = [];
  double quantidadeTotal = 0;
  double quantidadeInd = 0;
  bool _nutricaoEdited = false;
  final _loteController = TextEditingController();
  final _faseController = TextEditingController();
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
    _getAllLotes();
    // if (widget.aleitamento == null) {
    //   _editedBezerra = Bezerra();
    //   _editedBezerra.virouNovilha = 0;
    //   _editedBezerra.estado = "Vivo";
    // } else {
    //   _editedBezerra = Bezerra.fromMap(widget.aleitamento.toMap());
    //   _racaController.text = _editedBezerra.raca;
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
            // if (_dataColeta.text.isEmpty) {
            //   Toast.show("Data inválida.", context,
            //       duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            // } else {
            //   // Navigator.pop(context, _editedBezerra);
            // }
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
                  onChanged: (text) {},
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _faseController,
                  decoration: InputDecoration(labelText: "Fase"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.raca = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _ingredientesController,
                  decoration: InputDecoration(labelText: "Ingredientes"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.raca = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.raca = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _ndtController,
                  decoration: InputDecoration(labelText: "NDT %"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.dataDesmama = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pbController,
                  decoration: InputDecoration(labelText: "PB %"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.dataDesmama = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _edController,
                  decoration: InputDecoration(labelText: "ED %"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    // setState(() {
                    //   _editedBezerra.dataDesmama = text;
                    // });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _quantidadeIndividualController,
                  decoration:
                      InputDecoration(labelText: "Quantidade Individual"),
                  onChanged: (text) {
                    setState(() {
                      quantidadeInd = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _quantidadeAnimalController,
                  decoration:
                      InputDecoration(labelText: "Quantidade de animais"),
                  onChanged: (text) {
                    // _bezerraEdited = true;
                    setState(() {
                      quantidadeTotal = double.parse(text);
                    });
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "Quantidade Total: ${calcularTotal()}",
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

  void _getAllLotes() {
    // helperLote.getAllItems().then((list) {
    //   setState(() {
    //     lotes = list;
    //   });
    // });
  }
}

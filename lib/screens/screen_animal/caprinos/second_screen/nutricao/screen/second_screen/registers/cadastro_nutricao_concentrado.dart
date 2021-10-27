import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/nutricao_concentrado.dart';
import 'package:intl/intl.dart';

class CadastroNutricaoConcentradoCaprino extends StatefulWidget {
  final NutricaoConcentrado nutricaoConcentrado;
  CadastroNutricaoConcentradoCaprino({this.nutricaoConcentrado});
  @override
  _CadastroNutricaoConcentradoCaprinoState createState() =>
      _CadastroNutricaoConcentradoCaprinoState();
}

class _CadastroNutricaoConcentradoCaprinoState
    extends State<CadastroNutricaoConcentradoCaprino> {
  bool _nutricaoEdited = false;
  NutricaoConcentrado _editedNutricao;
  String nomeLote = "";
  final _quantIndController = TextEditingController();
  final _loteController = TextEditingController();
  final _quantTotalController = TextEditingController();
  final _pbController = TextEditingController();
  final _ndtController = TextEditingController();
  final _ingredientesController = TextEditingController();
  final _baiaController = TextEditingController();

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

    if (widget.nutricaoConcentrado == null) {
      _editedNutricao = NutricaoConcentrado();
    } else {
      _editedNutricao =
          NutricaoConcentrado.fromMap(widget.nutricaoConcentrado.toMap());
      _quantIndController.text = _editedNutricao.quantidadeInd.toString();
      _quantTotalController.text = _editedNutricao.quantidadeTotal.toString();
      _ingredientesController.text = _editedNutricao.ingredientes;
      _pbController.text = _editedNutricao.pb.toString();
      _ndtController.text = _editedNutricao.ndt.toString();
      _obsController.text = _editedNutricao.observacao;
      _baiaController.text = _editedNutricao.baia;
      _loteController.text = _editedNutricao.nomeLote;
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
            "Nutrição Concentrada",
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
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _loteController,
                  decoration: InputDecoration(labelText: "Lote"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.nomeLote = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
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
                  keyboardType: TextInputType.number,
                  controller: _pbController,
                  decoration: InputDecoration(labelText: "% PB"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.pb = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _ndtController,
                  decoration: InputDecoration(labelText: "% NDT"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.ndt = double.parse(text);
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
}

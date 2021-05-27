import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/nutricao_volumoso.dart';
import 'package:intl/intl.dart';

class CadastroNutricaoVolumosoCaprino extends StatefulWidget {
  final NutricaoVolumoso nutricaoVolumoso;
  CadastroNutricaoVolumosoCaprino({this.nutricaoVolumoso});
  @override
  _CadastroNutricaoVolumosoCaprinoState createState() =>
      _CadastroNutricaoVolumosoCaprinoState();
}

class _CadastroNutricaoVolumosoCaprinoState
    extends State<CadastroNutricaoVolumosoCaprino> {
  final _nameFocus = FocusNode();
  bool _nutricaoEdited = false;
  NutricaoVolumoso _editedNutricao;

  final _loteControlller = TextEditingController();
  final _tipoController = TextEditingController();
  final _quantIndController = TextEditingController();
  final _quantTotalController = TextEditingController();
  final _pbController = TextEditingController();
  final _ndtController = TextEditingController();
  final _msController = TextEditingController();
  final _umidController = TextEditingController();
  final _obsController = TextEditingController();
  final _baiaController = TextEditingController();

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
    if (widget.nutricaoVolumoso == null) {
      _editedNutricao = NutricaoVolumoso();
    } else {
      _editedNutricao =
          NutricaoVolumoso.fromMap(widget.nutricaoVolumoso.toMap());
      _quantIndController.text = _editedNutricao.quantidadeInd.toString();
      _quantTotalController.text = _editedNutricao.quantidadeTotal.toString();
      _tipoController.text = _editedNutricao.tipo;
      _msController.text = _editedNutricao.ms.toString();
      _umidController.text = _editedNutricao.umidade.toString();
      _pbController.text = _editedNutricao.pb.toString();
      _ndtController.text = _editedNutricao.ndt.toString();
      _obsController.text = _editedNutricao.observacao;
      _baiaController.text = _editedNutricao.baia;
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
            "Nutrição Volumosa",
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
                  controller: _loteControlller,
                  focusNode: _nameFocus,
                  decoration: InputDecoration(labelText: "Lote"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.tipo = text;
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
                  controller: _tipoController,
                  decoration: InputDecoration(labelText: "Tipo de volumoso"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.tipo = text;
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
                  controller: _msController,
                  decoration: InputDecoration(labelText: "% MS"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.ms = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _umidController,
                  decoration: InputDecoration(labelText: "% Umidade"),
                  onChanged: (text) {
                    _nutricaoEdited = true;
                    setState(() {
                      _editedNutricao.umidade = double.parse(text);
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

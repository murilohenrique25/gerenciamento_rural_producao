import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CadastrarMedicamento extends StatefulWidget {
  @override
  _CadastrarMedicamentoState createState() => _CadastrarMedicamentoState();
}

class _CadastrarMedicamentoState extends State<CadastrarMedicamento> {
  var controleDateVencimento = MaskedTextController(mask: '00/00/0000');
  var controleDataAbertura = MaskedTextController(mask: '00/00/0000');
  List<TipoMedicamento> _tipos = <TipoMedicamento>[
    const TipoMedicamento("Nenhum"),
    const TipoMedicamento("ml"),
    const TipoMedicamento("l"),
    const TipoMedicamento("ds"),
    const TipoMedicamento("h"),
    const TipoMedicamento("kg"),
    const TipoMedicamento("gr"),
    const TipoMedicamento("am"),
  ];

  final _nomeMedicamentoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  // final _tipoDosagemController = TextEditingController();
  final _carenciaMedicamento = TextEditingController();
  // final _dataVencimento = TextEditingController();
  final _fornecedor = TextEditingController();
  // final _dataAbertura = TextEditingController();
  final _principioAtivo = TextEditingController();
  final _observacao = TextEditingController();

  String selectedTipo;

  final _nameFocus = FocusNode();

  bool _loteEdited = false;

  @override
  void initState() {
    super.initState();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Cadastrar Medicamento"),
            centerTitle: true,
            actions: [],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.save),
            backgroundColor: Colors.green[700],
          ),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.add_circle,
                      size: 80.0,
                      color: Color.fromARGB(255, 4, 125, 141),
                    ),
                    TextField(
                      controller: _nomeMedicamentoController,
                      focusNode: _nameFocus,
                      decoration: InputDecoration(labelText: "Nome"),
                      onChanged: (text) {
                        _loteEdited = true;
                        setState(() {});
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _quantidadeController,
                            decoration:
                                InputDecoration(labelText: "Quantidade"),
                            onChanged: (text) {
                              _loteEdited = true;
                              setState(() {});
                            },
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(top: 25.0),
                              child: DropdownButton(
                                hint: Text("Tipo"),
                                value: selectedTipo,
                                onChanged: (value) {
                                  setState(() {
                                    selectedTipo = value;
                                  });
                                },
                                items: _tipos.map((value) {
                                  return DropdownMenuItem(
                                    value: value.name,
                                    child: Row(
                                      children: [
                                        Text(value.name),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            )),
                      ],
                    ),
                    TextField(
                      controller: _carenciaMedicamento,
                      decoration:
                          InputDecoration(labelText: "Carencia Medicamento"),
                      onChanged: (text) {
                        _loteEdited = true;
                        setState(() {});
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: controleDateVencimento,
                      decoration:
                          InputDecoration(labelText: "Data de Vencimento"),
                      onChanged: (text) {
                        _loteEdited = true;
                        setState(() {});
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _fornecedor,
                      decoration: InputDecoration(labelText: "Fornecedor"),
                      onChanged: (text) {
                        _loteEdited = true;
                        setState(() {});
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: controleDataAbertura,
                      decoration: InputDecoration(
                          labelText: "Data de Abertura do Medicamento"),
                      onChanged: (text) {
                        _loteEdited = true;
                        setState(() {});
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _principioAtivo,
                      decoration: InputDecoration(labelText: "Princípio Ativo"),
                      onChanged: (text) {
                        _loteEdited = true;
                        setState(() {});
                      },
                      keyboardType: TextInputType.text,
                    ),
                    TextField(
                      controller: _observacao,
                      decoration: InputDecoration(labelText: "Observação"),
                      onChanged: (text) {
                        _loteEdited = true;
                        setState(() {});
                      },
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<bool> _requestPop() {
    if (_loteEdited) {
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

class TipoMedicamento {
  const TipoMedicamento(this.name);
  final String name;
}

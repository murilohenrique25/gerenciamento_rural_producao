import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/models/medicamento.dart';

class CadastroMedicamentoEquino extends StatefulWidget {
  final Medicamento medicamento;
  CadastroMedicamentoEquino({this.medicamento});
  @override
  _CadastroMedicamentoEquinoState createState() =>
      _CadastroMedicamentoEquinoState();
}

class _CadastroMedicamentoEquinoState extends State<CadastroMedicamentoEquino> {
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
  var controleDateVencimento = MaskedTextController(mask: '00-00-0000');
  var controleDateCompra = MaskedTextController(mask: '00-00-0000');
  var controleDataAbertura = MaskedTextController(mask: '00-00-0000');

  final _nomeMedicamentoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _precoController = TextEditingController();
  final _carenciaMedicamento = TextEditingController();
  final _fornecedor = TextEditingController();
  final _principioAtivo = TextEditingController();
  final _observacao = TextEditingController();
  final _tempoDescarteLeite = TextEditingController();

  double precoTotal = 0.00;

  String selectedTipo;

  final _nameFocus = FocusNode();

  bool _medicamentoEdited = false;
  Medicamento _editedMedicamento;
  @override
  void initState() {
    super.initState();
    if (widget.medicamento == null) {
      _editedMedicamento = Medicamento();
    } else {
      _editedMedicamento = Medicamento.fromMap(widget.medicamento.toMap());
      controleDateVencimento.text = _editedMedicamento.dataVencimento;
      controleDateCompra.text = _editedMedicamento.dataCompra;
      controleDataAbertura.text = _editedMedicamento.dataAbertura;

      _nomeMedicamentoController.text = _editedMedicamento.nomeMedicamento;
      _quantidadeController.text = _editedMedicamento.quantidade.toString();
      _precoController.text = _editedMedicamento.precoUnitario.toString();
      _carenciaMedicamento.text = _editedMedicamento.carenciaMedicamento;
      _fornecedor.text = _editedMedicamento.fornecedor;
      _principioAtivo.text = _editedMedicamento.principioAtivo;
      _observacao.text = _editedMedicamento.observacao;
      _tempoDescarteLeite.text = _editedMedicamento.tempoDescarteLeite;
      selectedTipo = _editedMedicamento.tipoDosagem;
      precoTotal = _editedMedicamento.precoTotal;
    }
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
                _editedMedicamento.nomeMedicamento ?? "Cadastrar Medicamento"),
            centerTitle: true,
            actions: [],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
                double quantidade = double.parse(_quantidadeController.text);
                double valorUnitario = double.parse(_precoController.text);
                if (quantidade > 0 && valorUnitario > 0.0) {
                  precoTotal = quantidade * valorUnitario;
                  _editedMedicamento.precoTotal = precoTotal;
                  Navigator.pop(context, _editedMedicamento);
                }
              });
            },
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
                        _medicamentoEdited = true;
                        setState(() {
                          _editedMedicamento.nomeMedicamento = text;
                        });
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
                              _medicamentoEdited = true;
                              setState(() {
                                _editedMedicamento.quantidade =
                                    double.parse(text);
                              });
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
                                    _editedMedicamento.tipoDosagem = value;
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
                      controller: _precoController,
                      decoration: InputDecoration(labelText: "Preço Unitário"),
                      onChanged: (text) {
                        _medicamentoEdited = true;
                        setState(() {
                          setState(() {
                            _editedMedicamento.precoUnitario =
                                double.parse(text);
                          });
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _carenciaMedicamento,
                      decoration:
                          InputDecoration(labelText: "Carência Medicamento"),
                      onChanged: (text) {
                        _medicamentoEdited = true;
                        setState(() {
                          setState(() {
                            _editedMedicamento.carenciaMedicamento = text;
                          });
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: controleDateCompra,
                      decoration: InputDecoration(labelText: "Data de Compra"),
                      onChanged: (text) {
                        _medicamentoEdited = true;
                        setState(() {
                          setState(() {
                            _editedMedicamento.dataCompra = text;
                          });
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: controleDateVencimento,
                      decoration:
                          InputDecoration(labelText: "Data de Vencimento"),
                      onChanged: (text) {
                        _medicamentoEdited = true;
                        setState(() {
                          setState(() {
                            _editedMedicamento.dataVencimento = text;
                          });
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _fornecedor,
                      decoration: InputDecoration(labelText: "Fornecedor"),
                      onChanged: (text) {
                        _medicamentoEdited = true;
                        setState(() {
                          setState(() {
                            _editedMedicamento.fornecedor = text;
                          });
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: controleDataAbertura,
                      decoration: InputDecoration(
                          labelText: "Data de Abertura do Medicamento"),
                      onChanged: (text) {
                        _medicamentoEdited = true;
                        setState(() {
                          setState(() {
                            _editedMedicamento.dataAbertura = text;
                          });
                        });
                      },
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: _principioAtivo,
                      decoration: InputDecoration(labelText: "Princípio Ativo"),
                      onChanged: (text) {
                        _medicamentoEdited = true;
                        setState(() {
                          setState(() {
                            _editedMedicamento.principioAtivo = text;
                          });
                        });
                      },
                      keyboardType: TextInputType.text,
                    ),
                    TextField(
                      controller: _tempoDescarteLeite,
                      decoration: InputDecoration(
                          labelText: "Tempo de Descarte do Leite"),
                      onChanged: (text) {
                        _medicamentoEdited = true;
                        setState(() {
                          setState(() {
                            _editedMedicamento.tempoDescarteLeite = text;
                          });
                        });
                      },
                      keyboardType: TextInputType.text,
                    ),
                    TextField(
                      controller: _observacao,
                      decoration: InputDecoration(labelText: "Observação"),
                      onChanged: (text) {
                        _medicamentoEdited = true;
                        setState(() {
                          setState(() {
                            _editedMedicamento.observacao = text;
                          });
                        });
                      },
                      keyboardType: TextInputType.text,
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 35.0))
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  Future<bool> _requestPop() {
    if (_medicamentoEdited) {
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

class TipoMedicamento {
  const TipoMedicamento(this.name);
  final String name;
}

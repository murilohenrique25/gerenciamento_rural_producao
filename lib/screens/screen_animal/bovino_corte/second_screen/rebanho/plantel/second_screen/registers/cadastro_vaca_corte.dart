import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/lote_db.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/models/vaca_corte.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroVacaCorte extends StatefulWidget {
  final VacaCorte vaca;

  CadastroVacaCorte({this.vaca});
  @override
  _CadastroVacaCorteState createState() => _CadastroVacaCorteState();
}

class _CadastroVacaCorteState extends State<CadastroVacaCorte> {
  LoteDB helperLote = LoteDB();
  List<Lote> lotes = [];
  List<VacaCorte> vacas = [];
  final _nameFocus = FocusNode();
  Lote lote = Lote();
  bool _vacasEdited = false;
  List<String> diagnosticos = ["Vazia", "Prenha", "Aborto"];
  VacaCorte _editedVaca;

  var dataUltInsemiController = MaskedTextController(mask: '00-00-0000');
  var dataPrePartoController = MaskedTextController(mask: '00-00-0000');
  var dataPrevSecageController = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _origemController = TextEditingController();
  final _pesoController = TextEditingController();
  final _quantidadeDiasController = TextEditingController();
  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  var _dataAcontecidoController = MaskedTextController(mask: '00-00-0000');
  var _dataDiagnosticoController = MaskedTextController(mask: '00-00-0000');

  final df = new DateFormat("dd-MM-yyyy");

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  int _radioValue = 0;
  int groupValueTipo = 0;
  String numeroData;
  String idadeFinal = "";
  String _idadeAnimal = "";
  String nomeD = "";
  String diagnostico;
  String dataInseminacao = "Não inseminada";
  String dataSecagem = "Não inseminada";
  String dataParto = "Não inseminada";
  String loteSelecionado;

  void _reset() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getAllLotes();
    if (widget.vaca == null) {
      _editedVaca = VacaCorte();
      _editedVaca.diagnosticoGestacao = "Vazia";
      _editedVaca.situacao = "Viva";
    } else {
      _editedVaca = VacaCorte.fromMap(widget.vaca.toMap());
      _nomeController.text = _editedVaca.nome;
      _racaController.text = _editedVaca.raca;
      _paiController.text = _editedVaca.pai;
      _maeController.text = _editedVaca.mae;
      _pesoController.text = _editedVaca.peso.toString();
      numeroData = _editedVaca.dataNascimento;
      _dataNasc.text = numeroData;
      if (_editedVaca.situacao == "Viva") {
        _radioValue = 0;
      } else if (_editedVaca.situacao == "Morta") {
        _radioValue = 1;
      } else {
        _radioValue = 2;
      }
      if (_editedVaca.tipoDiagnosticoGestacao == "IATF") {
        groupValueTipo = 0;
      } else if (_editedVaca.tipoDiagnosticoGestacao == "Monta Natural") {
        groupValueTipo = 1;
      } else {
        groupValueTipo = 2;
      }
      if (_editedVaca?.ultimaInseminacao?.isNotEmpty ?? false) {
        dataInseminacao = _editedVaca.ultimaInseminacao;
      }
      if (_editedVaca?.partoPrevisto?.isNotEmpty ?? false) {
        dataParto = _editedVaca.partoPrevisto;
      }
      if (_editedVaca?.secagemPrevista?.isNotEmpty ?? false) {
        dataSecagem = _editedVaca.secagemPrevista;
      }
      dataUltInsemiController.text = _editedVaca.ultimaInseminacao;
      dataPrePartoController.text = _editedVaca.partoPrevisto;
      dataPrevSecageController.text = _editedVaca.secagemPrevista;
      idadeFinal = differenceDate();
    }
  }

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
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.pai = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.mae = text;
                    });
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

  Future<void> _showMortoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Causa Morte'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _descricaoController,
                  decoration: InputDecoration(labelText: "Causa"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.dataAcontecido = text;
                    });
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

  Future<void> _showAbatidoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Abatido'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.dataAcontecido = text;
                    });
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        key: _scaffoldstate,
        appBar: AppBar(
          title: Text(
            _editedVaca.nome ?? "Cadastrar Vaca",
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
            if (_nomeController.text.isEmpty) {
              Toast.show("Nome inválido.", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else if (_dataNasc.text.isEmpty) {
              Toast.show("Data nascimento inválida.", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else {
              Navigator.pop(context, _editedVaca);
            }
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
                  controller: _nomeController,
                  focusNode: _nameFocus,
                  decoration: InputDecoration(labelText: "Nome / Nº Brinco"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.nome = text;
                    });
                  },
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      numeroData = _dataNasc.text;
                      _editedVaca.dataNascimento = _dataNasc.text;
                      idadeFinal = differenceDate();
                    });
                  },
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text("Idade do animal:  $idadeFinal",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 20.0,
                ),
                SearchableDropdown.single(
                  items: lotes.map((lote) {
                    return DropdownMenuItem(
                      value: lote,
                      child: Row(
                        children: [
                          Text(lote.nome),
                        ],
                      ),
                    );
                  }).toList(),
                  value: lote,
                  hint: "Selecione um Lote",
                  searchHint: "Selecione um Lote",
                  onChanged: (value) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.idLote = value.id;
                      _editedVaca.nomeLote = value.nome;
                      lote = value;
                      loteSelecionado = lote.nome;
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
                  height: 15.0,
                ),
                Text("Lote:  $loteSelecionado",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 20.0,
                ),
                SearchableDropdown.single(
                  items: diagnosticos.map((diagnostico) {
                    return DropdownMenuItem(
                      value: diagnostico,
                      child: Row(
                        children: [
                          Text(diagnostico),
                        ],
                      ),
                    );
                  }).toList(),
                  value: diagnostico,
                  hint: "Selecione um diagnostico",
                  searchHint: "Selecione um diagnostico",
                  onChanged: (value) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.diagnosticoGestacao = value;
                      nomeD = value;
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
                Text("Lote:  $nomeD",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  enabled: nomeD.isNotEmpty,
                  keyboardType: TextInputType.text,
                  controller: _dataDiagnosticoController,
                  decoration: InputDecoration(
                      labelText: "Data Diagnóstico de Gestação"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.dataDiagnosticoGestacao = text;
                    });
                  },
                ),
                if (nomeD == "Inseminada")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 0,
                        groupValue: groupValueTipo,
                        onChanged: (int value) {
                          groupValueTipo = value;
                          _editedVaca.tipoDiagnosticoGestacao = "IATF";
                        },
                      ),
                      Text("IATF"),
                      Radio(
                        value: 1,
                        groupValue: groupValueTipo,
                        onChanged: (int value) {
                          groupValueTipo = value;
                          _editedVaca.tipoDiagnosticoGestacao = "Monta Natural";
                        },
                      ),
                      Text("Monta Natural"),
                      Radio(
                        value: 2,
                        groupValue: groupValueTipo,
                        onChanged: (int value) {
                          groupValueTipo = value;
                          _editedVaca.tipoDiagnosticoGestacao = "IA";
                        },
                      ),
                      Text("IA"),
                    ],
                  ),
                if (nomeD == "Gestante")
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _quantidadeDiasController,
                    decoration: InputDecoration(labelText: "Raça"),
                    onChanged: (text) {
                      _vacasEdited = true;
                      setState(() {
                        _editedVaca.diasPrenha = int.parse(text);
                      });
                    },
                  ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _origemController,
                  decoration: InputDecoration(labelText: "Origem"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.origem = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.peso = double.parse(text);
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Text(
                    "Última inseminação: " + dataInseminacao,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Text(
                    "Secagem prevista: " + dataSecagem,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Text(
                    "Parto previsto: " + dataParto,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141)),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: Text("Pedigree"),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 0,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedVaca.situacao = "Viva";
                          });
                        }),
                    Text("Viva"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedVaca.situacao = "Morta";
                            if (_editedVaca.situacao == "Morta")
                              _showMortoDialog();
                          });
                        }),
                    Text("Morta"),
                    Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedVaca.situacao = "Abate";
                            if (_editedVaca.situacao == "Abate")
                              _showAbatidoDialog();
                          });
                        }),
                    Text("Abate"),
                  ],
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

  Future<bool> _requestPop() {
    if (_vacasEdited) {
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

  String differenceDate() {
    String num = "";
    DateTime dt = DateTime.now();
    if (numeroData.isNotEmpty) {
      num = numeroData.split('-').reversed.join();
    }

    DateTime date = DateTime.parse(num);
    int quant = dt.difference(date).inDays;
    if (quant < 0) {
      _idadeAnimal = "Data incorreta";
    } else if (quant < 365) {
      _idadeAnimal = "$quant dias";
    } else if (quant == 365) {
      _idadeAnimal = "1 ano";
    } else if (quant > 365 && quant < 731) {
      int dias = quant - 365;
      _idadeAnimal = "1 ano e $dias dias";
    } else if (quant > 731 && quant < 1096) {
      int dias = quant - 731;
      _idadeAnimal = "2 ano e $dias dias";
    } else if (quant > 1095 && quant < 1461) {
      int dias = quant - 1095;
      _idadeAnimal = "3 ano e $dias dias";
    } else if (quant > 1460 && quant < 1826) {
      int dias = quant - 1460;
      _idadeAnimal = "4 ano e $dias dias";
    } else if (quant > 1825 && quant < 2191) {
      int dias = quant - 1825;
      _idadeAnimal = "5 ano e $dias dias";
    } else if (quant > 2190 && quant < 2.556) {
      int dias = quant - 2190;
      _idadeAnimal = "6 ano e $dias dias";
    }
    return _idadeAnimal;
  }

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

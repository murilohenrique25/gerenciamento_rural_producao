import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/lote_db.dart';
import 'package:gerenciamento_rural/helpers/vaca_db.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/models/vaca.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class CadastroVaca extends StatefulWidget {
  final Vaca vaca;

  CadastroVaca({this.vaca});
  @override
  _CadastroVacaState createState() => _CadastroVacaState();
}

class _CadastroVacaState extends State<CadastroVaca> {
  LoteDB helperLote = LoteDB();
  List<Lote> lotes = List();

  VacaDB helper = VacaDB();
  List<Vaca> vacas = List();
  final _nameFocus = FocusNode();
  Lote lote = Lote();
  bool _vacasEdited = false;

  Vaca _editedVaca;

  String numeroData;
  String dataSecagem;
  String dataParto;
  String idadeFinal = "";
  String _idadeAnimal = "1 ano";

  int selectedLotes;

  void _reset() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getAllLotes();
    if (widget.vaca == null) {
      _editedVaca = Vaca();
    } else {
      _editedVaca = Vaca.fromMap(widget.vaca.toMap());
      _nomeController.text = _editedVaca.nome;
      _racaController.text = _editedVaca.raca;
      _paiController.text = _editedVaca.pai;
      _maeController.text = _editedVaca.mae;
      _avoMMaternoController.text = _editedVaca.avoMMaterno;
      _avoFMaternoController.text = _editedVaca.avoFMaterno;
      _avoFPaternoController.text = _editedVaca.avoFPaterno;
      _avoMPaternoController.text = _editedVaca.avoMPaterno;
      numeroData = _editedVaca.dataNascimento;
      dataParto = _editedVaca.partoPrevisto;
      dataSecagem = _editedVaca.secagemPrevista;
      dataUltInsemiController.text = _editedVaca.ultimaInseminacao;
      dataPrePartoController.text = _editedVaca.partoPrevisto;
      dataPrevSecageController.text = _editedVaca.secagemPrevista;
      idadeFinal = differenceDate();
    }
  }

  var dataUltInsemiController = MaskedTextController(mask: '00-00-0000');
  var dataPrePartoController = MaskedTextController(mask: '00-00-0000');
  var dataPrevSecageController = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _avoMMaternoController = TextEditingController();
  final _avoFMaternoController = TextEditingController();
  final _avoFPaternoController = TextEditingController();
  final _avoMPaternoController = TextEditingController();
  var _dataNasc = MaskedTextController(mask: '00-00-0000');

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
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoFPaternoController,
                  decoration: InputDecoration(labelText: "Avó Paterno"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.avoFPaterno = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoMPaternoController,
                  decoration: InputDecoration(labelText: "Avô Paterno"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.avoMPaterno = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoFMaternoController,
                  decoration: InputDecoration(labelText: "Avó Materno"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.avoFMaterno = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _avoMMaternoController,
                  decoration: InputDecoration(labelText: "Avô Materno"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.avoMMaterno = text;
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

  final df = new DateFormat("dd-MM-yyyy");

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();

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
            Navigator.pop(context, _editedVaca);
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
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      numeroData = text;
                      _editedVaca.dataNascimento = text;
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
                      value: lote.id,
                      child: Row(
                        children: [
                          Text(lote.name),
                        ],
                      ),
                    );
                  }).toList(),
                  value: selectedLotes,
                  hint: "Selecione um Lote",
                  searchHint: "Selecione um Lote",
                  onChanged: (value) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.idLote = value;
                      selectedLotes = value;
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
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.raca = text;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Text(
                    "Última inseminação: Não inseminada",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
                  child: Text(
                    "Secagem prevista: Não inseminada",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Text(
                    "Parto previsto: Não inseminada",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141)),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: Text("Pedigree"),
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

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/caprino_abatido_db.dart';
import 'package:gerenciamento_rural/helpers/lote_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/reprodutor_db.dart';
import 'package:gerenciamento_rural/models/caprino_abatido.dart';
import 'package:gerenciamento_rural/models/jovem_macho_caprino.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/models/reprodutor.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroJovemMacho extends StatefulWidget {
  final JovemMachoCaprino jovemMachoCaprino;
  CadastroJovemMacho({this.jovemMachoCaprino});
  @override
  _CadastroJovemMachoState createState() => _CadastroJovemMachoState();
}

class _CadastroJovemMachoState extends State<CadastroJovemMacho> {
  LoteCaprinoDB loteCaprinoDB = LoteCaprinoDB();
  Lote lote;
  List<Lote> lotes = [];
  String idadeFinal = "";
  String numeroData = "";
  String nomePai = "";
  String nomeMae = "";
  String nomeLote = "";
  int _radioValue = 0;
  int _radioValueSetor = 0;
  String estado;
  final _nomeController = TextEditingController();
  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  var _dataAcontecidoController = MaskedTextController(mask: '00-00-0000');
  var _dataDesmamaController = MaskedTextController(mask: '00-00-0000');
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _baiaController = TextEditingController();
  final _pesoAtualController = TextEditingController();
  final _loteController = TextEditingController();
  final _origemController = TextEditingController();
  final _obsController = TextEditingController();
  final _pesoDesmamaController = TextEditingController();
  final _pesoNascimentoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorVendidoController = TextEditingController();
  final _pesoVendidoController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final df = new DateFormat("dd-MM-yyyy");

  String _idadeAnimal = "1ano e 2meses";
  JovemMachoCaprino _editedJM;
  bool _jmEdited = false;
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
    if (widget.jovemMachoCaprino == null) {
      _editedJM = JovemMachoCaprino();
      _editedJM.situacao = "Vivo";
      _radioValue = 0;
      _editedJM.setor = "Caprino";
      _radioValueSetor = 0;
      _editedJM.virouAdulto = 0;
    } else {
      _editedJM = JovemMachoCaprino.fromMap(widget.jovemMachoCaprino.toMap());
      _nomeController.text = _editedJM.nomeAnimal;
      if (_editedJM.situacao == "Vivo") {
        _radioValue = 0;
      } else if (_editedJM.situacao == "Morto") {
        _radioValue = 1;
      } else if (_editedJM.situacao == "Abatido") {
        _radioValue = 2;
      } else {
        _radioValue = 3;
      }

      if (_editedJM.setor == "Caprino") {
        _radioValueSetor = 0;
      } else {
        _radioValueSetor = 1;
      }
      _racaController.text = _editedJM.raca;
      _paiController.text = _editedJM.pai;
      _maeController.text = _editedJM.mae;
      _baiaController.text = _editedJM.baia;
      _loteController.text = _editedJM.lote;
      _pesoAtualController.text = _editedJM.peso.toString();
      _origemController.text = _editedJM.origem;
      _obsController.text = _editedJM.observacao;
      _descricaoController.text = _editedJM.descricao;
      _dataAcontecidoController.text = _editedJM.dataAcontecido;
      _valorVendidoController.text = _editedJM.valorVendido.toString();
      numeroData = _editedJM.dataNascimento;
      _dataNasc.text = numeroData;
      idadeFinal = differenceDate();
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Genealogia'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _paiController,
                  decoration: InputDecoration(labelText: "Pai"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.pai = text;
                      nomePai = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.mae = text;
                      nomeMae = text;
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

  Future<void> _showLBDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Virar Reprodutor'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
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
                  hint: "Selecione um lote",
                  searchHint: "Selecione um lote",
                  onChanged: (value) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.idLote = value.id;
                      nomeLote = value.nome;
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
                  keyboardType: TextInputType.text,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.baia = text;
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
                    _jmEdited = true;
                    setState(() {
                      _editedJM.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.dataAcontecido = text;
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

  Future<void> _showVendidoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vendido'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _paiController,
                  decoration: InputDecoration(labelText: "Comprador"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.dataAcontecido = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _valorVendidoController,
                  decoration: InputDecoration(labelText: "Preço"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.valorVendido = double.parse(text);
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

  Future<void> _showDoadoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Doado'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _descricaoController,
                  decoration: InputDecoration(labelText: "Recebedor"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.dataAcontecido = text;
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
                    _jmEdited = true;
                    setState(() {
                      _editedJM.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoVendidoController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.pesoFinal = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _valorVendidoController,
                  decoration: InputDecoration(labelText: "Preço"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.valorVendido = double.parse(text);
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
            "Cadastrar Jovem Macho",
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
              if (_editedJM.situacao == "Abatido") {
                CaprinoAbatido caprinoAbatido = CaprinoAbatido();
                CaprinoAbatidoDB caprinoAbatidoDB = CaprinoAbatidoDB();
                caprinoAbatido.idLote = _editedJM.idLote;
                caprinoAbatido.nome = _editedJM.nomeAnimal;
                caprinoAbatido.peso = _editedJM.pesoFinal;
                caprinoAbatido.data = _editedJM.dataAcontecido;
                caprinoAbatido.tipo = "Macho Jovem";
                caprinoAbatidoDB.insert(caprinoAbatido);
              }
              if (_editedJM.situacao == "Reprodutor") {
                ReprodutorDB repDB = ReprodutorDB();
                Reprodutor rep = Reprodutor.fromMap(_editedJM.toMap());
                repDB.insert(rep);
                _editedJM.virouAdulto = 1;
              }
              Navigator.pop(context, _editedJM);
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 0,
                        groupValue: _radioValueSetor,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueSetor = value;
                            _editedJM.setor = "Caprino";
                          });
                        }),
                    Text("Caprino"),
                    Radio(
                        value: 1,
                        groupValue: _radioValueSetor,
                        onChanged: (int value) {
                          setState(() {
                            _radioValueSetor = value;
                            _editedJM.setor = "Ovino";
                          });
                        }),
                    Text("Ovino"),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: _nomeController,
                  decoration: InputDecoration(labelText: "Nome ou Nº Brinco"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.nomeAnimal = text;
                    });
                  },
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
                  hint: "Selecione um lote",
                  searchHint: "Selecione um lote",
                  onChanged: (value) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.idLote = value.id;
                      _editedJM.lote = value.nome;
                      nomeLote = value.nome;
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
                Text("Lote:  $nomeLote",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 5.0,
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.dataNascimento = text;
                      numeroData = _dataNasc.text;
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
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _origemController,
                  decoration: InputDecoration(labelText: "Origem"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.origem = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.baia = text;
                    });
                  },
                ),
                TextField(
                  controller: _dataDesmamaController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data da desmama"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.dataDesmama = text;
                    });
                  },
                ),
                TextField(
                  controller: _pesoNascimentoController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Peso ao Nascimento"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.pesoNascimento = text;
                    });
                  },
                ),
                TextField(
                  controller: _pesoAtualController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Peso Atual"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.peso = double.parse(text);
                    });
                  },
                ),
                TextField(
                  controller: _pesoDesmamaController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Peso na desmama"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.pesoDesmama = text;
                    });
                  },
                ),
                TextField(
                  controller: _obsController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _jmEdited = true;
                    setState(() {
                      _editedJM.observacao = text;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _showMyDialog();
                  },
                  child: Text("Genealogia"),
                ),
                Text("Pai:  $nomePai",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                Text("Mãe:  $nomeMae",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
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
                            _editedJM.situacao = "Vivo";
                          });
                        }),
                    Text("Vivo"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedJM.situacao = "Morto";
                            if (_editedJM.situacao == "Morto")
                              _showMortoDialog();
                          });
                        }),
                    Text("Morto"),
                    Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedJM.situacao = "Abatido";
                            if (_editedJM.situacao == "Abatido")
                              _showAbatidoDialog();
                          });
                        }),
                    Text("Abatido"),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 3,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedJM.situacao = "Reprodutor";
                            if (_editedJM.situacao == "Reprodutor")
                              _showLBDialog();
                          });
                        }),
                    Text("Reprodutor"),
                    Radio(
                        value: 4,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedJM.situacao = "Vendido";
                            if (_editedJM.situacao == "Vendido")
                              _showVendidoDialog();
                          });
                        }),
                    Text("Vendido"),
                    Radio(
                        value: 5,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedJM.situacao = "Doado";
                            if (_editedJM.situacao == "Doado")
                              _showDoadoDialog();
                          });
                        }),
                    Text("Doado"),
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

  void _getAllLotes() {
    loteCaprinoDB.getAllItems().then((value) {
      setState(() {
        lotes = value;
      });
    });
  }

  Future<bool> _requestPop() {
    if (_jmEdited) {
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
}

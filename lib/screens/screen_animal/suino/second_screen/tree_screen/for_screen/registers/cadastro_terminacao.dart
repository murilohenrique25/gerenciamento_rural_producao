import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/abatidos_db.dart';
import 'package:gerenciamento_rural/helpers/cachaco_db.dart';
import 'package:gerenciamento_rural/helpers/matriz_db.dart';
import 'package:gerenciamento_rural/helpers/terminacao_db.dart';
import 'package:gerenciamento_rural/models/abatidos.dart';
import 'package:gerenciamento_rural/models/cachaco.dart';
import 'package:gerenciamento_rural/models/matriz.dart';
import 'package:gerenciamento_rural/models/terminacao.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroTerminacao extends StatefulWidget {
  final Terminacao terminacao;
  CadastroTerminacao({this.terminacao});
  @override
  _CadastroTerminacaoState createState() => _CadastroTerminacaoState();
}

class _CadastroTerminacaoState extends State<CadastroTerminacao> {
  String idadeFinal = "";
  String numeroData = "";
  String nomeMatriz = "Vazio";
  String nomeCachaco = "Vazio";
  String nomeEstado = "Vazio";
  List<Matriz> matrizes = List();
  List<Cachaco> cachacos = List();
  MatrizDB matrizDB = MatrizDB();
  CachacoDB cachacoDB = CachacoDB();
  List<String> estado = ["Terminação", "Abatidos"];
  final _ninhadaController = TextEditingController();
  final _pesoController = TextEditingController();
  final _pesoDesmamaController = TextEditingController();
  final _racaController = TextEditingController();
  final _paiController = TextEditingController();
  final _maeController = TextEditingController();
  final _obsController = TextEditingController();
  final _identificacaoController = TextEditingController();
  final _sexoMachoController = TextEditingController();
  final _sexoFemeaController = TextEditingController();
  final _vivosController = TextEditingController();
  final _mortosController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _loteController = TextEditingController();
  final _baiaController = TextEditingController();
  final _pesoAbateController = TextEditingController();
  final _pesoMedioController = TextEditingController();
  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  var _dataAbate = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _dataDesmamaController = MaskedTextController(mask: '00-00-0000');

  final df = new DateFormat("dd-MM-yyyy");

  String _idadeAnimal = "1ano e 2meses";
  Terminacao _editedTerminacao;
  bool _termiancaoEdited = false;

  Cachaco cachaco = Cachaco();
  Matriz matriz = Matriz();
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
    if (widget.terminacao == null) {
      _editedTerminacao = Terminacao();
      _editedTerminacao.estado = estado[0];
      _estadoController.text = estado[0];
      _editedTerminacao.mudarPlantel = 0;
    } else {
      _editedTerminacao = Terminacao.fromMap(widget.terminacao.toMap());
      _ninhadaController.text = _editedTerminacao.nome;
      _pesoController.text = _editedTerminacao.pesoNascimento;
      _pesoDesmamaController.text = _editedTerminacao.pesoDesmama;
      _racaController.text = _editedTerminacao.raca;
      _paiController.text = _editedTerminacao.pai;
      _maeController.text = _editedTerminacao.mae;
      _obsController.text = _editedTerminacao.observacao;
      _identificacaoController.text = _editedTerminacao.identificacao;
      _sexoMachoController.text = _editedTerminacao.sexoM;
      _sexoFemeaController.text = _editedTerminacao.sexoF;
      _vivosController.text = _editedTerminacao.vivos;
      _mortosController.text = _editedTerminacao.mortos;
      _quantidadeController.text = _editedTerminacao.quantidade.toString();
      _estadoController.text = _editedTerminacao.estado;
      _loteController.text = _editedTerminacao.lote;
      _baiaController.text = _editedTerminacao.baia;
      matriz.nomeAnimal = _editedTerminacao.mae;
      cachaco.nomeAnimal = _editedTerminacao.pai;
      numeroData = _editedTerminacao.dataNascimento;
      _dataNasc.text = numeroData;
      idadeFinal = differenceDate();
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
            "Cadastrar Terminação",
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
            if (_ninhadaController.text.isEmpty) {
              Toast.show("Ninhada inválido.", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            }
            // else if (_dataNasc.text.isEmpty) {
            //   Toast.show("Data nascimento inválida.", context,
            //       duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            // }
            else {
              if (_editedTerminacao.estado == "Terminacao") {
                Navigator.pop(context, _editedTerminacao);
              } else if (_editedTerminacao.estado == "Abatidos") {
                TerminacaoDB terminacaoDB = TerminacaoDB();
                AbatidosDB abatidosDB = AbatidosDB();
                Abatido abatido;
                _editedTerminacao.mudarPlantel = 1;
                terminacaoDB.updateItem(_editedTerminacao);
                abatido = Abatido.fromMap(_editedTerminacao.toMap());
                abatidosDB.insert(abatido);
                Navigator.pushNamed(context, 'plantel');
              }
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
                  controller: _ninhadaController,
                  decoration: InputDecoration(labelText: "Ninhada"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.nome = text;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                SearchableDropdown.single(
                  items: matrizes.map((matriz) {
                    return DropdownMenuItem(
                      value: matriz,
                      child: Row(
                        children: [
                          Text(matriz.nomeAnimal),
                        ],
                      ),
                    );
                  }).toList(),
                  value: matriz,
                  hint: "Selecione uma matriz",
                  searchHint: "Selecione uma matriz",
                  onChanged: (value) {
                    _termiancaoEdited = true;
                    setState(() {
                      nomeMatriz = value.nomeAnimal;
                      _editedTerminacao.mae = value.nomeAnimal;
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
                  height: 10.0,
                ),
                Text("Matriz selecionada:  $nomeMatriz",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
                ),
                SearchableDropdown.single(
                  items: cachacos.map((cachaco) {
                    return DropdownMenuItem(
                      value: cachaco,
                      child: Row(
                        children: [
                          Text(cachaco.nomeAnimal),
                        ],
                      ),
                    );
                  }).toList(),
                  value: cachaco,
                  hint: "Selecione um cachaço",
                  searchHint: "Selecione um cachaço",
                  onChanged: (value) {
                    _termiancaoEdited = true;
                    setState(() {
                      nomeCachaco = value.nomeAnimal;
                      _editedTerminacao.pai = value.nomeAnimal;
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
                  height: 10.0,
                ),
                Text("Cachaço selecionado:  $nomeCachaco",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      numeroData = _dataNasc.text;
                      _editedTerminacao.dataNascimento = _dataNasc.text;
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
                TextField(
                  controller: _quantidadeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Quantidade"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.quantidade = int.parse(text);
                    });
                  },
                ),
                SearchableDropdown.single(
                  items: estado.map((estado) {
                    return DropdownMenuItem(
                      value: estado,
                      child: Row(
                        children: [
                          Text(estado),
                        ],
                      ),
                    );
                  }).toList(),
                  value: estado,
                  hint: "Selecione um Estado",
                  searchHint: "Selecione um Estado",
                  onChanged: (value) {
                    _termiancaoEdited = true;
                    setState(() {
                      nomeEstado = value;
                      _editedTerminacao.estado = value;
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
                  height: 10.0,
                ),
                Text("Estado selecionado:  $nomeEstado",
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 4, 125, 141))),
                SizedBox(
                  height: 10.0,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _identificacaoController,
                  decoration: InputDecoration(labelText: "Identificação"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.identificacao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _vivosController,
                  decoration: InputDecoration(labelText: "Vivos"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.vivos = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _mortosController,
                  decoration: InputDecoration(labelText: "Mortos"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.mortos = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _sexoMachoController,
                  decoration: InputDecoration(labelText: "Machos"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.sexoM = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _sexoFemeaController,
                  decoration: InputDecoration(labelText: "Fêmeas"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.sexoF = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.baia = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _loteController,
                  decoration: InputDecoration(labelText: "Lote"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.lote = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso ao nascimento"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.pesoNascimento = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoDesmamaController,
                  decoration: InputDecoration(labelText: "Peso na desmama"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.pesoDesmama = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataDesmamaController,
                  decoration: InputDecoration(labelText: "Data da desmama"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.dataDesmama = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _obsController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.observacao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAbate,
                  decoration: InputDecoration(labelText: "Data Abate"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.dataAbate = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoAbateController,
                  decoration: InputDecoration(labelText: "Peso Abate"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.pesoAbate = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoMedioController,
                  decoration: InputDecoration(labelText: "Peso Médio"),
                  onChanged: (text) {
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.pesoMedio = double.parse(text);
                    });
                  },
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
    if (_termiancaoEdited) {
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
    matrizDB.getAllItems().then((value) {
      setState(() {
        matrizes = value;
      });
    });
    cachacoDB.getAllItems().then((value) {
      setState(() {
        cachacos = value;
      });
    });
  }
}

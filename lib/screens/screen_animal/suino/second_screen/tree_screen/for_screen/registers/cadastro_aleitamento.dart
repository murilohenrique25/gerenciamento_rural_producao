import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/aleitamento_db.dart';
import 'package:gerenciamento_rural/helpers/cachaco_db.dart';
import 'package:gerenciamento_rural/helpers/creche_db.dart';
import 'package:gerenciamento_rural/helpers/historico_parto_suino_db.dart';
import 'package:gerenciamento_rural/helpers/matriz_db.dart';
import 'package:gerenciamento_rural/models/aleitamento.dart';
import 'package:gerenciamento_rural/models/cachaco.dart';
import 'package:gerenciamento_rural/models/creche.dart';
import 'package:gerenciamento_rural/models/historico_parto_suino.dart';
import 'package:gerenciamento_rural/models/matriz.dart';
import 'package:intl/intl.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:toast/toast.dart';

class CadastroAleitamento extends StatefulWidget {
  final Aleitamento aleitamento;
  CadastroAleitamento({this.aleitamento});
  @override
  _CadastroAleitamentoState createState() => _CadastroAleitamentoState();
}

class _CadastroAleitamentoState extends State<CadastroAleitamento> {
  String idadeFinal = "";
  String numeroData = "";
  String nomeMatriz = "";
  String nomeCachaco = "";
  String nomeEstado = "";
  List<Matriz> matrizes = [];
  List<Cachaco> cachacos = [];
  MatrizDB matrizDB = MatrizDB();
  CachacoDB cachacoDB = CachacoDB();
  List<String> estado = ["Aleitamento", "Creche"];
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
  var _dataNasc = MaskedTextController(mask: '00-00-0000');

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _dataDesmamaController = MaskedTextController(mask: '00-00-0000');

  final df = new DateFormat("dd-MM-yyyy");

  String _idadeAnimal = "1ano e 2meses";
  Aleitamento _editedAleitamento;
  bool _aleitamentoEdited = false;

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
    if (widget.aleitamento == null) {
      _editedAleitamento = Aleitamento();
      _editedAleitamento.estado = estado[0];
      _estadoController.text = estado[0];
      _editedAleitamento.mudarPlantel = 0;
    } else {
      _editedAleitamento = Aleitamento.fromMap(widget.aleitamento.toMap());
      _ninhadaController.text = _editedAleitamento.nome;
      _pesoController.text = _editedAleitamento.pesoNascimento;
      _pesoDesmamaController.text = _editedAleitamento.pesoDesmama;
      _racaController.text = _editedAleitamento.raca;
      _paiController.text = _editedAleitamento.pai;
      _maeController.text = _editedAleitamento.mae;
      _obsController.text = _editedAleitamento.observacao;
      _identificacaoController.text = _editedAleitamento.identificacao;
      _sexoMachoController.text = _editedAleitamento.sexoM;
      _sexoFemeaController.text = _editedAleitamento.sexoF;
      _vivosController.text = _editedAleitamento.vivos;
      _mortosController.text = _editedAleitamento.mortos;
      _quantidadeController.text = _editedAleitamento.quantidade.toString();
      _estadoController.text = _editedAleitamento.estado;
      _loteController.text = _editedAleitamento.lote;
      _baiaController.text = _editedAleitamento.baia;
      matriz.nomeAnimal = _editedAleitamento.mae;
      cachaco.nomeAnimal = _editedAleitamento.pai;
      numeroData = _editedAleitamento.dataNascimento;
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
            "Cadastrar Aleitamento",
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
            } else if (_dataNasc.text.isEmpty) {
              Toast.show("Data nascimento inválida.", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else if (_paiController.text.isEmpty) {
              Toast.show("Cachaço inválido.", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else if (_maeController.text.isEmpty) {
              Toast.show("Matriz inválida.", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else if (_quantidadeController.text.isEmpty) {
              Toast.show("Quantidade inválida.", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else if (_sexoMachoController.text.isEmpty) {
              Toast.show(
                  "Machos inválidos.\nSe não houver nenhum digite 0", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else if (_sexoFemeaController.text.isEmpty) {
              Toast.show(
                  "Fêmeas inválidas.\nSe não houver nenhuma digite 0", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else if (_vivosController.text.isEmpty) {
              Toast.show(
                  "Vivos inválidos.\nSe não houver nenhum digite 0", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else if (_mortosController.text.isEmpty) {
              Toast.show(
                  "Mortos inválidos.\nSe não houver nenhum digite 0", context,
                  duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            } else {
              if (_editedAleitamento.estado == "Aleitamento") {
                HistoricoPartoSuinoDB helper = HistoricoPartoSuinoDB();
                HistoricoPartoSuino historico = HistoricoPartoSuino();
                historico.nome = _editedAleitamento.nome;
                historico.mae = _editedAleitamento.mae;
                historico.pai = _editedAleitamento.pai;
                historico.dataNascimento = _editedAleitamento.dataNascimento;
                historico.quantidade = _editedAleitamento.quantidade;
                historico.vivos = _editedAleitamento.vivos;
                historico.mortos = _editedAleitamento.mortos;
                historico.sexoF = _editedAleitamento.sexoF;
                historico.sexoM = _editedAleitamento.sexoM;
                helper.insert(historico);
                if (matriz.numeroPartos == null) {
                  matriz.numeroPartos = 1;
                } else {
                  matriz.numeroPartos += 1;
                }
                matrizDB.updateItem(matriz);
                Navigator.pop(context, _editedAleitamento);
              } else if (_editedAleitamento.estado == "Creche") {
                AleitamentoDB aleitamentoDB = AleitamentoDB();
                CrecheDB crecheDB = CrecheDB();
                Creche creche;
                _editedAleitamento.mudarPlantel = 1;
                aleitamentoDB.updateItem(_editedAleitamento);
                creche = Creche.fromMap(_editedAleitamento.toMap());
                creche.mudarPlantel = 0;
                crecheDB.insert(creche);
                Navigator.pop(context, _editedAleitamento);
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
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.nome = text;
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
                    _aleitamentoEdited = true;
                    setState(() {
                      matriz = value;
                      _editedAleitamento.mae = value.nomeAnimal;
                      nomeMatriz = value.nomeAnimal;
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
                Text("Matriz Mãe:  $nomeMatriz",
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
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.pai = value.nomeAnimal;
                      nomeCachaco = value.nomeAnimal;
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
                Text("Cachaço Pai:  $nomeCachaco",
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
                    _aleitamentoEdited = true;
                    setState(() {
                      numeroData = _dataNasc.text;
                      _editedAleitamento.dataNascimento = _dataNasc.text;
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
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.quantidade = int.parse(text);
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
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.estado = value;
                      nomeEstado = value;
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
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.identificacao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _vivosController,
                  decoration: InputDecoration(labelText: "Vivos"),
                  onChanged: (text) {
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.vivos = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _mortosController,
                  decoration: InputDecoration(labelText: "Mortos"),
                  onChanged: (text) {
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.mortos = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _sexoMachoController,
                  decoration: InputDecoration(labelText: "Machos"),
                  onChanged: (text) {
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.sexoM = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _sexoFemeaController,
                  decoration: InputDecoration(labelText: "Fêmeas"),
                  onChanged: (text) {
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.sexoF = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.baia = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _loteController,
                  decoration: InputDecoration(labelText: "Lote"),
                  onChanged: (text) {
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.lote = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso ao nascimento"),
                  onChanged: (text) {
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.pesoNascimento = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoDesmamaController,
                  decoration: InputDecoration(labelText: "Peso na desmama"),
                  onChanged: (text) {
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.pesoDesmama = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataDesmamaController,
                  decoration: InputDecoration(labelText: "Data da desmama"),
                  onChanged: (text) {
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.dataDesmama = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _obsController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _aleitamentoEdited = true;
                    setState(() {
                      _editedAleitamento.observacao = text;
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
    if (_aleitamentoEdited) {
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

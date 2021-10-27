import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/cachaco_db.dart';
import 'package:gerenciamento_rural/helpers/creche_db.dart';
import 'package:gerenciamento_rural/helpers/matriz_db.dart';
import 'package:gerenciamento_rural/helpers/terminacao_db.dart';
import 'package:gerenciamento_rural/models/cachaco.dart';
import 'package:gerenciamento_rural/models/creche.dart';
import 'package:gerenciamento_rural/models/matriz.dart';
import 'package:gerenciamento_rural/models/terminacao.dart';
import 'package:intl/intl.dart';

import 'package:toast/toast.dart';

class CadastroCreche extends StatefulWidget {
  final Creche creche;
  CadastroCreche({this.creche});
  @override
  _CadastroCrecheState createState() => _CadastroCrecheState();
}

class _CadastroCrecheState extends State<CadastroCreche> {
  String idadeFinal = "";
  String numeroData = "";
  String nomeMatriz = "";
  String nomeCachaco = "";
  String nomeEstado = "";
  List<Matriz> matrizes = [];
  List<Cachaco> cachacos = [];
  MatrizDB matrizDB = MatrizDB();
  CachacoDB cachacoDB = CachacoDB();
  List<String> estado = ["Creche", "Terminação"];
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

  Creche _editedCreche;
  bool _crecheEdited = false;

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
    if (widget.creche == null) {
      _editedCreche = Creche();
      _editedCreche.estado = estado[0];
      _estadoController.text = estado[0];
      _editedCreche.mudarPlantel = 0;
    } else {
      _editedCreche = Creche.fromMap(widget.creche.toMap());
      _ninhadaController.text = _editedCreche.nome;
      _pesoController.text = _editedCreche.pesoNascimento;
      _pesoDesmamaController.text = _editedCreche.pesoDesmama;
      _racaController.text = _editedCreche.raca;
      _paiController.text = _editedCreche.pai;
      _maeController.text = _editedCreche.mae;
      _obsController.text = _editedCreche.observacao;
      _identificacaoController.text = _editedCreche.identificacao;
      _sexoMachoController.text = _editedCreche.sexoM;
      _sexoFemeaController.text = _editedCreche.sexoF;
      _vivosController.text = _editedCreche.vivos;
      _mortosController.text = _editedCreche.mortos;
      _quantidadeController.text = _editedCreche.quantidade.toString();
      _estadoController.text = _editedCreche.estado;
      _loteController.text = _editedCreche.lote;
      _baiaController.text = _editedCreche.baia;
      nomeEstado = _editedCreche.estado;
      _dataDesmamaController.text = _editedCreche.dataDesmama;
      nomeMatriz = _editedCreche.mae;
      nomeCachaco = _editedCreche.pai;
      numeroData = _editedCreche.dataNascimento;
      _dataNasc.text = numeroData;
      idadeFinal = calculaIdadeAnimal(numeroData);
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
            "Cadastrar Creche",
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
              _editedCreche.mudarPlantel = 0;
              if (_editedCreche.estado == "Terminação") {
                CrecheDB crecheDB = CrecheDB();
                TerminacaoDB terminacaoDB = TerminacaoDB();
                Terminacao terminacao;
                _editedCreche.mudarPlantel = 1;
                crecheDB.updateItem(_editedCreche);
                terminacao = Terminacao.fromMap(_editedCreche.toMap());
                terminacaoDB.insert(terminacao);
              }
              Navigator.pop(context, _editedCreche);
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
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.nome = text;
                    });
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                CustomSearchableDropDown(
                  items: matrizes,
                  label: 'Selecione uma matriz',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: matrizes?.map((item) {
                        return item.nomeAnimal;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    _editedCreche.mae = value.nomeAnimal;
                    nomeMatriz = value.nomeAnimal;
                  },
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
                CustomSearchableDropDown(
                  items: cachacos,
                  label: 'Selecione um cachaço',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: cachacos?.map((item) {
                        return item.nomeAnimal;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    _editedCreche.pai = value.nomeAnimal;
                    nomeCachaco = value.nomeAnimal;
                  },
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
                    _crecheEdited = true;
                    setState(() {
                      numeroData = _dataNasc.text;
                      _editedCreche.dataNascimento = _dataNasc.text;
                      idadeFinal = calculaIdadeAnimal(numeroData);
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
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.quantidade = int.parse(text);
                    });
                  },
                ),
                CustomSearchableDropDown(
                  items: estado,
                  label: 'Selecione um estado',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: estado?.map((item) {
                        return item;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    _editedCreche.estado = value;
                    nomeEstado = value;
                  },
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
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.identificacao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _vivosController,
                  decoration: InputDecoration(labelText: "Vivos"),
                  onChanged: (text) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.vivos = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _mortosController,
                  decoration: InputDecoration(labelText: "Mortos"),
                  onChanged: (text) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.mortos = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _sexoMachoController,
                  decoration: InputDecoration(labelText: "Machos"),
                  onChanged: (text) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.sexoM = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _sexoFemeaController,
                  decoration: InputDecoration(labelText: "Fêmeas"),
                  onChanged: (text) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.sexoF = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _baiaController,
                  decoration: InputDecoration(labelText: "Baia"),
                  onChanged: (text) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.baia = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _loteController,
                  decoration: InputDecoration(labelText: "Lote"),
                  onChanged: (text) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.lote = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso ao nascimento"),
                  onChanged: (text) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.pesoNascimento = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  controller: _pesoDesmamaController,
                  decoration: InputDecoration(labelText: "Peso na desmama"),
                  onChanged: (text) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.pesoDesmama = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataDesmamaController,
                  decoration: InputDecoration(labelText: "Data da desmama"),
                  onChanged: (text) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.dataDesmama = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _obsController,
                  decoration: InputDecoration(labelText: "Observação"),
                  onChanged: (text) {
                    _crecheEdited = true;
                    setState(() {
                      _editedCreche.observacao = text;
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
    if (_crecheEdited) {
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

  String calculaIdadeAnimal(String dateString) {
    String dataFinal = "";
    if (dateString.length == 10) {
      DateTime data = DateTime.parse(dateString.split('-').reversed.join());
      //data = dateString as DateTime;
      DateTime dataAgora = DateTime.now();
      int ano = (dataAgora.year - data.year);
      int mes = (dataAgora.month - data.month);
      int dia = (dataAgora.day - data.day);
      if (dia < 0) {
        dia = dia + 30;
        mes = mes - 1;
      }
      if (mes < 0) {
        mes = mes + 12;
        ano = ano - 1;
      }
      dataFinal = ano.toString() +
          " anos " +
          mes.toString() +
          " meses " +
          dia.toString() +
          " dias";
    }
    return dataFinal;
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

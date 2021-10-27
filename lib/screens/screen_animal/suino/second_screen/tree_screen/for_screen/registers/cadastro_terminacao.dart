import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
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
  String nomeMatriz = "";
  String nomeCachaco = "";
  String nomeEstado = "";
  List<Matriz> matrizes = [];
  List<Cachaco> cachacos = [];
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
      nomeEstado = _editedTerminacao.estado;
      _loteController.text = _editedTerminacao.lote;
      _dataDesmamaController.text = _editedTerminacao.dataDesmama;
      _dataAbate.text = _editedTerminacao.dataAbate;
      _pesoAbateController.text = _editedTerminacao.pesoAbate.toString();
      _pesoMedioController.text = _editedTerminacao.pesoMedio.toString();
      _baiaController.text = _editedTerminacao.baia;
      nomeMatriz = _editedTerminacao.mae;
      nomeCachaco = _editedTerminacao.pai;
      numeroData = _editedTerminacao.dataNascimento;
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
              _editedTerminacao.mudarPlantel = 0;
              if (_editedTerminacao.estado == "Abatidos") {
                TerminacaoDB terminacaoDB = TerminacaoDB();
                AbatidosDB abatidosDB = AbatidosDB();
                Abatido abatido;
                _editedTerminacao.mudarPlantel = 1;
                terminacaoDB.updateItem(_editedTerminacao);
                abatido = Abatido.fromMap(_editedTerminacao.toMap());
                abatidosDB.insert(abatido);
              }
              Navigator.pop(context, _editedTerminacao);
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
                    nomeMatriz = value.nomeAnimal;
                    _editedTerminacao.mae = value.nomeAnimal;
                  },
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
                    if (value != null) {
                      nomeCachaco = value.nomeAnimal;
                      _editedTerminacao.pai = value.nomeAnimal;
                    }
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
                    _termiancaoEdited = true;
                    setState(() {
                      numeroData = _dataNasc.text;
                      _editedTerminacao.dataNascimento = _dataNasc.text;
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
                    _termiancaoEdited = true;
                    setState(() {
                      _editedTerminacao.quantidade = int.parse(text);
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
                    nomeEstado = value;
                    _editedTerminacao.estado = value;
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

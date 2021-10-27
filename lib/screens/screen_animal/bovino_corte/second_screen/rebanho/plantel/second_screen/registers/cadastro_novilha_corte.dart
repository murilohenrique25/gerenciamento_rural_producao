import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/corte_abatidos_db.dart';
import 'package:gerenciamento_rural/helpers/lote_bovino_corte_db.dart';
import 'package:gerenciamento_rural/helpers/novilha_corte_db.dart';
import 'package:gerenciamento_rural/helpers/vaca_corte_db.dart';
import 'package:gerenciamento_rural/models/corte_abatidos.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/models/novilha_corte.dart';
import 'package:gerenciamento_rural/models/vaca_corte.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class CadastroNovilhaCorte extends StatefulWidget {
  final NovilhaCorte novilha;

  CadastroNovilhaCorte({this.novilha});
  @override
  _CadastroNovilhaCorteState createState() => _CadastroNovilhaCorteState();
}

class _CadastroNovilhaCorteState extends State<CadastroNovilhaCorte> {
  LoteBovinoCorteDB helperLote = LoteBovinoCorteDB();
  List<Lote> lotes = [];
  List<NovilhaCorte> vacas = [];
  final _nameFocus = FocusNode();
  Lote lote = Lote();
  bool _novilhaEdited = false;
  List<String> diagnosticos = ["Gestante", "Vazia", "Aborto", "Inseminada"];
  NovilhaCorte _editedNovilha;

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
  final _pesoDesmamaController = TextEditingController();
  final _quantidadeDiasController = TextEditingController();
  final _pesoFinalController = TextEditingController();
  final _compradorController = TextEditingController();
  final _precoVivoController = TextEditingController();
  final _idadeDesmamaController = TextEditingController();
  final _pesoPrimeiraCoberturaController = TextEditingController();
  final _idadePrimeiraCoberturaController = TextEditingController();
  final _pesoPrimeiroPartoController = TextEditingController();
  final _idadePrimeiroPartoController = TextEditingController();
  final _cecController = TextEditingController();

  var _dataNasc = MaskedTextController(mask: '00-00-0000');
  var _dataAcontecidoController = MaskedTextController(mask: '00-00-0000');
  var _dataDiagnosticoController = MaskedTextController(mask: '00-00-0000');
  var _dataPartoController = MaskedTextController(mask: '00-00-0000');

  final df = new DateFormat("dd-MM-yyyy");

  final GlobalKey<ScaffoldState> _scaffoldstate =
      new GlobalKey<ScaffoldState>();
  int _radioValue = 0;
  int _radioValueParto = 0;
  int groupValueTipo = 0;
  String numeroData;
  String idadeFinal = "";
  String nomeD = "";
  String diagnostico = "";
  String dataInseminacao = "Não inseminada";
  String dataSecagem = "Não inseminada";
  String partoPrevisto = "Não inseminada";
  String loteSelecionado = "";

  void _reset() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _getAllLotes();
    if (widget.novilha == null) {
      _editedNovilha = NovilhaCorte();
      _editedNovilha.diagnosticoGestacao = "Vazia";
      _editedNovilha.situacao = "Viva";
      _editedNovilha..animalAbatido = 0;
      _editedNovilha.virouAdulto = 0;
    } else {
      _editedNovilha = NovilhaCorte.fromMap(widget.novilha.toMap());
      _nomeController.text = _editedNovilha.nome;
      _racaController.text = _editedNovilha.raca;
      _paiController.text = _editedNovilha.pai;
      _maeController.text = _editedNovilha.mae;
      _pesoDesmamaController.text = _editedNovilha.pesoDesmama.toString();
      _idadeDesmamaController.text = _editedNovilha.idadeDesmama;
      _pesoPrimeiraCoberturaController.text =
          _editedNovilha.pesoPrimeiraCobertura.toString();
      _idadePrimeiraCoberturaController.text =
          _editedNovilha.idadePrimeiraCobertura;
      _pesoPrimeiroPartoController.text =
          _editedNovilha.pesoPrimeiroParto.toString();
      _idadePrimeiroPartoController.text = _editedNovilha.idadePrimeiroParto;
      _pesoController.text = _editedNovilha.peso.toString();
      _origemController.text = _editedNovilha.origem;
      _dataPartoController.text = _editedNovilha.dataParto;
      _dataDiagnosticoController.text = _editedNovilha.dataDiagnosticoGestacao;
      loteSelecionado = _editedNovilha.nomeLote;
      _cecController.text = _editedNovilha.cec;
      numeroData = _editedNovilha.dataNascimento;
      nomeD = _editedNovilha.diagnosticoGestacao;
      _dataNasc.text = numeroData;
      if (_editedNovilha.situacao == "Viva") {
        _radioValue = 0;
      } else if (_editedNovilha.situacao == "Morta") {
        _radioValue = 1;
      } else {
        _radioValue = 2;
      }
      if (_editedNovilha.tipoDiagnosticoGestacao == "IATF") {
        groupValueTipo = 0;
      } else if (_editedNovilha.tipoDiagnosticoGestacao == "Monta Natural") {
        groupValueTipo = 1;
      } else {
        groupValueTipo = 2;
      }

      if (_editedNovilha?.ultimaInseminacao?.isNotEmpty ?? false) {
        dataInseminacao = _editedNovilha.ultimaInseminacao;
      }
      if (_editedNovilha?.partoPrevisto?.isNotEmpty ?? false) {
        partoPrevisto = _editedNovilha.partoPrevisto;
      }
      if (_editedNovilha?.secagemPrevista?.isNotEmpty ?? false) {
        dataSecagem = _editedNovilha.secagemPrevista;
      }
      if (_editedNovilha.tipoParto == "Parto Natural") {
        groupValueTipo = 0;
      } else {
        groupValueTipo = 1;
      }

      dataUltInsemiController.text = _editedNovilha.ultimaInseminacao;
      dataPrePartoController.text = _editedNovilha.partoPrevisto;
      dataPrevSecageController.text = _editedNovilha.secagemPrevista;
      idadeFinal = calculaIdadeAnimal(numeroData);
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
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.pai = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _maeController,
                  decoration: InputDecoration(labelText: "Mãe"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.mae = text;
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
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.descricao = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataAcontecidoController,
                  decoration: InputDecoration(labelText: "Data"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.dataAcontecido = text;
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
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.dataAcontecido = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoFinalController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.pesoFinal = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _compradorController,
                  decoration: InputDecoration(labelText: "Comprador"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.comprador = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _precoVivoController,
                  decoration: InputDecoration(labelText: "Preço Vivo/@"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.precoVivo = double.parse(text);
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
            _editedNovilha.nome ?? "Cadastrar Novilha",
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
              if (nomeD == "Aborto" || _editedNovilha.dataParto != null) {
                _editedNovilha.virouAdulto = 1;
                VacaCorte vacaCorte;
                VacaCorteDB helper = VacaCorteDB();
                NovilhaCorteDB novilhaCorteDB = NovilhaCorteDB();
                novilhaCorteDB.updateItem(_editedNovilha);
                vacaCorte = VacaCorte.fromMap(_editedNovilha.toMap());
                helper.insert(vacaCorte);
              }
              if (_editedNovilha.situacao == "Abate") {
                NovilhaCorteDB bezerraCorteDB = NovilhaCorteDB();
                CorteAbatidosDB corteAbatidosDB = CorteAbatidosDB();
                CortesAbatidos cortesAbatidos = CortesAbatidos();
                cortesAbatidos.categoria = "Novilha";
                cortesAbatidos.comprador = _editedNovilha.comprador;
                cortesAbatidos.data = _editedNovilha.dataAcontecido;
                cortesAbatidos.nomeAnimal = _editedNovilha.nome;
                cortesAbatidos.idade = idadeFinal;
                cortesAbatidos.pesoArroba = _editedNovilha.pesoFinal;
                cortesAbatidos.precoKgArroba = _editedNovilha.precoVivo;
                corteAbatidosDB.insert(cortesAbatidos);
                _editedNovilha.animalAbatido = 1;
                bezerraCorteDB.updateItem(_editedNovilha);
              }
              Navigator.pop(context, _editedNovilha);
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
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.nome = text;
                    });
                  },
                ),
                TextField(
                  controller: _dataNasc,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Data de Nascimento"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      numeroData = _dataNasc.text;
                      _editedNovilha.dataNascimento = _dataNasc.text;
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
                CustomSearchableDropDown(
                  items: lotes,
                  label: 'Selecione um lote',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: lotes?.map((item) {
                        return item.nome;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    if (value != null) {
                      _editedNovilha.idLote = value.id;
                      _editedNovilha.nomeLote = value.nome;
                      lote = value;
                      loteSelecionado = value.nome;
                    }
                  },
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
                CustomSearchableDropDown(
                  items: diagnosticos,
                  label: 'Selecione um diagnóstico',
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.blue)),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Icon(Icons.search),
                  ),
                  dropDownMenuItems: diagnosticos?.map((item) {
                        return item;
                      })?.toList() ??
                      [],
                  onChanged: (value) {
                    if (value != null) {
                      _editedNovilha.diagnosticoGestacao = value;
                      nomeD = value;
                    }
                  },
                ),
                Text("Diagnóstico:  $nomeD",
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
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.dataDiagnosticoGestacao = text;
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
                          _editedNovilha.tipoDiagnosticoGestacao = "IATF";
                        },
                      ),
                      Text("IATF"),
                      Radio(
                        value: 1,
                        groupValue: groupValueTipo,
                        onChanged: (int value) {
                          groupValueTipo = value;
                          _editedNovilha.tipoDiagnosticoGestacao =
                              "Monta Natural";
                        },
                      ),
                      Text("Monta Natural"),
                      Radio(
                        value: 2,
                        groupValue: groupValueTipo,
                        onChanged: (int value) {
                          groupValueTipo = value;
                          _editedNovilha.tipoDiagnosticoGestacao = "IA";
                        },
                      ),
                      Text("IA"),
                    ],
                  ),
                if (nomeD == "Gestante" || nomeD == "Aborto")
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _quantidadeDiasController,
                    decoration: InputDecoration(labelText: "Quantos dias?"),
                    onChanged: (text) {
                      _novilhaEdited = true;
                      setState(() {
                        _editedNovilha.diasPrenha = int.parse(text);
                      });
                    },
                  ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _racaController,
                  decoration: InputDecoration(labelText: "Raça"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.raca = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _cecController,
                  decoration: InputDecoration(
                      labelText: "Condição de Escore Corporal (CEC)"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.cec = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataPartoController,
                  decoration: InputDecoration(labelText: "Data Parto"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.dataParto = text;
                    });
                  },
                ),
                if (_editedNovilha.dataParto != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                          value: 0,
                          groupValue: _radioValueParto,
                          onChanged: (int value) {
                            setState(() {
                              _radioValueParto = value;
                              _editedNovilha.tipoParto = "Parto Normal";
                            });
                          }),
                      Text("Parto Normal"),
                      Radio(
                          value: 1,
                          groupValue: _radioValueParto,
                          onChanged: (int value) {
                            setState(() {
                              _radioValueParto = value;
                              _editedNovilha.tipoParto = "Parto Distócico";
                            });
                          }),
                      Text("Parto Distócico"),
                    ],
                  ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _origemController,
                  decoration: InputDecoration(labelText: "Origem"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.origem = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoDesmamaController,
                  decoration: InputDecoration(labelText: "Peso Desmama"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.pesoDesmama = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _idadeDesmamaController,
                  decoration: InputDecoration(labelText: "Idade Desmama"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.idadeDesmama = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoPrimeiraCoberturaController,
                  decoration:
                      InputDecoration(labelText: "Peso Primeira Cobertura"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.pesoPrimeiraCobertura = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _idadePrimeiraCoberturaController,
                  decoration:
                      InputDecoration(labelText: "Idade Primeira Cobertura"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.idadePrimeiraCobertura = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoPrimeiroPartoController,
                  decoration: InputDecoration(labelText: "Peso Primeiro Parto"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.pesoPrimeiroParto = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _idadePrimeiroPartoController,
                  decoration:
                      InputDecoration(labelText: "Idade Primeiro Parto"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.idadePrimeiroParto = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _novilhaEdited = true;
                    setState(() {
                      _editedNovilha.peso = double.parse(text);
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
                    "Parto previsto: " + partoPrevisto,
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
                            _editedNovilha.situacao = "Viva";
                          });
                        }),
                    Text("Viva"),
                    Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: (int value) {
                          setState(() {
                            _radioValue = value;
                            _editedNovilha.situacao = "Morta";
                            if (_editedNovilha.situacao == "Morta")
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
                            _editedNovilha.situacao = "Abate";
                            if (_editedNovilha.situacao == "Abate")
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
    if (_novilhaEdited) {
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

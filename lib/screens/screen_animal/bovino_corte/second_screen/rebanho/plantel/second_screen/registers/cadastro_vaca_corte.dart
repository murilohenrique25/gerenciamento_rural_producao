import 'package:custom_searchable_dropdown/custom_searchable_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/corte_abatidos_db.dart';
import 'package:gerenciamento_rural/helpers/lote_bovino_corte_db.dart';
import 'package:gerenciamento_rural/helpers/vaca_corte_db.dart';
import 'package:gerenciamento_rural/models/corte_abatidos.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/models/vaca_corte.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';

class CadastroVacaCorte extends StatefulWidget {
  final VacaCorte vaca;

  CadastroVacaCorte({this.vaca});
  @override
  _CadastroVacaCorteState createState() => _CadastroVacaCorteState();
}

class _CadastroVacaCorteState extends State<CadastroVacaCorte> {
  LoteBovinoCorteDB helperLote = LoteBovinoCorteDB();
  List<Lote> lotes = [];
  List<VacaCorte> vacas = [];
  final _nameFocus = FocusNode();
  Lote lote = Lote();
  bool _vacasEdited = false;
  List<String> diagnosticos = ["Gestante", "Vazia", "Aborto", "Inseminada"];
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
  final _pesoFinalController = TextEditingController();
  final _compradorController = TextEditingController();
  final _precoVivoController = TextEditingController();
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
    if (widget.vaca == null) {
      _editedVaca = VacaCorte();
      _editedVaca.diagnosticoGestacao = "Vazia";
      _editedVaca.situacao = "Viva";
      _editedVaca.animalAbatido = 0;
    } else {
      _editedVaca = VacaCorte.fromMap(widget.vaca.toMap());
      _nomeController.text = _editedVaca.nome;
      _racaController.text = _editedVaca.raca;
      _paiController.text = _editedVaca.pai;
      _maeController.text = _editedVaca.mae;
      _pesoController.text = _editedVaca.peso.toString();
      _origemController.text = _editedVaca.origem;
      _dataPartoController.text = _editedVaca.dataParto;
      _dataDiagnosticoController.text = _editedVaca.dataDiagnosticoGestacao;
      loteSelecionado = _editedVaca.nomeLote;
      _cecController.text = _editedVaca.cec;
      numeroData = _editedVaca.dataNascimento;
      nomeD = _editedVaca.diagnosticoGestacao;
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
        partoPrevisto = _editedVaca.partoPrevisto;
      }
      if (_editedVaca?.secagemPrevista?.isNotEmpty ?? false) {
        dataSecagem = _editedVaca.secagemPrevista;
      }
      if (_editedVaca.tipoParto == "Parto Natural") {
        groupValueTipo = 0;
      } else {
        groupValueTipo = 1;
      }

      dataUltInsemiController.text = _editedVaca.ultimaInseminacao;
      dataPrePartoController.text = _editedVaca.partoPrevisto;
      dataPrevSecageController.text = _editedVaca.secagemPrevista;
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
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _pesoFinalController,
                  decoration: InputDecoration(labelText: "Peso"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.pesoFinal = double.parse(text);
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _compradorController,
                  decoration: InputDecoration(labelText: "Comprador"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.comprador = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _precoVivoController,
                  decoration: InputDecoration(labelText: "Preço Vivo/@"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.precoVivo = double.parse(text);
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
              if (_editedVaca.situacao == "Abate") {
                VacaCorteDB bezerraCorteDB = VacaCorteDB();
                CorteAbatidosDB corteAbatidosDB = CorteAbatidosDB();
                CortesAbatidos cortesAbatidos = CortesAbatidos();
                cortesAbatidos.categoria = "Vaca";
                cortesAbatidos.comprador = _editedVaca.comprador;
                cortesAbatidos.data = _editedVaca.dataAcontecido;
                cortesAbatidos.nomeAnimal = _editedVaca.nome;
                cortesAbatidos.idade = idadeFinal;
                cortesAbatidos.pesoArroba = _editedVaca.pesoFinal;
                cortesAbatidos.precoKgArroba = _editedVaca.precoVivo;
                corteAbatidosDB.insert(cortesAbatidos);
                _editedVaca.animalAbatido = 1;
                bezerraCorteDB.updateItem(_editedVaca);
              }
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
                      _editedVaca.idLote = value.id;
                      _editedVaca.nomeLote = value.nome;
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
                    _editedVaca.diagnosticoGestacao = value;
                    nomeD = value;
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
                if (nomeD == "Gestante" || nomeD == "Aborto")
                  TextField(
                    keyboardType: TextInputType.text,
                    controller: _quantidadeDiasController,
                    decoration: InputDecoration(labelText: "Quantos dias?"),
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
                  controller: _cecController,
                  decoration: InputDecoration(
                      labelText: "Condição de Escore Corporal (CEC)"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.cec = text;
                    });
                  },
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _dataPartoController,
                  decoration: InputDecoration(labelText: "Data Parto"),
                  onChanged: (text) {
                    _vacasEdited = true;
                    setState(() {
                      _editedVaca.dataParto = text;
                    });
                  },
                ),
                if (_editedVaca.dataParto != null)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                          value: 0,
                          groupValue: _radioValueParto,
                          onChanged: (int value) {
                            setState(() {
                              _radioValueParto = value;
                              _editedVaca.tipoParto = "Parto Normal";
                            });
                          }),
                      Text("Parto Normal"),
                      Radio(
                          value: 1,
                          groupValue: _radioValueParto,
                          onChanged: (int value) {
                            setState(() {
                              _radioValueParto = value;
                              _editedVaca.tipoParto = "Parto Distócico";
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

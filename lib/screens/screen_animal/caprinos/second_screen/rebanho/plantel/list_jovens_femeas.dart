import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/jovem_femea_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/todos_caprinos_db.dart';
import 'package:gerenciamento_rural/models/jovem_femea_caprino.dart';
import 'package:gerenciamento_rural/models/todoscaprino.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPage.dart';
import 'package:gerenciamento_rural/screens/screen_animal/caprinos/second_screen/rebanho/plantel/registers/cadastro_jovens_femeas.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

import 'package:toast/toast.dart';

enum OrderOptions { orderaz, orderza }

class ListaJovensFemea extends StatefulWidget {
  @override
  _ListaJovensFemeaState createState() => _ListaJovensFemeaState();
}

class _ListaJovensFemeaState extends State<ListaJovensFemea> {
  TextEditingController editingController = TextEditingController();
  JovemFemeaCaprinoDB helper = JovemFemeaCaprinoDB();
  TodosCaprinosDB todosCaprinosDB = TodosCaprinosDB();
  List<JovemFemeaCaprino> items = [];
  List<JovemFemeaCaprino> jovensFemeas = [];
  List<JovemFemeaCaprino> tJovensFemeas = [];
  @override
  void initState() {
    super.initState();
    _getAllJovensFemeas();
    items = [];
    tJovensFemeas = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
          ),
          IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                _creatPdf(context);
              }),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showTotalJFPage();
              }),
        ],
        centerTitle: true,
        title: Text("Jovens Fêmeas"),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Buscar por nome",
                    hintText: "Buscar por nome",
                    prefix: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: jovensFemeas.length,
                    itemBuilder: (context, index) {
                      return _totalJFCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _totalJFCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Nome: " + jovensFemeas[index].nomeAnimal ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showTotalJFPage(jovemFemea: jovensFemeas[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          try {
                            helper.delete(jovensFemeas[index].id);
                          } catch (e) {
                            Toast.show("$Exception($e)", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }

                          setState(() {
                            jovensFemeas.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showTotalJFPage({JovemFemeaCaprino jovemFemea}) async {
    final recJF = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroJovemFemea(
            jovemFemeaCaprino: jovemFemea,
          ),
        ));
    if (recJF != null) {
      if (jovemFemea != null) {
        await helper.updateItem(recJF);
      } else {
        await helper.insert(recJF);
        TodosCaprino todosCaprino = TodosCaprino();
        todosCaprino.nome = recJF.nomeAnimal;
        await todosCaprinosDB.insert(todosCaprino);
      }
      _getAllJovensFemeas();
    }
  }

  void _getAllJovensFemeas() {
    items = [];
    helper.getAllItems().then((list) {
      setState(() {
        jovensFemeas = list;
        items.addAll(jovensFemeas);
      });
    });
  }

  _creatPdf(context) async {
    tJovensFemeas = jovensFemeas;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Setor',
                  'Nome',
                  'Data Nascimento',
                  'Raça',
                  'Baia',
                  'Situação',
                  'Origem',
                  'Pai',
                  'Mãe',
                  'Peso Nascimento',
                  'Peso Desmama',
                  'Data Desmama',
                  'Observação'
                ],
                ...jovensFemeas.map((item) => [
                      item.setor,
                      item.nomeAnimal,
                      item.dataNascimento,
                      item.raca,
                      item.baia,
                      item.situacao,
                      item.origem,
                      item.pai,
                      item.mae,
                      item.pesoNascimento.toString(),
                      item.pesoDesmama.toString(),
                      item.dataDesmama,
                      item.observacao
                    ])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdf.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pdf.save());
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLeite(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        jovensFemeas.sort((a, b) {
          return a.nomeAnimal
              .toLowerCase()
              .compareTo(b.nomeAnimal.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        jovensFemeas.sort((a, b) {
          return b.nomeAnimal
              .toLowerCase()
              .compareTo(a.nomeAnimal.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  //filtrar resultado com o texto passado
  void filterSearchResults(String query) {
    List<JovemFemeaCaprino> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<JovemFemeaCaprino> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nomeAnimal.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        jovensFemeas.clear();
        jovensFemeas.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        jovensFemeas.clear();
        jovensFemeas.addAll(items);
      });
    }
  }

  //retorna o cabeçalho do pdf
  pdfLib.Widget _buildHeade(pdfLib.Context context) {
    return pdfLib.Container(
        color: PdfColors.green,
        child: pdfLib.Padding(
            padding: pdfLib.EdgeInsets.all(5),
            child: pdfLib.Row(
                crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
                mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
                children: [
                  pdfLib.Column(
                    mainAxisAlignment: pdfLib.MainAxisAlignment.center,
                    crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                    children: [
                      pdfLib.Text('Instituto Federal Goiano',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white)),
                      pdfLib.Text(
                          'Rodovia Geraldo Silva Nascimento Km 2,5, Rod. Gustavo Capanema,\nUrutaí - GO, 75790-000',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('(64) 3465-1900',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('Jovens Fêmeas',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

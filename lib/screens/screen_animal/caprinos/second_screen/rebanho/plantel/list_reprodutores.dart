import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/reprodutor_db.dart';
import 'package:gerenciamento_rural/helpers/todos_caprinos_db.dart';
import 'package:gerenciamento_rural/models/reprodutor.dart';
import 'package:gerenciamento_rural/models/todoscaprino.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPage.dart';
import 'package:gerenciamento_rural/screens/screen_animal/caprinos/second_screen/rebanho/plantel/registers/cadastro_reprodutor.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

import 'package:toast/toast.dart';

enum OrderOptions { orderaz, orderza }

class ListaReprodutores extends StatefulWidget {
  @override
  _ListaReprodutoresState createState() => _ListaReprodutoresState();
}

class _ListaReprodutoresState extends State<ListaReprodutores> {
  TextEditingController editingController = TextEditingController();
  ReprodutorDB helper = ReprodutorDB();
  TodosCaprinosDB todosCaprinosDB = TodosCaprinosDB();
  List<Reprodutor> items = [];
  List<Reprodutor> reprodutores = [];
  List<Reprodutor> tReprodutores = [];
  @override
  void initState() {
    super.initState();
    _getAllAnimais();
    items = [];
    tReprodutores = [];
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
                _showTotalAnimalPage();
              }),
        ],
        centerTitle: true,
        title: Text("Reprodutores"),
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
                    labelText: "Buscar reprodutor",
                    hintText: "Buscar reprodutor",
                    prefix: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: reprodutores.length,
                    itemBuilder: (context, index) {
                      return _totalAnimalCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _totalAnimalCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Nome: " + reprodutores[index].nomeAnimal,
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
                          _showTotalAnimalPage(reprodutor: reprodutores[index]);
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
                            helper.delete(reprodutores[index].id);
                          } catch (e) {
                            Toast.show("$Exception($e)", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }

                          setState(() {
                            reprodutores.removeAt(index);
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

  void _showTotalAnimalPage({Reprodutor reprodutor}) async {
    final recReprodutor = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroReprodutor(
            reprodutor: reprodutor,
          ),
        ));
    if (recReprodutor != null) {
      // reprodutor.lote;
      if (reprodutor != null) {
        await helper.updateItem(recReprodutor);
      } else {
        await helper.insert(recReprodutor);
        TodosCaprino todosCaprino = TodosCaprino();
        todosCaprino.nome = recReprodutor.nomeAnimal;
        // todosCaprino.nome = recReprodutor.pesoFinal;
        await todosCaprinosDB.insert(todosCaprino);
      }
      _getAllAnimais();
    }
  }

  void _getAllAnimais() {
    items = [];
    helper.getAllItemsVivos().then((list) {
      setState(() {
        reprodutores = list;
        items.addAll(reprodutores);
      });
    });
  }

  _creatPdf(context) async {
    tReprodutores = reprodutores;
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
                  'Lote',
                  'Baia',
                  'Origem',
                  'Situação',
                  'Procedência',
                  'Pai',
                  'Mãe',
                  'Data Abatido',
                  'Peso Abatido',
                  'Idade 1º Parto',
                  'Observação'
                ],
                ...reprodutores.map((item) => [
                      item.setor,
                      item.nomeAnimal,
                      item.dataNascimento,
                      item.raca,
                      item.lote,
                      item.baia,
                      item.origem,
                      item.situacao,
                      item.procedencia,
                      item.pai,
                      item.mae,
                      item.dataAbatido,
                      item.pesoAbatido.toString(),
                      item.observacao,
                    ])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfAnimal.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pdf.save());
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLeite(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        reprodutores.sort((a, b) {
          return a.nomeAnimal
              .toLowerCase()
              .compareTo(b.nomeAnimal.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        reprodutores.sort((a, b) {
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
    List<Reprodutor> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<Reprodutor> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nomeAnimal.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        reprodutores.clear();
        reprodutores.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        reprodutores.clear();
        reprodutores.addAll(items);
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
                      pdfLib.Text('Reprodutor',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

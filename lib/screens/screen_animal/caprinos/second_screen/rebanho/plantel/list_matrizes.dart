import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/matriz_caprino_db.dart';
import 'package:gerenciamento_rural/helpers/todos_caprinos_db.dart';
import 'package:gerenciamento_rural/models/matriz_caprino.dart';
import 'package:gerenciamento_rural/models/todoscaprino.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPage.dart';
import 'package:gerenciamento_rural/screens/screen_animal/caprinos/second_screen/rebanho/plantel/registers/cadastro_matriz.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

import 'package:toast/toast.dart';

enum OrderOptions { orderaz, orderza }

class ListaMatrizesCaprino extends StatefulWidget {
  @override
  _ListaMatrizesCaprinoState createState() => _ListaMatrizesCaprinoState();
}

class _ListaMatrizesCaprinoState extends State<ListaMatrizesCaprino> {
  TextEditingController editingController = TextEditingController();
  MatrizCaprinoDB helper = MatrizCaprinoDB();
  TodosCaprinosDB todosCaprinosDB = TodosCaprinosDB();
  List<MatrizCaprino> items = [];
  List<MatrizCaprino> matrizes = [];
  List<MatrizCaprino> tMatrizes = [];
  @override
  void initState() {
    super.initState();
    _getAllMatrizes();
    items = [];
    tMatrizes = [];
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
                _showTotalMatrizesPage();
              }),
        ],
        centerTitle: true,
        title: Text("Matrizes"),
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
                    labelText: "Buscar matriz",
                    hintText: "Buscar matriz",
                    prefix: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: matrizes.length,
                    itemBuilder: (context, index) {
                      return _totalMatrizCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _totalMatrizCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Nome: " + matrizes[index].nomeAnimal ?? "",
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
                          _showTotalMatrizesPage(
                              matrizCaprino: matrizes[index]);
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
                            helper.delete(matrizes[index].id);
                          } catch (e) {
                            Toast.show("$Exception($e)", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }

                          setState(() {
                            matrizes.removeAt(index);
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

  void _showTotalMatrizesPage({MatrizCaprino matrizCaprino}) async {
    final recMatriz = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroMatrizCaprino(
            matrizCaprino: matrizCaprino,
          ),
        ));
    if (recMatriz != null) {
      if (matrizCaprino != null) {
        await helper.updateItem(recMatriz);
      } else {
        await helper.insert(recMatriz);
        TodosCaprino todosCaprino = TodosCaprino();
        todosCaprino.nome = recMatriz.nomeAnimal;
        todosCaprino.lote = recMatriz.lote;
        todosCaprino.tipo = "Matriz";
        await todosCaprinosDB.insert(todosCaprino);
      }
      _getAllMatrizes();
    }
  }

  void _getAllMatrizes() {
    items = [];
    helper.getAllItems().then((list) {
      setState(() {
        matrizes = list;
        items.addAll(matrizes);
      });
    });
  }

  _creatPdf(context) async {
    tMatrizes = matrizes;
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
                  'Diagnóstico de Gestação',
                  'Idade 1º Parto',
                  'Peso 1º Parto',
                  'Ultima Inseminação',
                  'Observação'
                ],
                ...matrizes.map((item) => [
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
                      item.diagnosticoGestacao,
                      item.idadePrimeiroParto,
                      item.pesoPrimeiroParto.toString(),
                      item.ultimaInseminacao,
                      item.observacao,
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
        matrizes.sort((a, b) {
          return a.nomeAnimal
              .toLowerCase()
              .compareTo(b.nomeAnimal.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        matrizes.sort((a, b) {
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
    List<MatrizCaprino> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<MatrizCaprino> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nomeAnimal.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        matrizes.clear();
        matrizes.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        matrizes.clear();
        matrizes.addAll(items);
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
                      pdfLib.Text('Control IF Goiano',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white)),
                      pdfLib.Text('control@institutofederal.com.br',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('(64) 3465-1900',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('Matriz',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

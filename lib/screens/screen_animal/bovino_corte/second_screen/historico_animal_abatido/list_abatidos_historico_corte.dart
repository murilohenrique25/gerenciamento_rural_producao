import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/corte_abatidos_db.dart';
import 'package:gerenciamento_rural/models/corte_abatidos.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPage.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class ListaAnimalAbatidoCorte extends StatefulWidget {
  @override
  _ListaAnimalAbatidoCorteState createState() =>
      _ListaAnimalAbatidoCorteState();
}

class _ListaAnimalAbatidoCorteState extends State<ListaAnimalAbatidoCorte> {
  TextEditingController editingController = TextEditingController();
  CorteAbatidosDB helper = CorteAbatidosDB();
  List<CortesAbatidos> totalBez = [];
  List<CortesAbatidos> items = [];
  List<CortesAbatidos> tBezerras = [];
  @override
  void initState() {
    super.initState();
    _getAllBez();
    items = [];
    tBezerras = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Nome(Crescente)"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Nome(Decrescente)"),
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
        ],
        centerTitle: true,
        title: Text("Históricos de Animais"),
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
                    labelText: "Buscar Por Nome / Nº Brinco",
                    hintText: "Buscar Por Nome / Nº Brinco",
                    prefix: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: totalBez.length,
                    itemBuilder: (context, index) {
                      return _totalBezCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _totalBezCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Nome: " + totalBez[index].nomeAnimal ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Cat: " + totalBez[index].categoria ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Idade: " + totalBez[index].idade ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
              ],
            ),
          ),
        ),
      ),
      onTap: () {
        // _showOptions(context, index);
      },
    );
  }

  // void _showOptions(BuildContext context, int index) {
  //   showModalBottomSheet(
  //       context: context,
  //       builder: (context) {
  //         return BottomSheet(
  //           onClosing: () {},
  //           builder: (context) {
  //             return Container(
  //               padding: EdgeInsets.all(10.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   Padding(
  //                     padding: EdgeInsets.all(10.0),
  //                     child: ElevatedButton(
  //                       child: Text(
  //                         "Editar",
  //                         style: TextStyle(color: Colors.red, fontSize: 20.0),
  //                       ),
  //                       onPressed: () {
  //                         Navigator.pop(context);
  //                         _showtotalBezPage(totalBez: totalBez[index]);
  //                       },
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: EdgeInsets.all(10.0),
  //                     child: ElevatedButton(
  //                       child: Text(
  //                         "Excluir",
  //                         style: TextStyle(color: Colors.red, fontSize: 20.0),
  //                       ),
  //                       onPressed: () {
  //                         try {
  //                           helper.delete(totalBez[index].id);
  //                         } catch (e) {
  //                           Toast.show("$Exception($e)", context,
  //                               duration: Toast.LENGTH_SHORT,
  //                               gravity: Toast.CENTER);
  //                         }

  //                         setState(() {
  //                           totalBez.removeAt(index);
  //                           Navigator.pop(context);
  //                         });
  //                       },
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       });
  // }

  // void _showtotalBezPage({CortesAbatidos totalBez}) async {
  //   final rectotalBez = await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => CadastroBezerraCorte(
  //           bezerra: totalBez,
  //         ),
  //       ));
  //   if (rectotalBez != null) {
  //     if (totalBez != null) {
  //       await helper.updateItem(rectotalBez);
  //     } else {
  //       await helper.insert(rectotalBez);
  //     }
  //     _getAllBez();
  //   }
  // }

  void _getAllBez() {
    items = [];
    helper.getAllItems().then((list) {
      setState(() {
        totalBez = list;
        items.addAll(totalBez);
      });
    });
  }

  _creatPdf(context) async {
    tBezerras = totalBez;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Nome',
                  'Cat.',
                  'Idade',
                  'Peso Kg/@',
                  'Preço Kg/@',
                  "Data",
                  "Comprador",
                  "Observação"
                ],
                ...tBezerras.map((item) => [
                      item.nomeAnimal,
                      item.categoria,
                      item.idade,
                      item.pesoArroba.toString(),
                      item.precoKgArroba.toString(),
                      item.data,
                      item.comprador,
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
        totalBez.sort((a, b) {
          return a.nomeAnimal
              .toLowerCase()
              .compareTo(b.nomeAnimal.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        totalBez.sort((a, b) {
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
    List<CortesAbatidos> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<CortesAbatidos> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nomeAnimal.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        totalBez.clear();
        totalBez.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        totalBez.clear();
        totalBez.addAll(items);
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
                      pdfLib.Text('Histórico de Animais',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

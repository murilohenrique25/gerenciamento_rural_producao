import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/garrote_corte_db.dart';
import 'package:gerenciamento_rural/helpers/touro_corte_db.dart';
import 'package:gerenciamento_rural/models/garrote_corte.dart';
import 'package:gerenciamento_rural/models/touro_corte.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPage.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/second_screen/rebanho/plantel/second_screen/registers/cadastro_garrote_corte.dart';

import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

enum OrderOptions { orderaz, orderza }

class ListaGarrotesCorte extends StatefulWidget {
  @override
  _ListaGarrotesCorteState createState() => _ListaGarrotesCorteState();
}

class _ListaGarrotesCorteState extends State<ListaGarrotesCorte> {
  TextEditingController editingController = TextEditingController();
  GarroteCorteDB helper = GarroteCorteDB();
  List<GarroteCorte> totalGarrotes = [];
  List<GarroteCorte> items = [];
  List<GarroteCorte> tGarrotes = [];
  @override
  void initState() {
    super.initState();
    _getAllGarrote();
    items = [];
    tGarrotes = [];
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
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showTotalGarrotePage();
              }),
        ],
        centerTitle: true,
        title: Text("Garrotes da Propriedade"),
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
                    itemCount: totalGarrotes.length,
                    itemBuilder: (context, index) {
                      return _totalGarroteCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _totalGarroteCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Nome / Nº Brinco: " + totalGarrotes[index].nome ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
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
                          _showTotalGarrotePage(
                              totalGarrotes: totalGarrotes[index]);
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
                            helper.delete(totalGarrotes[index].id);
                          } catch (e) {
                            Toast.show("$Exception($e)", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }

                          setState(() {
                            totalGarrotes.removeAt(index);
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

  void _showTotalGarrotePage({GarroteCorte totalGarrotes}) async {
    final recTotal = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroGarroteCorte(
            garrote: totalGarrotes,
          ),
        ));
    if (recTotal != null) {
      if (totalGarrotes != null) {
        await helper.updateItem(recTotal);
      } else {
        await helper.insert(recTotal);
      }
      _getAllGarrote();
    }
  }

  void _getAllGarrote() {
    items = [];
    helper.getAllItems().then((list) {
      setState(() {
        totalGarrotes = list;
        items.addAll(totalGarrotes);
      });

      items.forEach((element) {
        String num = "";
        DateTime dt = DateTime.now();
        num = element.dataNascimento.split('-').reversed.join();
        DateTime date = DateTime.parse(num);

        int quant = dt.difference(date).inDays;
        if (quant >= 570) {
          TouroCorte touroCorte;
          TouroCorteDB touroCorteDB = TouroCorteDB();
          element.virouAdulto = 1;
          helper.updateItem(element);
          touroCorte = TouroCorte.fromMap(element.toMap());
          touroCorteDB.insert(touroCorte);
        }
      });
      _getAllGarrote();
    });
  }

  _creatPdf(context) async {
    tGarrotes = totalGarrotes;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Nome / Nº Brinco',
                  'Data Nascimento',
                  'Pai',
                  'Mãe',
                  'Raça',
                  "Lote",
                  "Idade Desmama",
                  "Peso Desmama",
                  "Origem",
                  "Peso",
                  "Situação"
                ],
                ...tGarrotes.map((item) => [
                      item.nome,
                      item.dataNascimento,
                      item.pai,
                      item.mae,
                      item.raca,
                      item.nomeLote,
                      item.idadeDesmama,
                      item.pesoDesmama.toString(),
                      item.origem,
                      item.peso.toString(),
                      item.situacao
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
        totalGarrotes.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        totalGarrotes.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  //filtrar resultado com o texto passado
  void filterSearchResults(String query) {
    List<GarroteCorte> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<GarroteCorte> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nome.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        totalGarrotes.clear();
        totalGarrotes.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        totalGarrotes.clear();
        totalGarrotes.addAll(items);
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
                      pdfLib.Text('Garrotes',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/nutricao_volumoso_equino_db.dart';
import 'package:gerenciamento_rural/models/nutricao_volumoso.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPage.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/nutricao/screen/second_screen/registers/cadastro_nutricao_volumoso.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

import 'package:toast/toast.dart';

enum OrderOptions { orderaz, orderza }

class ListNutricaoVolumosoEquino extends StatefulWidget {
  @override
  _ListNutricaoVolumosoEquinoState createState() =>
      _ListNutricaoVolumosoEquinoState();
}

class _ListNutricaoVolumosoEquinoState
    extends State<ListNutricaoVolumosoEquino> {
  TextEditingController editingController = TextEditingController();
  NutricaoVolumosoEquinoDB helper = NutricaoVolumosoEquinoDB();
  List<NutricaoVolumoso> totalNT = [];
  List<NutricaoVolumoso> items = [];
  List<NutricaoVolumoso> nutricoes = [];
  List<NutricaoVolumoso> tnutricao = [];
  @override
  void initState() {
    super.initState();
    _getAllNT();
    items = [];
    tnutricao = [];
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
                _showTNPage();
              }),
        ],
        centerTitle: true,
        title: Text("Nutrição Volumoso"),
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
                    labelText: "Buscar Por Nome Lote",
                    hintText: "Buscar Por Nome Lote",
                    prefix: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: totalNT.length,
                    itemBuilder: (context, index) {
                      return _totalNTCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _totalNTCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Nome do Lote: " + totalNT[index].nomeLote,
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(" - "),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "Data: " + totalNT[index].data,
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
                          _showTNPage(nutricaoVolumoso: totalNT[index]);
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
                            helper.delete(totalNT[index].id);
                          } catch (e) {
                            Toast.show("$Exception($e)", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }

                          setState(() {
                            totalNT.removeAt(index);
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

  void _showTNPage({NutricaoVolumoso nutricaoVolumoso}) async {
    final recTN = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroNutricaoVolumosoEquino(
            nutricaoVolumoso: nutricaoVolumoso,
          ),
        ));
    if (recTN != null) {
      if (nutricaoVolumoso != null) {
        await helper.updateItem(recTN);
      } else {
        await helper.insert(recTN);
      }
      _getAllNT();
    }
  }

  void _getAllNT() {
    totalNT = [];
    items = [];
    helper.getAllItems().then((value) {
      setState(() {
        totalNT = value;
        items = totalNT;
      });
    });
  }

  _creatPdf(context) async {
    tnutricao = totalNT;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Tipo',
                  'Data',
                  'Lote',
                  'PB %',
                  'NDT %',
                  'MS %',
                  'Umidade',
                  'Quantidade individual',
                  'Quantidade total',
                  'Observação'
                ],
                ...tnutricao.map((item) => [
                      item.tipo,
                      item.data,
                      item.nomeLote,
                      item.pb.toString(),
                      item.ndt.toString(),
                      item.ms.toString(),
                      item.umidade.toString(),
                      item.quantidadeInd.toString(),
                      item.quantidadeTotal.toString(),
                      item.observacao
                    ])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfnc.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pdf.save());
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLeite(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        totalNT.sort((a, b) {
          return a.nomeLote.toLowerCase().compareTo(b.nomeLote.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        totalNT.sort((a, b) {
          return b.nomeLote.toLowerCase().compareTo(a.nomeLote.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  //filtrar resultado com o texto passado
  void filterSearchResults(String query) {
    List<NutricaoVolumoso> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<NutricaoVolumoso> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nomeLote.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        totalNT.clear();
        totalNT.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        totalNT.clear();
        totalNT.addAll(items);
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
                      pdfLib.Text('Nutrição Volumoso',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

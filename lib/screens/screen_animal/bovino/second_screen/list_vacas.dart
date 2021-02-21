import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/vaca_db.dart';
import 'package:gerenciamento_rural/models/vaca.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/cadastro_vaca.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPageleite.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

enum OrderOptions { orderaz, orderza }

class ListaVacas extends StatefulWidget {
  @override
  _ListaVacasState createState() => _ListaVacasState();
}

class _ListaVacasState extends State<ListaVacas> {
  TextEditingController editingController = TextEditingController();
  VacaDB helper = VacaDB();
  List<Vaca> totalVacas = List();
  List<Vaca> items = List();
  List<Vaca> vacas = List();
  List<Vaca> tvacas = List();
  @override
  void initState() {
    super.initState();
    _getAllVacas();
    items = List();
    tvacas = List();
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
                _showTotalVacasPage();
              }),
        ],
        centerTitle: true,
        title: Text("Vacas da Propriedade"),
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
                    itemCount: totalVacas.length,
                    itemBuilder: (context, index) {
                      return _totalVacasCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _totalVacasCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Nome / Nº Brinco: " + totalVacas[index].nome ?? "",
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
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showTotalVacasPage(totalVacas: totalVacas[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          try {
                            helper.delete(totalVacas[index].idVaca);
                          } catch (e) {
                            Toast.show("$Exception($e)", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }

                          setState(() {
                            totalVacas.removeAt(index);
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

  void _showTotalVacasPage({Vaca totalVacas}) async {
    final recTotalVacas = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroVaca(
            vaca: totalVacas,
          ),
        ));
    if (recTotalVacas != null) {
      if (totalVacas != null) {
        await helper.updateItem(recTotalVacas);
      } else {
        await helper.insert(recTotalVacas);
      }
      _getAllVacas();
    }
  }

  void _getAllVacas() {
    items = List();
    helper.getAllItems().then((list) {
      setState(() {
        totalVacas = list;
        items.addAll(totalVacas);
      });
    });
  }

  _creatPdf(context) async {
    tvacas = totalVacas;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Nome / Nº Brinco',
                  'Última Inseminação',
                  'Raça',
                  'Estado',
                  "Lote"
                ],
                ...tvacas.map((item) => [
                      item.nome,
                      item.ultimaInseminacao,
                      item.raca,
                      item.estado,
                      item.idLote.toString()
                    ])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfVacas.pdf';
    final File file = File(path);
    file.writeAsBytesSync(pdf.save());
    print("$file");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLeite(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        totalVacas.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        totalVacas.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  //filtrar resultado com o texto passado
  void filterSearchResults(String query) {
    List<Vaca> dummySearchList = List();
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<Vaca> dummyListData = List();
      dummySearchList.forEach((item) {
        if (item.nome.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        totalVacas.clear();
        totalVacas.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        totalVacas.clear();
        totalVacas.addAll(items);
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
                      pdfLib.Text('Vacas',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

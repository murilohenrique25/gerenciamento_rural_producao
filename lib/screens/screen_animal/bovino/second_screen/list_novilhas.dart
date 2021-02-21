import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/novilha_db.dart';
import 'package:gerenciamento_rural/models/novilha.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/cadastro_novilha.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPageleite.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

enum OrderOptions { orderaz, orderza }

class ListaNovilhas extends StatefulWidget {
  @override
  _ListaNovilhasState createState() => _ListaNovilhasState();
}

class _ListaNovilhasState extends State<ListaNovilhas> {
  TextEditingController editingController = TextEditingController();
  NovilhaDB helper = NovilhaDB();
  List<Novilha> totalNovilhas = List();
  List<Novilha> items = List();
  List<Novilha> novilhas = List();
  List<Novilha> tnovilhas = List();
  @override
  void initState() {
    super.initState();
    _getAllNovilhas();
    items = List();
    tnovilhas = List();
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
                _showTotalNovilhasPage();
              }),
        ],
        centerTitle: true,
        title: Text("Novilhas da Propriedade"),
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
                    itemCount: totalNovilhas.length,
                    itemBuilder: (context, index) {
                      return _totalNovilhasCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _totalNovilhasCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Nome / Nº Brinco: " + totalNovilhas[index].nome,
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
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showTotalNovilhasPage(
                              totalNovilhas: totalNovilhas[index]);
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
                            helper.delete(totalNovilhas[index].idNovilha);
                          } catch (e) {
                            Toast.show("$Exception($e)", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }

                          setState(() {
                            totalNovilhas.removeAt(index);
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

  void _showTotalNovilhasPage({Novilha totalNovilhas}) async {
    final recTotalNovilhas = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroNovilha(
            novilha: totalNovilhas,
          ),
        ));
    if (recTotalNovilhas != null) {
      if (totalNovilhas != null) {
        await helper.updateItem(recTotalNovilhas);
      } else {
        await helper.insert(recTotalNovilhas);
      }
      _getAllNovilhas();
    }
  }

  void _getAllNovilhas() {
    items = List();
    helper.getAllItems().then((list) {
      setState(() {
        totalNovilhas = list;
        items.addAll(totalNovilhas);
      });
    });
  }

  _creatPdf(context) async {
    tnovilhas = totalNovilhas;
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
                ...tnovilhas.map((item) =>
                    [item.nome, item.raca, item.estado, item.idLote.toString()])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfNovilhas.pdf';
    final File file = File(path);
    file.writeAsBytesSync(pdf.save());
    print("$file");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLeite(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        totalNovilhas.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        totalNovilhas.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  //filtrar resultado com o texto passado
  void filterSearchResults(String query) {
    List<Novilha> dummySearchList = List();
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<Novilha> dummyListData = List();
      dummySearchList.forEach((item) {
        if (item.nome.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        totalNovilhas.clear();
        totalNovilhas.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        totalNovilhas.clear();
        totalNovilhas.addAll(items);
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
                      pdfLib.Text('Novilhas',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

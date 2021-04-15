import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/egua_db.dart';
import 'package:gerenciamento_rural/models/egua.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPageleite.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/tree_screen/plantel/registers/cadastro_egua.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:toast/toast.dart';

enum OrderOptions { orderaz, orderza }

class ListaEguas extends StatefulWidget {
  @override
  _ListaEguasState createState() => _ListaEguasState();
}

class _ListaEguasState extends State<ListaEguas> {
  TextEditingController editingController = TextEditingController();
  EguaDB helper = EguaDB();
  List<Egua> items = [];
  List<Egua> eguas = [];
  List<Egua> tEguas = [];
  @override
  void initState() {
    super.initState();
    _getAllEguas();
    items = [];
    tEguas = [];
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
                _showTotalEguasPage();
              }),
        ],
        centerTitle: true,
        title: Text("Éguas"),
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
                    labelText: "Buscar égua",
                    hintText: "Buscar égua",
                    prefix: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: eguas.length,
                    itemBuilder: (context, index) {
                      return _totalEguasCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _totalEguasCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Nome: " + eguas[index].nome,
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
                          _showTotalEguasPage(egua: eguas[index]);
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
                            helper.delete(eguas[index].id);
                          } catch (e) {
                            Toast.show("$Exception($e)", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }

                          setState(() {
                            eguas.removeAt(index);
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

  void _showTotalEguasPage({Egua egua}) async {
    final recEgua = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroEgua(
            egua: egua,
          ),
        ));
    if (recEgua != null) {
      if (egua != null) {
        await helper.updateItem(recEgua);
      } else {
        await helper.insert(recEgua);
      }
      _getAllEguas();
    }
  }

  void _getAllEguas() {
    items = [];
    helper.getAllItems().then((list) {
      setState(() {
        eguas = list;
        items.addAll(eguas);
      });
    });
  }

  _creatPdf(context) async {
    tEguas = eguas;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Nome', 'Procedência', 'Raça'],
                ...eguas.map((item) => [item.nome, item.origem, item.raca])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfCachacos.pdf';
    final File file = File(path);
    if (!await file.exists()) {
      await file.create(recursive: true);
      file.writeAsStringSync("pdf");
    }
    ShareExtend.share(file.path, "file");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLeite(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        eguas.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        eguas.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  //filtrar resultado com o texto passado
  void filterSearchResults(String query) {
    List<Egua> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<Egua> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nome.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        eguas.clear();
        eguas.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        eguas.clear();
        eguas.addAll(items);
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
                      pdfLib.Text('Éguas',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/preco_leite_db.dart';
import 'package:gerenciamento_rural/models/preco_leite.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/cadastrar_preco_leite.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/pdfViwerPagePrecoLeite.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class PrecoLeiteList extends StatefulWidget {
  @override
  _PrecoLeiteListState createState() => _PrecoLeiteListState();
}

class _PrecoLeiteListState extends State<PrecoLeiteList> {
  TextEditingController editingController = TextEditingController();
  PrecoLeiteDB helper = PrecoLeiteDB();
  List<PrecoLeite> items = [];
  List<PrecoLeite> precoleitelist = [];
  List<PrecoLeite> tPrecoleitelist = [];

  @override
  void initState() {
    super.initState();
    _getAllPRecoLeite();
    items = [];
    tPrecoleitelist = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
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
                _showPrecoLeitePage();
              }),
        ],
        centerTitle: true,
        title: Text("Lista Preço do Leite"),
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
                    labelText: "Buscar Por Data",
                    hintText: "Buscar Por Data",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: precoleitelist.length,
                  itemBuilder: (context, index) {
                    return _precoLeiteCard(context, index);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _precoLeiteCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Text(
                "Data: " + precoleitelist[index].data ?? "",
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(
                width: 15,
              ),
              Text(" - "),
              SizedBox(
                width: 15,
              ),
              Text(
                "Preço: " + precoleitelist[index].preco.toString() ?? "",
                style: TextStyle(fontSize: 14.0),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, index);
      },
    );
  }

  void _getAllPRecoLeite() {
    items = [];
    helper.getAllItems().then((value) {
      setState(() {
        precoleitelist = value;
        items.addAll(precoleitelist);
      });
    });
  }

  void _showPrecoLeitePage({PrecoLeite precoLeite}) async {
    final recPrecoLeite = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroPrecoLeite(
                  precoLeite: precoLeite,
                )));
    if (recPrecoLeite != null) {
      if (precoLeite != null) {
        await helper.updateItem(recPrecoLeite);
      } else {
        await helper.insert(recPrecoLeite);
      }
      _getAllPRecoLeite();
    }
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
                          _showPrecoLeitePage(
                              precoLeite: precoleitelist[index]);
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
                          helper.delete(precoleitelist[index].id);
                          setState(() {
                            precoleitelist.removeAt(index);
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

  _creatPdf(context) async {
    tPrecoleitelist = precoleitelist;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Data', 'Preço'],
                ...tPrecoleitelist
                    .map((item) => [item.data, item.preco.toString()])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfLotes.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pdf.save());
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PdfViwerPagePrecoLeite(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        precoleitelist.sort((a, b) {
          return a.preco.compareTo(b.preco);
        });
        break;
      case OrderOptions.orderza:
        precoleitelist.sort((a, b) {
          return b.preco.compareTo(a.preco);
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<PrecoLeite> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<PrecoLeite> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.data.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        precoleitelist.clear();
        precoleitelist.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        precoleitelist.clear();
        precoleitelist.addAll(items);
      });
    }
  }

  pdfLib.Widget _buildHeade(pdfLib.Context context) {
    return pdfLib.Container(
        color: PdfColors.green,
        height: 150,
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
                      pdfLib.Text('Preço Leite',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

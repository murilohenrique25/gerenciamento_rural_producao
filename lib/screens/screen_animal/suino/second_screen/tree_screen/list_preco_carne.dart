import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/preco_carne_suina_db.dart';
import 'package:gerenciamento_rural/models/preco_carne_suina.dart';
import 'package:gerenciamento_rural/screens/utilitarios/cadastrar_preco_carne_suina.dart';
import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPage.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

enum OrderOptions { orderaz, orderza }

class PrecoCarneSuinaList extends StatefulWidget {
  @override
  _PrecoCarneSuinaListState createState() => _PrecoCarneSuinaListState();
}

class _PrecoCarneSuinaListState extends State<PrecoCarneSuinaList> {
  TextEditingController editingController = TextEditingController();
  PrecoCarneSuinaDB helper = PrecoCarneSuinaDB();
  List<PrecoCarneSuina> items = [];
  List<PrecoCarneSuina> precocarnelist = [];
  List<PrecoCarneSuina> tprecocarnelistlist = [];

  @override
  void initState() {
    super.initState();
    _getAllPrecoCarne();
    items = [];
    tprecocarnelistlist = [];
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
                _showPrecoCarnePage();
              }),
        ],
        centerTitle: true,
        title: Text("Lista Preço Carne Suína"),
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
                  itemCount: precocarnelist.length,
                  itemBuilder: (context, index) {
                    return _precoCarneCard(context, index);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _precoCarneCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Text(
                "Data: " + precocarnelist[index].data ?? "",
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
                "Preço: " + precocarnelist[index].preco.toString() ?? "",
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

  void _getAllPrecoCarne() {
    items = [];
    helper.getAllItems().then((value) {
      setState(() {
        precocarnelist = value;
        items.addAll(precocarnelist);
      });
    });
  }

  void _showPrecoCarnePage({PrecoCarneSuina precoCarneSuina}) async {
    final recPrecoCarne = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroPrecoCarneSuina(
                  precoCarneSuina: precoCarneSuina,
                )));
    if (recPrecoCarne != null) {
      if (precoCarneSuina != null) {
        await helper.updateItem(recPrecoCarne);
      } else {
        await helper.insert(recPrecoCarne);
      }
      _getAllPrecoCarne();
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
                          _showPrecoCarnePage(
                              precoCarneSuina: precocarnelist[index]);
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
                          helper.delete(precocarnelist[index].id);
                          setState(() {
                            precocarnelist.removeAt(index);
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
    tprecocarnelistlist = precocarnelist;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Data', 'Preço'],
                ...tprecocarnelistlist
                    .map((item) => [item.data, item.preco.toString()])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfCarnes.pdf';
    final File file = File(path);
    if (!await file.exists()) {
      await file.create(recursive: true);
      file.writeAsStringSync("pdf");
    }
    ShareExtend.share(file.path, "file");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPage(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        precocarnelist.sort((a, b) {
          return a.preco.compareTo(b.preco);
        });
        break;
      case OrderOptions.orderza:
        precocarnelist.sort((a, b) {
          return b.preco.compareTo(a.preco);
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<PrecoCarneSuina> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<PrecoCarneSuina> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.data.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        precocarnelist.clear();
        precocarnelist.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        precocarnelist.clear();
        precocarnelist.addAll(items);
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
                      pdfLib.Text('Instituto Federal Goiano',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white)),
                      pdfLib.Text(
                          'Rodovia Geraldo Silva Nascimento Km 2,5, Rod. Gustavo Capanema,\nUrutaí - GO, 75790-000',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('(64) 3465-1900',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('Preço Carne Suína',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

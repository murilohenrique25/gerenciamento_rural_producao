import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/inventario_semen_equino_db.dart';
import 'package:gerenciamento_rural/models/inventario_semen_equino.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/reproducao_screen/registers/cadastro_estoque_semen.dart';
import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPage.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

enum OrderOptions { orderaz, orderza }

class ListaEstoqueSemenEquinos extends StatefulWidget {
  @override
  _ListaEstoqueSemenEquinosState createState() =>
      _ListaEstoqueSemenEquinosState();
}

class _ListaEstoqueSemenEquinosState extends State<ListaEstoqueSemenEquinos> {
  TextEditingController editingController = TextEditingController();
  InventarioSemenEquinoDB helper = InventarioSemenEquinoDB();
  List<InventarioSemenEquino> items = [];
  List<InventarioSemenEquino> inventarioSemens = [];
  List<InventarioSemenEquino> tInventarioSemens = [];

  @override
  void initState() {
    super.initState();
    _getAllInventario();
    items = [];
    tInventarioSemens = [];
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
                _showPage();
              }),
        ],
        centerTitle: true,
        title: Text("Lista Inventário Sêmen Equinos"),
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
                    labelText: "Buscar Sêmen por Cavalo",
                    hintText: "Buscar Sêmen por Cavalo",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: inventarioSemens.length,
                  itemBuilder: (context, index) {
                    return _inventarioCard(context, index);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _inventarioCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Text(
                "Cavalo: " + inventarioSemens[index].nomeCavalo ?? "",
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
                "Quantidade: " +
                        inventarioSemens[index].quantidade.toString() ??
                    "",
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

  void _getAllInventario() {
    items = [];
    helper.getAllItems().then((value) {
      setState(() {
        inventarioSemens = value;
        items.addAll(inventarioSemens);
      });
    });
  }

  void _showPage({InventarioSemenEquino inventario}) async {
    final recInventario = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroEstoqueSemenEquino(
                  inventarioSemenEquino: inventario,
                )));
    if (recInventario != null) {
      if (inventario != null) {
        await helper.updateItem(recInventario);
      } else {
        await helper.insert(recInventario);
      }
      _getAllInventario();
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
                          _showPage(inventario: inventarioSemens[index]);
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
                          helper.delete(inventarioSemens[index].id);
                          setState(() {
                            inventarioSemens.removeAt(index);
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
    tInventarioSemens = inventarioSemens;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Cavalo', 'Quantidade'],
                ...tInventarioSemens.map(
                    (item) => [item.nomeCavalo, item.quantidade.toString()])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfISS.pdf';
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
        inventarioSemens.sort((a, b) {
          return a.nomeCavalo
              .toLowerCase()
              .compareTo(b.nomeCavalo.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        inventarioSemens.sort((a, b) {
          return b.nomeCavalo
              .toLowerCase()
              .compareTo(a.nomeCavalo.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<InventarioSemenEquino> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<InventarioSemenEquino> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nomeCavalo.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        inventarioSemens.clear();
        inventarioSemens.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        inventarioSemens.clear();
        inventarioSemens.addAll(items);
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
                      pdfLib.Text('Inventário Sêmen Suína',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

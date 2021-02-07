import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/inventario_semen_db.dart';
import 'package:gerenciamento_rural/models/inventario_semen.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:gerenciamento_rural/screens/screen_animal/touros/second_screen/tree_screen/cadastrar_inventario_semen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/touros/second_screen/pdf/pdfViwerPageInventario.dart';

enum OrderOptions { orderaz, orderza }

class ListInventarioSemen extends StatefulWidget {
  @override
  _ListInventarioSemenState createState() => _ListInventarioSemenState();
}

class _ListInventarioSemenState extends State<ListInventarioSemen> {
  TextEditingController editingController = TextEditingController();
  InventarioSemenDB helper = InventarioSemenDB();
  List<InventarioSemen> items = List();
  List<InventarioSemen> semens = List();
  List<InventarioSemen> tSemens = List();

  @override
  void initState() {
    super.initState();
    _getAllInventarioSemen();
    items = List();
    tSemens = List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Z-A"),
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
                _showInvetarioSemen();
              }),
        ],
        centerTitle: true,
        title: Text("Inventário"),
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
                    labelText: "Buscar Por Animal",
                    hintText: "Buscar Por Animal",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: semens.length,
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
                "Nome: " + semens[index].touro.nome ?? "",
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
                "Quantidade: " + semens[index].quantidade.toString() ?? "",
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
                          _showInvetarioSemen(invet: semens[index]);
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
                          helper.delete(semens[index].id);
                          setState(() {
                            semens.removeAt(index);
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

  void _showInvetarioSemen({InventarioSemen invet}) async {
    final recInvet = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroInventarioSemen(
                  invet: invet,
                )));
    if (recInvet != null) {
      if (invet != null) {
        await helper.updateItem(recInvet);
      } else {
        await helper.insert(recInvet);
      }
      _getAllInventarioSemen();
    }
  }

  void _getAllInventarioSemen() {
    items = List();
    helper.getAllItems().then((list) {
      setState(() {
        semens = list;
        items.addAll(semens);
      });
    });
  }

  _creatPdf(context) async {
    tSemens = semens;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Nome', 'Quantidade de Sêmens'],
                ...tSemens.map(
                    (item) => [item.touro.nome, item.quantidade.toString()])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfInventarioSemens.pdf';
    final File file = File(path);
    file.writeAsBytesSync(pdf.save());
    print("$file");
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => PdfViwerPageInventario(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        semens.sort((a, b) {
          return a.touro.nome
              .toLowerCase()
              .compareTo(b.touro.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        semens.sort((a, b) {
          return b.touro.nome
              .toLowerCase()
              .compareTo(a.touro.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<InventarioSemen> dummySearchList = List();
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<InventarioSemen> dummyListData = List();
      dummySearchList.forEach((item) {
        if (item.touro.nome.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        semens.clear();
        semens.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        semens.clear();
        semens.addAll(items);
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
                      pdfLib.Text('Lotes',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

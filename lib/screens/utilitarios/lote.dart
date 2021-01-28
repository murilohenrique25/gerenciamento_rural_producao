import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/lote_db.dart';
import 'package:gerenciamento_rural/models/lote.dart';
import 'package:gerenciamento_rural/screens/utilitarios/cadastrar_lote.dart';
import 'package:gerenciamento_rural/screens/utilitarios/impressao_lote.dart';
import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPageLote.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class Lotes extends StatefulWidget {
  @override
  _LotesState createState() => _LotesState();
}

class _LotesState extends State<Lotes> {
  TextEditingController editingController = TextEditingController();
  LoteDB helper = LoteDB();
  List<Lote> items = List();
  List<Lote> lotes = List();
  @override
  void initState() {
    super.initState();
    _getAllLotes();
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
              icon: Icon(Icons.add_chart),
              onPressed: () {
                _creatPdf(context);
              }),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _showLotePage();
              }),
        ],
        centerTitle: true,
        title: Text("Lotes"),
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
                    labelText: "Buscar Lote",
                    hintText: "Buscar Lote",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: lotes.length,
                  itemBuilder: (context, index) {
                    return _loteCard(context, index);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _loteCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Text(
                "Nome: " + lotes[index].name ?? "",
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
                "Quantidade animais: " + lotes[index].quantidade.toString() ??
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
                          _showLotePage(lote: lotes[index]);
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
                          helper.delete(lotes[index].id);
                          setState(() {
                            lotes.removeAt(index);
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

  void _showLotePage({Lote lote}) async {
    final recLote = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroLote(
                  lote: lote,
                )));
    if (recLote != null) {
      if (lote != null) {
        await helper.updateItem(recLote);
      } else {
        await helper.insert(recLote);
      }
      _getAllLotes();
    }
  }

  void _getAllLotes() {
    helper.getAllItems().then((list) {
      setState(() {
        lotes = list;
        items.addAll(lotes);
      });
    });
  }

  _creatPdf(context) async {
    List<Lote> tLotes = items;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Nome', 'Quantidade'],
                ...tLotes.map((item) => [item.name, item.quantidade.toString()])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfExample.pdf';
    final File file = File(path);
    file.writeAsBytesSync(pdf.save());

    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLote(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        lotes.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        lotes.sort((a, b) {
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<Lote> dummySearchList = List();
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<Lote> dummyListData = List();
      dummySearchList.forEach((item) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        lotes.clear();
        lotes.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        lotes.clear();
        lotes.addAll(items);
      });
    }
  }
}

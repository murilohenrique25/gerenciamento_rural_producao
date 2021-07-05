import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/gasto_suino_db.dart';
import 'package:gerenciamento_rural/models/gasto.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/economia/registers/cadastrar_economia_gastos.dart';
import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPage.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class EconomiaSuina extends StatefulWidget {
  @override
  _EconomiaSuinaState createState() => _EconomiaSuinaState();
}

class _EconomiaSuinaState extends State<EconomiaSuina> {
  TextEditingController editingController = TextEditingController();
  GastoSuinoDB helper = GastoSuinoDB();
  List<Gasto> items = [];
  List<Gasto> gastos = [];
  List<Gasto> tGastos = [];
  @override
  void initState() {
    super.initState();
    _getAllGastos();
    items = [];
    tGastos = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton<OrderOptions>(
              itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar por Data"),
                  value: OrderOptions.orderaz,
                ),
                const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar por Data"),
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
                  _showGastoPage();
                }),
          ],
          centerTitle: true,
          title: Text("Gastos"),
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
                      labelText: "Buscar Gasto",
                      hintText: "Buscar Gasto",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(10.0),
                    itemCount: gastos.length,
                    itemBuilder: (context, index) {
                      return _gastoCard(context, index);
                    }),
              )
            ],
          ),
        ));
  }

  Widget _gastoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Data: " + gastos[index].data ?? "",
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
                  "Descrição: " + gastos[index].nome ?? "",
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
                  "Quantidade: " + gastos[index].quantidade.toString() ?? "",
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
                  "Valor Unitário: " + gastos[index].valorUnitario.toString() ??
                      "",
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(" - "),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Valor Total: " + gastos[index].valorTotal.toString() ?? "",
                  style: TextStyle(fontSize: 14.0),
                )
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
                          _showGastoPage(gasto: gastos[index]);
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
                          helper.delete(gastos[index].id);
                          setState(() {
                            gastos.removeAt(index);
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

  void _showGastoPage({Gasto gasto}) async {
    final recGastos = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroEconomiaGasto(
                  gasto: gasto,
                )));
    if (recGastos != null) {
      if (gasto != null) {
        await helper.updateItem(recGastos);
      } else {
        await helper.insert(recGastos);
      }
      _getAllGastos();
    }
  }

  void _getAllGastos() {
    items = [];
    helper.getAllItems().then((value) {
      setState(() {
        gastos = value;
        items.addAll(gastos);
        gastos.forEach((element) {
          var tes = element.data.split("-");
          int dia = int.parse(tes[0]);
          int mes = int.parse(tes[1]);
          if (dia >= 15 && mes == 2) {
            print("dia $dia - mes - $mes");
          }
        });
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        gastos.sort((a, b) {
          return a.data.toLowerCase().compareTo(b.data.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        gastos.sort((a, b) {
          return b.data.toLowerCase().compareTo(a.data.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<Gasto> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<Gasto> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nome.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        gastos.clear();
        gastos.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        gastos.clear();
        gastos.addAll(items);
      });
    }
  }

  _creatPdf(context) async {
    print(items);
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Nome',
                  'Data',
                  'Valor Unitário',
                  'Quantidade',
                  'Valor Total'
                ],
                ...items.map((item) => [
                      item.nome,
                      item.data,
                      item.valorUnitario.toString(),
                      item.quantidade.toString(),
                      item.valorTotal.toString()
                    ])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdf.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pdf.save());
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPage(path: path)));
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
                      pdfLib.Text('Gastos',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/inventario_semen_caprino_db.dart';
import 'package:gerenciamento_rural/models/inventario_semen_caprino.dart';
import 'package:gerenciamento_rural/screens/screen_animal/caprinos/second_screen/reproducao/registers/cadastro_estoque_semen.dart';
import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPage.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class ListaEstoqueSemenCaprina extends StatefulWidget {
  @override
  _ListaEstoqueSemenCaprinaState createState() =>
      _ListaEstoqueSemenCaprinaState();
}

class _ListaEstoqueSemenCaprinaState extends State<ListaEstoqueSemenCaprina> {
  TextEditingController editingController = TextEditingController();
  InventarioSemenCaprinoDB helper = InventarioSemenCaprinoDB();
  List<InventarioSemenCaprino> items = [];
  List<InventarioSemenCaprino> inventarioSemens = [];
  List<InventarioSemenCaprino> tInventarioSemens = [];

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
        title: Text("Lista Inventário Sêmen Caprino"),
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
                    labelText: "Buscar Sêmen por Reprodutor",
                    hintText: "Buscar Sêmen por Reprodutor",
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
                "Reprodutor: " + inventarioSemens[index].nomeReprodutor ?? "",
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

  void _showPage({InventarioSemenCaprino inventario}) async {
    final recInventario = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroEstoqueSemenCaprina(
                  inventarioSemenCaprino: inventario,
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
                <String>[
                  'Reprodutor',
                  'Identificação',
                  'Quantidade',
                  'Cor',
                  'Data Cadastro',
                  'Data Validade',
                  'Vigor',
                  'Motilidade',
                  'Turbilhamento',
                  'Concentração',
                  'Volume',
                  'Aspecto',
                  'Células Normais',
                  'Defeitos Maiores',
                  'Defeitos Menores',
                  'Observação'
                ],
                ...tInventarioSemens.map((item) => [
                      item.nomeReprodutor,
                      item.identificacao,
                      item.quantidade.toString(),
                      item.cor,
                      item.dataCadastro,
                      item.dataValidade,
                      item.vigor,
                      item.mortalidade,
                      item.turbilhamento,
                      item.concentracao,
                      item.volume.toString(),
                      item.aspecto,
                      item.celulasNormais.toString(),
                      item.defeitoMaiores,
                      item.defeitoMenores,
                      item.observacao
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

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        inventarioSemens.sort((a, b) {
          return a.nomeReprodutor
              .toLowerCase()
              .compareTo(b.nomeReprodutor.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        inventarioSemens.sort((a, b) {
          return b.nomeReprodutor
              .toLowerCase()
              .compareTo(a.nomeReprodutor.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<InventarioSemenCaprino> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<InventarioSemenCaprino> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nomeReprodutor.toLowerCase().contains(query.toLowerCase())) {
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
                      pdfLib.Text('Control IF Goiano',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white)),
                      pdfLib.Text('control@institutofederal.com.br',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('(64) 3465-1900',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('Inventário Sêmen Caprino',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

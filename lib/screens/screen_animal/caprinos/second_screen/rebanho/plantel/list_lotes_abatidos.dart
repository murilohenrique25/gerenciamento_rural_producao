import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/caprino_abatido_db.dart';
import 'package:gerenciamento_rural/models/caprino_abatido.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPage.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class ListaAbatidosCaprino extends StatefulWidget {
  @override
  _ListaAbatidosCaprinoState createState() => _ListaAbatidosCaprinoState();
}

class _ListaAbatidosCaprinoState extends State<ListaAbatidosCaprino> {
  TextEditingController editingController = TextEditingController();
  CaprinoAbatidoDB helper = CaprinoAbatidoDB();
  List<CaprinoAbatido> items = [];
  List<CaprinoAbatido> abatidos = [];

  @override
  void initState() {
    super.initState();
    _getAllPotro();
    items = [];
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
        ],
        centerTitle: true,
        title: Text("Lotes Abatidos"),
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
                    labelText: "Buscar lote",
                    hintText: "Buscar lote",
                    prefix: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: abatidos.length,
                    itemBuilder: (context, index) {
                      return _totalPotroCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _totalPotroCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Nome: " + abatidos[index].nome ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  " - ",
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  "Peso: " + abatidos[index].peso.toString() ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  " - ",
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  "Data: " + abatidos[index].data ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  " - ",
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  "Tipo: " + abatidos[index].tipo ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _getAllPotro() {
    items = [];
    helper.getAllItems().then((list) {
      setState(() {
        abatidos = list;
        items.addAll(abatidos);
      });
    });
  }

  _creatPdf(context) async {
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Nome', 'Peso'],
                ...abatidos.map((item) => [item.nome, item.peso.toString()])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdf.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pdf.save());
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLeite(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        abatidos.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        abatidos.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  //filtrar resultado com o texto passado
  void filterSearchResults(String query) {
    List<CaprinoAbatido> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<CaprinoAbatido> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nome.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        abatidos.clear();
        abatidos.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        abatidos.clear();
        abatidos.addAll(items);
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
                      pdfLib.Text('Control IF Goiano',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white)),
                      pdfLib.Text('control@institutofederal.com.br',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('(64) 3465-1900',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('Potros',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

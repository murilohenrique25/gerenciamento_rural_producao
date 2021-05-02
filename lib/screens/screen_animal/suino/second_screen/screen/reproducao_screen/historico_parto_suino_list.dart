import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/historico_parto_suino_db.dart';
import 'package:gerenciamento_rural/models/historico_parto_suino.dart';
import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPage.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class ListaHistoricoPartoSuino extends StatefulWidget {
  @override
  _ListaHistoricoPartoSuinoState createState() =>
      _ListaHistoricoPartoSuinoState();
}

class _ListaHistoricoPartoSuinoState extends State<ListaHistoricoPartoSuino> {
  TextEditingController editingController = TextEditingController();
  HistoricoPartoSuinoDB helper = HistoricoPartoSuinoDB();
  List<HistoricoPartoSuino> items = [];
  List<HistoricoPartoSuino> historicos = [];
  List<HistoricoPartoSuino> tHistoricos = [];

  @override
  void initState() {
    super.initState();
    _getAllHistorico();
    items = [];
    tHistoricos = [];
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
        ],
        centerTitle: true,
        title: Text("Histórico de Partos"),
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
                    labelText: "Buscar por Matriz",
                    hintText: "Buscar por Matriz",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: historicos.length,
                  itemBuilder: (context, index) {
                    return _historicoCard(context, index);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _historicoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "Ninhada: " + historicos[index].nome ?? "",
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
                  "Matriz: " + historicos[index].mae ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Cachaço: " + historicos[index].pai ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Data: " + historicos[index].dataNascimento ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Quantidade: " + historicos[index].quantidade.toString() ??
                      "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Machos: " + historicos[index].sexoM.toString() ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Fêmeas: " + historicos[index].sexoF.toString() ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Vivos: " + historicos[index].vivos.toString() ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Mortos: " + historicos[index].mortos.toString() ?? "",
                  style: TextStyle(fontSize: 14.0),
                )
              ],
            ),
          ),
        ),
      ),
      onTap: () {},
    );
  }

  void _getAllHistorico() {
    items = [];
    helper.getAllItems().then((value) {
      setState(() {
        historicos = value;
        items.addAll(historicos);
      });
    });
  }

  _creatPdf(context) async {
    tHistoricos = historicos;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Ninhada',
                  'Cachaço',
                  'Matriz',
                  'Data',
                  'Quantidade',
                  'Machos',
                  'Fêmeas',
                  'Vivos',
                  'Mortos'
                ],
                ...tHistoricos.map((item) => [
                      item.nome,
                      item.mae,
                      item.pai,
                      item.dataNascimento,
                      item.quantidade.toString(),
                      item.sexoM.toString(),
                      item.sexoF.toString(),
                      item.vivos.toString(),
                      item.mortos.toString()
                    ])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfISS.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pdf.save());
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPage(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        historicos.sort((a, b) {
          return a.mae.toLowerCase().compareTo(b.mae.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        historicos.sort((a, b) {
          return b.mae.toLowerCase().compareTo(a.mae.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<HistoricoPartoSuino> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<HistoricoPartoSuino> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.mae.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        historicos.clear();
        historicos.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        historicos.clear();
        historicos.addAll(items);
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
                      pdfLib.Text('Histórico Parto Suíno',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

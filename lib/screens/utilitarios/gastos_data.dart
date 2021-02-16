import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/gasto.dart';
import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPageLote.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class GastosData extends StatefulWidget {
  final List<Gasto> gasto;
  final String datafinal;
  final String datainicial;
  GastosData({this.gasto, this.datainicial, this.datafinal});
  @override
  _GastosDataState createState() => _GastosDataState();
}

class _GastosDataState extends State<GastosData> {
  TextEditingController editingController = TextEditingController();
  List<Gasto> gastos = List();
  String dinicial = "";
  String dfinal = "";
  @override
  void initState() {
    super.initState();

    if (widget.gasto.isNotEmpty) {
      widget.gasto.forEach((element) {
        gastos.add(element);
      });
    }
    dinicial = widget.datainicial;
    dfinal = widget.datafinal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar Data(Crescente)"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar Data(Decrescente)"),
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
        title: Text("Gastos"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: gastos.length,
                  itemBuilder: (context, index) {
                    return _gastosCard(context, index);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _gastosCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.all(10.0),
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
                Text(
                  "Nome: " + gastos[index].nome ?? "",
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
                SizedBox(
                  width: 15,
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
    );
  }

  _creatPdf(context) async {
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Nome', 'Quantidade', 'Valor Unitário', 'Valor Total'],
                ...gastos.map((item) => [
                      item.nome,
                      item.quantidade.toString(),
                      item.valorUnitario.toString(),
                      item.valorTotal.toString()
                    ])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfTeste.pdf';
    final File file = File(path);
    file.writeAsBytesSync(pdf.save());
    print("$file");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLote(path: path)));
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
                      pdfLib.Text('Gastos entre $dinicial e $dfinal',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

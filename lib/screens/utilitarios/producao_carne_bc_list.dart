import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/corte_abatidos.dart';
import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPageLote.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class ProducaoCarneBcLista extends StatefulWidget {
  final List<CortesAbatidos> cortes;
  final String data;
  ProducaoCarneBcLista({this.cortes, this.data});
  @override
  _ProducaoCarneBcListaState createState() => _ProducaoCarneBcListaState();
}

class _ProducaoCarneBcListaState extends State<ProducaoCarneBcLista> {
  TextEditingController editingController = TextEditingController();
  List<CortesAbatidos> abatidos = [];
  double valorTotalFinal = 0.0;
  String ano;
  @override
  void initState() {
    super.initState();

    if (widget.cortes.isNotEmpty) {
      widget.cortes.forEach((element) {
        abatidos.add(element);
        print(abatidos);
      });
    }
    ano = widget.data;
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
        title: Text("Balanço"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: abatidos.length,
                  itemBuilder: (context, index) {
                    return _aCard(context, index);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _aCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "Quantidade Animais: " +
                          abatidos[index].quantidade.toString() ??
                      "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(" - "),
                Text(
                  "Categoria: " + abatidos[index].categoria ?? "",
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
                  "Total de @: " +
                          abatidos[index].pesoArroba.toStringAsFixed(2) ??
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
                  "Preço: " +
                          abatidos[index].precoKgArroba.toStringAsFixed(2) ??
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
                  "Preço Total: " +
                      calculaPreco(abatidos[index].precoKgArroba,
                              abatidos[index].pesoArroba)
                          .toStringAsFixed(2),
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
                  "Data: " + abatidos[index].data ?? "",
                  style: TextStyle(fontSize: 14.0),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calculaPreco(double valor, double quant) {
    double result = 0.0;
    result = valor * quant;
    valorTotalFinal += result;
    return result;
  }

  _creatPdf(context) async {
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        footer: _buildFooter,
        build: (context) => [
              pdfLib.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>[
                    'Quantidade Animais',
                    'Categoria',
                    'Total de @',
                    'Preço',
                    'Preço Total',
                    'Data',
                  ],
                  ...abatidos.map(
                    (item) => [
                      item.quantidade.toString(),
                      item.categoria,
                      item.pesoArroba.toString(),
                      item.precoKgArroba.toString(),
                      calculaPreco(item.pesoArroba, item.precoKgArroba)
                          .toString(),
                      item.data
                    ],
                  ),
                ],
              )
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdf.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pdf.save());
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLote(path: path)));
  }

  //retorna footer do pdf
  pdfLib.Widget _buildFooter(pdfLib.Context context) {
    return pdfLib.Container(
      color: PdfColors.green,
      height: 80,
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
                  pdfLib.Text(
                      'Total da Receita do ano($ano): ${valorTotalFinal.toStringAsFixed(2)}',
                      style: pdfLib.TextStyle(
                          fontSize: 18, color: PdfColors.white)),
                ],
              )
            ]),
      ),
    );
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        abatidos.sort((a, b) {
          return a.data.toLowerCase().compareTo(b.data.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        abatidos.sort((a, b) {
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
                      pdfLib.Text('Receita',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

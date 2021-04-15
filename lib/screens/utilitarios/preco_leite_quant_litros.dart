import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/models/leite.dart';

import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPageLote.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';

enum OrderOptions { orderaz, orderza }

class PrecoLeiteQuantLitros extends StatefulWidget {
  final List<Leite> leites;
  final double precoMes;
  final String mes;
  PrecoLeiteQuantLitros({this.leites, this.precoMes, this.mes});

  @override
  _PrecoLeiteQuantLitrosState createState() => _PrecoLeiteQuantLitrosState();
}

class _PrecoLeiteQuantLitrosState extends State<PrecoLeiteQuantLitros> {
  List<Leite> totalLeite = [];
  double quantLeite = 0.0;
  double precoTotal = 0.0;
  double resultado = 0.00;
  String resultadoS = "";
  String nomeMes;
  @override
  void initState() {
    super.initState();
    if (widget.leites.isNotEmpty) {
      widget.leites.forEach((element) {
        totalLeite.add(element);
        quantLeite += element.quantidade;
      });
    }
    if (!widget.precoMes.isNaN) {
      precoTotal = widget.precoMes;
    }
    if (widget.mes.isNotEmpty) {
      nomeMes = widget.mes;
    }
    resultado = quantLeite * precoTotal;
    resultadoS = resultado.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.picture_as_pdf),
              onPressed: () {
                _creatPdf(context);
              }),
        ],
        centerTitle: true,
        title: Text("Relatório Geral"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: totalLeite.length,
                  itemBuilder: (context, index) {
                    return _coletaCard(context, index);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _coletaCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "Data Coleta: " + totalLeite[index].dataColeta ?? "",
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
                  "Quantidade: " + totalLeite[index].quantidade.toString() ??
                      "",
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
        footer: _buildFooter,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Data', 'Quantidade'],
                ...totalLeite.map(
                    (item) => [item.dataColeta, item.quantidade.toString()])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfrelatoriaPreco.pdf';
    final File file = File(path);
    if (!await file.exists()) {
      await file.create(recursive: true);
      file.writeAsStringSync("pdf");
    }
    ShareExtend.share(file.path, "file");
    //file.writeAsBytesSync(pdf.save());
    print("$file");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLote(path: path)));
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
                  pdfLib.Text('Relatório do Mês $nomeMes',
                      style: pdfLib.TextStyle(
                          fontSize: 22, color: PdfColors.white))
                ],
              )
            ]),
      ),
    );
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
                  pdfLib.Text('Quantidade total de leite: $quantLeite L',
                      style: pdfLib.TextStyle(
                          fontSize: 18, color: PdfColors.white)),
                  pdfLib.Text('Preço por litro: $precoTotal',
                      style: pdfLib.TextStyle(
                          fontSize: 18, color: PdfColors.white)),
                  pdfLib.Text('Receita Total: $resultadoS',
                      style: pdfLib.TextStyle(
                          fontSize: 18, color: PdfColors.white)),
                ],
              )
            ]),
      ),
    );
  }
}

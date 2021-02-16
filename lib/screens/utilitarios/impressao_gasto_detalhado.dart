import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:share_extend/share_extend.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class ImpressaoGastoDetalhado extends StatefulWidget {
  final String path;
  ImpressaoGastoDetalhado({Key key, this.path}) : super(key: key);

  @override
  _ImpressaoGastoDetalhadoState createState() =>
      _ImpressaoGastoDetalhadoState();
}

class _ImpressaoGastoDetalhadoState extends State<ImpressaoGastoDetalhado> {
  PDFDocument _doc;
  bool _loading;
  @override
  void initState() {
    super.initState();
    _initPdf();
  }

  _initPdf() async {
    setState(() {
      _loading = true;
    });
    String path = await ExtStorage.getExternalStorageDirectory();
    String fullPath = "$path/example.pdf";
    File file = new File.fromUri(Uri.parse(fullPath));
    PDFDocument document = await PDFDocument.fromFile(file);
    //final doc = await PDFDocument.fromAsset(widget.path);
    setState(() {
      _doc = document;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
                iconSize: 30,
                onPressed: () {
                  ShareExtend.share('', "file",
                      sharePanelTitle: "Enviar PDF", subject: "example-pdf");
                },
              ),
            )
          ],
        ),
        body: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : PDFViewer(document: _doc));
  }
}

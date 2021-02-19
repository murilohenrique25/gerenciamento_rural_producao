import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:share_extend/share_extend.dart';

class PdfViwerPageMedicamento extends StatelessWidget {
  final String path;
  const PdfViwerPageMedicamento({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Relatório"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                ShareExtend.share(path, "file",
                    sharePanelTitle: "Enviar PDF", subject: "example-pdf");
              },
            ),
          ],
        ),
        path: path);
  }
}

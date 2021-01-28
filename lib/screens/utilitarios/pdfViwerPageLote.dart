import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PdfViwerPageLote extends StatelessWidget {
  final String path;
  const PdfViwerPageLote({Key key, this.path}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: PDFViewerScaffold(path: path),
    );
  }
}

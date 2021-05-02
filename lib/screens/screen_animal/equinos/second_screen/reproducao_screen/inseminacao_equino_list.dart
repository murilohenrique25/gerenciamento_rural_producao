import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/inseminacao_suina_db.dart';
import 'package:gerenciamento_rural/models/inseminacao_equino.dart';
import 'package:gerenciamento_rural/screens/screen_animal/equinos/second_screen/reproducao_screen/registers/cadastro_inseminacao_monta.dart';
import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPage.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class ListaInseminacaoEquino extends StatefulWidget {
  @override
  _ListaInseminacaoEquinoState createState() => _ListaInseminacaoEquinoState();
}

class _ListaInseminacaoEquinoState extends State<ListaInseminacaoEquino> {
  TextEditingController editingController = TextEditingController();
  InseminacaoSuinaDB helper = InseminacaoSuinaDB();
  List<InseminacaoEquino> items = [];
  List<InseminacaoEquino> inseminacoes = [];
  List<InseminacaoEquino> tInseminacoes = [];

  @override
  void initState() {
    super.initState();
    _getAllInventario();
    items = [];
    tInseminacoes = [];
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
        title: Text("Lista Inseminação Equinos"),
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
                    labelText: "Buscar Inseminação Cavalo",
                    hintText: "Buscar Inseminação Cavalo",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: inseminacoes.length,
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
                "Cavalo: " + inseminacoes[index].nomeCavalo ?? "",
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
                "Égua: " + inseminacoes[index].nomeEgua ?? "",
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
        inseminacoes = value;
        items.addAll(inseminacoes);
      });
    });
  }

  void _showPage({InseminacaoEquino inseminacao}) async {
    final recInventario = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroInseminacaoMontaEquino(
                  inseminacao: inseminacao,
                )));
    if (recInventario != null) {
      if (inseminacao != null) {
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
                          _showPage(inseminacao: inseminacoes[index]);
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
                          helper.delete(inseminacoes[index].id);
                          setState(() {
                            inseminacoes.removeAt(index);
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
    tInseminacoes = inseminacoes;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Cavalo', 'Égua'],
                ...tInseminacoes.map((item) => [item.nomeCavalo, item.nomeEgua])
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
        inseminacoes.sort((a, b) {
          return a.nomeCavalo
              .toLowerCase()
              .compareTo(b.nomeCavalo.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        inseminacoes.sort((a, b) {
          return b.nomeCavalo
              .toLowerCase()
              .compareTo(a.nomeCavalo.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<InseminacaoEquino> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<InseminacaoEquino> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nomeCavalo.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        inseminacoes.clear();
        inseminacoes.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        inseminacoes.clear();
        inseminacoes.addAll(items);
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
                      pdfLib.Text('Inseminação Suína',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

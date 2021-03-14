import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/inseminacao_db.dart';
import 'package:gerenciamento_rural/models/inseminacao.dart';
import 'package:gerenciamento_rural/screens/screen_animal/touros/second_screen/tree_screen/cadastrar_inseminacao.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class ListInseminacoes extends StatefulWidget {
  @override
  _ListInseminacoesState createState() => _ListInseminacoesState();
}

class _ListInseminacoesState extends State<ListInseminacoes> {
  TextEditingController editingController = TextEditingController();
  InseminacaoDB helper = InseminacaoDB();
  List<Inseminacao> items = List();
  List<Inseminacao> inseminacoes = List();
  List<Inseminacao> tinseminacoes = List();

  @override
  void initState() {
    super.initState();
    _getAllInseminacoes();
    items = List();
    tinseminacoes = List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por A-Z"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Z-A"),
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
                _showInseminacaoPage();
              }),
        ],
        centerTitle: true,
        title: Text("Inseminações"),
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
                    labelText: "Buscar Inseminação",
                    hintText: "Buscar Inseminação",
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
                    return _inseminacaoCard(context, index);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _inseminacaoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Text(
                "Animal: " + inseminacoes[index].nomeVaca ?? "",
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
                "Touro: " + inseminacoes[index].nomeTouro ?? "",
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
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showInseminacaoPage(
                              inseminacao: inseminacoes[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
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

  void _showInseminacaoPage({Inseminacao inseminacao}) async {
    final recInseminacoes = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroInseminacao(
                  inseminacao: inseminacao,
                )));
    if (recInseminacoes != null) {
      if (inseminacao != null) {
        await helper.updateItem(recInseminacoes);
      } else {
        await helper.insert(recInseminacoes);
      }
      _getAllInseminacoes();
    }
  }

  void _getAllInseminacoes() {
    items = List();
    helper.getAllItems().then((list) {
      setState(() {
        inseminacoes = list;
        items.addAll(inseminacoes);
      });
    });
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        inseminacoes.sort((a, b) {
          return a.nomeVaca.toLowerCase().compareTo(b.nomeVaca.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        inseminacoes.sort((a, b) {
          return b.nomeVaca.toLowerCase().compareTo(a.nomeVaca.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<Inseminacao> dummySearchList = List();
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<Inseminacao> dummyListData = List();
      dummySearchList.forEach((item) {
        if (item.nomeVaca.toLowerCase().contains(query.toLowerCase())) {
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

  _creatPdf(context) async {
    tinseminacoes = inseminacoes;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Nome Vaca', 'Nome Touro', 'Data', 'Inseminador'],
                ...tinseminacoes.map((item) => [
                      item.nomeVaca,
                      item.nomeTouro,
                      item.data,
                      item.inseminador
                    ])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfInseminacoes.pdf';
    final File file = File(path);
    file.writeAsBytesSync(pdf.save());
    print("$file");
    // Navigator.of(context)
    //     .push(MaterialPageRoute(builder: (_) => PdfViwerPageTouro(path: path)));
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
                      pdfLib.Text('Inseminações',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

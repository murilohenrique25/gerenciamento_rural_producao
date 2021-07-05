import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/novilha_corte_db.dart';
import 'package:gerenciamento_rural/models/novilha_corte.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPage.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/second_screen/rebanho/plantel/second_screen/registers/cadastro_novilha_corte.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

enum OrderOptions { orderaz, orderza }

class ListaNovilhaCorte extends StatefulWidget {
  @override
  _ListaNovilhaCorteState createState() => _ListaNovilhaCorteState();
}

class _ListaNovilhaCorteState extends State<ListaNovilhaCorte> {
  TextEditingController editingController = TextEditingController();
  NovilhaCorteDB helper = NovilhaCorteDB();
  List<NovilhaCorte> totalNovilhas = [];
  List<NovilhaCorte> items = [];
  List<NovilhaCorte> tnovilhas = [];
  @override
  void initState() {
    super.initState();
    _getAllNovilhas();
    items = [];
    tnovilhas = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Nome(Crescente)"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Nome(Decrescente)"),
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
                _showTotalNovilhasPage();
              }),
        ],
        centerTitle: true,
        title: Text("Novilhas da Propriedade"),
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
                    labelText: "Buscar Por Nome / Nº Brinco",
                    hintText: "Buscar Por Nome / Nº Brinco",
                    prefix: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: totalNovilhas.length,
                    itemBuilder: (context, index) {
                      return _totalNovilhasCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _totalNovilhasCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Nome / Nº Brinco: " + totalNovilhas[index].nome ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
              ],
            ),
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
                      child: ElevatedButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showTotalNovilhasPage(
                              totalNovilhas: totalNovilhas[index]);
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
                          try {
                            helper.delete(totalNovilhas[index].id);
                          } catch (e) {
                            Toast.show("$Exception($e)", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }

                          setState(() {
                            totalNovilhas.removeAt(index);
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

  void _showTotalNovilhasPage({NovilhaCorte totalNovilhas}) async {
    final recTotalNovilha = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroNovilhaCorte(
            novilha: totalNovilhas,
          ),
        ));
    if (recTotalNovilha != null) {
      if (totalNovilhas != null) {
        await helper.updateItem(recTotalNovilha);
      } else {
        await helper.insert(recTotalNovilha);
      }
      _getAllNovilhas();
    }
  }

  void _getAllNovilhas() {
    items = [];
    helper.getAllItems().then((list) {
      setState(() {
        totalNovilhas = list;
        items.addAll(totalNovilhas);
      });
    });
  }

  _creatPdf(context) async {
    tnovilhas = totalNovilhas;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Nome / Nº Brinco',
                  'Data Nascimento',
                  'Peso Nascimento',
                  'Ultima Inseminação',
                  'Parto Previsto',
                  'Secagem Prevista',
                  'Diagnóstico de Gestação',
                  'Pai',
                  'Mãe',
                  'Raça',
                  "Lote"
                ],
                ...tnovilhas.map((item) => [
                      item.nome,
                      item.dataNascimento,
                      item.ultimaInseminacao,
                      item.partoPrevisto,
                      item.secagemPrevista,
                      item.diagnosticoGestacao,
                      item.pai,
                      item.mae,
                      item.raca,
                      item.nomeLote
                    ])
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
        totalNovilhas.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        totalNovilhas.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  //filtrar resultado com o texto passado
  void filterSearchResults(String query) {
    List<NovilhaCorte> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<NovilhaCorte> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nome.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        totalNovilhas.clear();
        totalNovilhas.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        totalNovilhas.clear();
        totalNovilhas.addAll(items);
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
                      pdfLib.Text('Instituto Federal Goiano',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white)),
                      pdfLib.Text(
                          'Rodovia Geraldo Silva Nascimento Km 2,5, Rod. Gustavo Capanema,\nUrutaí - GO, 75790-000',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('(64) 3465-1900',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('Novilhas',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

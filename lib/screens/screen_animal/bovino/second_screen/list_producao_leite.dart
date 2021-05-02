import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/producao_leite_db.dart';
import 'package:gerenciamento_rural/models/leite.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/cadastro_leite.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPageleite.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

import 'package:toast/toast.dart';

enum OrderOptions { orderaz, orderza }

class ProducoesLeite extends StatefulWidget {
  @override
  _ProducoesLeiteState createState() => _ProducoesLeiteState();
}

class _ProducoesLeiteState extends State<ProducoesLeite> {
  TextEditingController editingController = TextEditingController();
  LeiteDB helper = LeiteDB();
  List<Leite> prodLeite = [];
  List<Leite> items = [];
  List<Leite> leites = [];
  List<Leite> tLeites = [];
  String _nomeMes = "Geral";
  @override
  void initState() {
    super.initState();
    _getAllProducaoLeites();
    items = [];
    tLeites = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Data(Crescente)"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Data(Decrescente)"),
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
                _showProducaoLeitePage();
              }),
        ],
        centerTitle: true,
        title: Text("Produção de Leite"),
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
                    labelText: "Buscar Por Mês",
                    hintText: "Buscar Por Mês",
                    prefix: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: prodLeite.length,
                    itemBuilder: (context, index) {
                      return _producaoLeiteCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _producaoLeiteCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Data: " + prodLeite[index].dataColeta,
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Quant.: " + prodLeite[index].quantidade.toString(),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Gord.: " + prodLeite[index].gordura.toString(),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Prot.: " + prodLeite[index].proteina.toString(),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Lact.: " + prodLeite[index].lactose.toString(),
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 2,
                ),
                Text(" - "),
                SizedBox(
                  width: 2,
                ),
                Text(
                  "Ur.: " + prodLeite[index].ureia.toString(),
                  style: TextStyle(fontSize: 14.0),
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
                          _showProducaoLeitePage(
                              producaoLeite: prodLeite[index]);
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
                            helper.delete(prodLeite[index].id);
                          } catch (e) {
                            Toast.show("$Exception($e)", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }

                          setState(() {
                            prodLeite.removeAt(index);
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

  void _showProducaoLeitePage({Leite producaoLeite}) async {
    final recProducaoLeite = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroLeite(
                  producaoLeite: producaoLeite,
                )));
    if (recProducaoLeite != null) {
      if (producaoLeite != null) {
        await helper.updateItem(recProducaoLeite);
      } else {
        await helper.insert(recProducaoLeite);
      }
      _getAllProducaoLeites();
    }
  }

  void verificaMes(int mes) {
    prodLeite.forEach((element) {
      if (element.idMes == mes) {
        print(element);
      }
    });
  }

  void _getAllProducaoLeites() {
    items = [];
    helper.getAllItems().then((list) {
      setState(() {
        prodLeite = list;
        items.addAll(prodLeite);
      });
    });
  }

  _creatPdf(context) async {
    tLeites = prodLeite;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        footer: _buildPrice,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Data Coleta',
                  'Quant. Leite',
                  'Gordura %',
                  'Proteina %',
                  'Lactose',
                  'Ureia %',
                  "CCS %",
                  "CBT %"
                ],
                ...tLeites.map((item) => [
                      item.dataColeta,
                      item.quantidade.toString(),
                      item.gordura.toString(),
                      item.proteina.toString(),
                      item.lactose.toString(),
                      item.ureia.toString(),
                      item.ccs.toString(),
                      item.cbt.toString()
                    ])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfListaLeite.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pdf.save());
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLeite(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        prodLeite.sort((a, b) {
          return a.dataColeta.compareTo(b.dataColeta);
        });
        break;
      case OrderOptions.orderza:
        prodLeite.sort((a, b) {
          return b.dataColeta.compareTo(a.dataColeta);
        });
        break;
    }
    setState(() {});
  }

  //filtrar resultado com o texto passado
  void filterSearchResults(String query) {
    String queryCase = query.toLowerCase();
    int numero;
    switch (queryCase) {
      case "janeiro":
        numero = 0;
        _nomeMes = "Janeiro";
        break;
      case "fevereiro":
        numero = 1;
        _nomeMes = "Fevereiro";
        break;
      case "março":
        numero = 5;
        _nomeMes = "Março";
        break;
      case "abril":
        numero = 3;
        _nomeMes = "Abril";
        break;
      case "maio":
        numero = 4;
        _nomeMes = "Maio";
        break;
      case "junho":
        numero = 5;
        _nomeMes = "Junho";
        break;
      case "julho":
        numero = 6;
        _nomeMes = "Julho";
        break;
      case "agosto":
        numero = 7;
        _nomeMes = "Agosto";
        break;
      case "setembro":
        numero = 8;
        _nomeMes = "Setembro";
        break;
      case "outrubro":
        numero = 9;
        _nomeMes = "Outubro";
        break;
      case "novembro":
        numero = 10;
        _nomeMes = "Novembro";
        break;
      case "dezembro":
        numero = 11;
        _nomeMes = "Dezembro";
        break;
      default:
        _nomeMes = "Geral";
    }
    List<Leite> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<Leite> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.idMes == numero) {
          dummyListData.add(item);
        }
      });
      setState(() {
        prodLeite.clear();
        prodLeite.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        prodLeite.clear();
        prodLeite.addAll(items);
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
                      pdfLib.Text('Coletas de Leite' + " $_nomeMes",
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }

  //retorna footer do pdf
  pdfLib.Widget _buildPrice(pdfLib.Context context) {
    return pdfLib.Container(
      color: PdfColors.green,
      height: 150,
      child: pdfLib.Row(
          crossAxisAlignment: pdfLib.CrossAxisAlignment.center,
          mainAxisAlignment: pdfLib.MainAxisAlignment.spaceBetween,
          children: [
            pdfLib.Row(children: [
              pdfLib.Padding(
                  padding: pdfLib.EdgeInsets.all(10.0),
                  child: pdfLib.Text(
                      'Quant. Total:' +
                          somaQuantidade().toString() +
                          " | Média Dia:" +
                          mediaQuantidade().toString() +
                          " | Média Gordura: " +
                          mediaGordura().toString() +
                          " | Média Proteína:" +
                          mediaProteina().toString(),
                      style: pdfLib.TextStyle(color: PdfColors.white))),
              pdfLib.Text(
                  "Média Lactose: " +
                      mediaLactose().toString() +
                      " | Média Ureia: " +
                      mediaUreia().toString() +
                      " | Média CCS: " +
                      mediaCCS().toString() +
                      " | Média CBT: " +
                      mediaCBT().toString(),
                  style: pdfLib.TextStyle(color: PdfColors.white))
            ]),
          ]),
    );
  }

  double somaQuantidade() {
    double total = 0;
    prodLeite.forEach((element) {
      total += element.quantidade;
    });
    return total;
  }

  double mediaQuantidade() {
    return somaQuantidade() / prodLeite.length;
  }

  double somaGordura() {
    double total = 0;
    prodLeite.forEach((element) {
      total += element.gordura;
    });
    return total;
  }

  double mediaGordura() {
    return somaGordura() / prodLeite.length;
  }

  double somaProteina() {
    double total = 0;
    prodLeite.forEach((element) {
      total += element.proteina;
    });
    return total;
  }

  double mediaProteina() {
    return somaProteina() / prodLeite.length;
  }

  double somaLactose() {
    double total = 0;
    prodLeite.forEach((element) {
      total += element.lactose;
    });
    return total;
  }

  double mediaLactose() {
    return somaLactose() / prodLeite.length;
  }

  double somaUreia() {
    double total = 0;
    prodLeite.forEach((element) {
      total += element.ureia;
    });
    return total;
  }

  double mediaUreia() {
    return somaUreia() / prodLeite.length;
  }

  double somaCCS() {
    double total = 0;
    prodLeite.forEach((element) {
      total += element.ccs;
    });
    return total;
  }

  double mediaCCS() {
    return somaCCS() / prodLeite.length;
  }

  double somaCBT() {
    double total = 0;
    prodLeite.forEach((element) {
      total += element.cbt;
    });
    return total;
  }

  double mediaCBT() {
    return somaCBT() / prodLeite.length;
  }
}

import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/terminacao_db.dart';
import 'package:gerenciamento_rural/models/terminacao.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPage.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/tree_screen/for_screen/registers/cadastro_terminacao.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

import 'package:toast/toast.dart';

enum OrderOptions { orderaz, orderza }

class ListaTermincao extends StatefulWidget {
  @override
  _ListaTermincaoState createState() => _ListaTermincaoState();
}

class _ListaTermincaoState extends State<ListaTermincao> {
  TextEditingController editingController = TextEditingController();
  TerminacaoDB helper = TerminacaoDB();
  List<Terminacao> items = [];
  List<Terminacao> terminacoes = [];
  List<Terminacao> tTerminacoes = [];
  @override
  void initState() {
    super.initState();
    _getAllTerminacao();
    items = [];
    tTerminacoes = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Ninhada(Crescente)"),
                value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar por Ninhada(Decrescente)"),
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
                _showTotalTerminacoesPage();
              }),
        ],
        centerTitle: true,
        title: Text("Terminação"),
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
                    labelText: "Buscar Ninhada",
                    hintText: "Buscar Por Ninhada",
                    prefix: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: terminacoes.length,
                    itemBuilder: (context, index) {
                      return _totalTerminacaoCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _totalTerminacaoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Nome da Ninhada: " + terminacoes[index].nome ?? "",
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
                          _showTotalTerminacoesPage(
                              terminacao: terminacoes[index]);
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
                            helper.delete(terminacoes[index].id);
                          } catch (e) {
                            Toast.show("$Exception($e)", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }

                          setState(() {
                            terminacoes.removeAt(index);
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

  void _showTotalTerminacoesPage({Terminacao terminacao}) async {
    final recCachaco = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroTerminacao(
            terminacao: terminacao,
          ),
        ));
    if (recCachaco != null) {
      if (terminacao != null) {
        await helper.updateItem(recCachaco);
      } else {
        await helper.insert(recCachaco);
      }
      _getAllTerminacao();
    }
  }

  void _getAllTerminacao() {
    items = [];
    helper.getAllItems().then((list) {
      setState(() {
        terminacoes = list;
        items.addAll(terminacoes);
      });
    });
  }

  _creatPdf(context) async {
    tTerminacoes = terminacoes;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Ninhada',
                  'Data Nascimento',
                  'Data Abate',
                  'Peso Abate',
                  'Peso Médio'
                      'Quantiade',
                  'Estado',
                  'Lote',
                  'Identificação',
                  'Vivos',
                  'Mortos',
                  'Raça',
                  'Pai',
                  'Mãe',
                  'Machos',
                  'Fêmeas',
                  'Baia',
                  'Peso Nascimento',
                  'Peso Desmama',
                  'Data Desmama',
                  'Observação'
                ],
                ...terminacoes.map((item) => [
                      item.nome,
                      item.dataNascimento,
                      item.dataAbate,
                      item.pesoAbate.toString(),
                      item.pesoMedio.toString(),
                      item.quantidade.toString(),
                      item.estado,
                      item.lote,
                      item.identificacao,
                      item.vivos,
                      item.mortos,
                      item.raca,
                      item.pai,
                      item.mae,
                      item.sexoM,
                      item.sexoF,
                      item.baia,
                      item.pesoNascimento,
                      item.pesoDesmama,
                      item.dataDesmama,
                      item.observacao
                    ])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfTerminação.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pdf.save());
    print("$file");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLeite(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        terminacoes.sort((a, b) {
          return a.nomeAnimal
              .toLowerCase()
              .compareTo(b.nomeAnimal.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        terminacoes.sort((a, b) {
          return b.nomeAnimal
              .toLowerCase()
              .compareTo(a.nomeAnimal.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  //filtrar resultado com o texto passado
  void filterSearchResults(String query) {
    List<Terminacao> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<Terminacao> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nomeAnimal.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        terminacoes.clear();
        terminacoes.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        terminacoes.clear();
        terminacoes.addAll(items);
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
                      pdfLib.Text('Control IF Goiano',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white)),
                      pdfLib.Text('control@institutofederal.com.br',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('(64) 3465-1900',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('Terminações',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

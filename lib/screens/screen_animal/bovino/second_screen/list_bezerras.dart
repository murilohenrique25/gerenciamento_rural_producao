import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/bezerra_db.dart';
import 'package:gerenciamento_rural/helpers/novilha_db.dart';
import 'package:gerenciamento_rural/models/bezerra.dart';
import 'package:gerenciamento_rural/models/novilha.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/cadastro_bezerra.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPageleite.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:toast/toast.dart';

enum OrderOptions { orderaz, orderza }

class ListaBezerras extends StatefulWidget {
  @override
  _ListaBezerrasState createState() => _ListaBezerrasState();
}

class _ListaBezerrasState extends State<ListaBezerras> {
  TextEditingController editingController = TextEditingController();
  BezerraDB helper = BezerraDB();
  NovilhaDB helperNovilha = NovilhaDB();
  List<Bezerra> totalBezerras = [];
  List<Bezerra> items = [];
  List<Bezerra> bezerras = [];
  List<Bezerra> tbezerras = [];
  @override
  void initState() {
    super.initState();
    _getAllBezerras();
    items = [];
    tbezerras = [];
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
                _showTotalBezerrasPage();
              }),
        ],
        centerTitle: true,
        title: Text("Bezerras da Propriedade"),
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
                    itemCount: totalBezerras.length,
                    itemBuilder: (context, index) {
                      return _totalBezerrasCard(context, index);
                    }))
          ],
        ),
      ),
    );
  }

  Widget _totalBezerrasCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  "Nome / Nº Brinco: " + totalBezerras[index].nome,
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
                          _showTotalBezerrasPage(
                              totalBezerras: totalBezerras[index]);
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
                            helper.delete(totalBezerras[index].idBezerra);
                          } catch (e) {
                            Toast.show("$Exception($e)", context,
                                duration: Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }

                          setState(() {
                            totalBezerras.removeAt(index);
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

  void _showTotalBezerrasPage({Bezerra totalBezerras}) async {
    final recTotalBezerras = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroBezerra(
            bezerra: totalBezerras,
          ),
        ));
    if (recTotalBezerras != null) {
      if (totalBezerras != null) {
        await helper.updateItem(recTotalBezerras);
      } else {
        await helper.insert(recTotalBezerras);
      }
      _getAllBezerras();
    }
  }

  void _getAllBezerras() {
    totalBezerras = [];
    items = [];
    List<Bezerra> verificaBezerra = [];
    List<Bezerra> verificaVN = [];
    Novilha novilha = Novilha();
    helper.getAllItems().then((list) {
      setState(() {
        verificaBezerra = list;
        String num = "";
        DateTime dt = DateTime.now();
        verificaBezerra.forEach((element) {
          if (element.dataNascimento.isNotEmpty) {
            num = element.dataNascimento.split('-').reversed.join();
            DateTime date = DateTime.parse(num);
            int quant = dt.difference(date).inDays;
            if (quant >= 120) {
              novilha.pesoDesmama = element.pesoDesmama;
              novilha.pesoNascimento = element.pesoNascimento;
              novilha.nome = element.nome;
              novilha.dataNascimento = element.dataNascimento;
              novilha.diagnosticoGestacao = "Vazia";
              novilha.virouVaca = 0;
              novilha.avoFMaterno = element.avoFMaterno;
              novilha.avoMMaterno = element.avoMMaterno;
              novilha.avoMPaterno = element.avoMPaterno;
              novilha.avoFPaterno = element.avoFPaterno;
              element.virouNovilha = 1;
              helper.updateItem(element);
              helperNovilha.insert(novilha);
            }
          }
        });
        verificaVN = verificaBezerra;
        verificaVN.forEach((element) {
          if (element.virouNovilha == 0) {
            totalBezerras.add(element);
          }
        });

        items.addAll(totalBezerras);
      });
    });
  }

  _creatPdf(context) async {
    tbezerras = totalBezerras;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Nome / Nº Brinco',
                  'Última Inseminação',
                  'Raça',
                  'Estado',
                  "Lote"
                ],
                ...tbezerras.map((item) =>
                    [item.nome, item.raca, item.estado, item.idLote.toString()])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfBezerras.pdf';
    final File file = File(path);
    if (!await file.exists()) {
      await file.create(recursive: true);
      file.writeAsStringSync("pdf");
    }
    ShareExtend.share(file.path, "file");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPageLeite(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        totalBezerras.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        totalBezerras.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  //filtrar resultado com o texto passado
  void filterSearchResults(String query) {
    List<Bezerra> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<Bezerra> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nome.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        totalBezerras.clear();
        totalBezerras.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        totalBezerras.clear();
        totalBezerras.addAll(items);
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
                      pdfLib.Text('Bezerras',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

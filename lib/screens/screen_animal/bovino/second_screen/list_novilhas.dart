import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/novilha_db.dart';
import 'package:gerenciamento_rural/helpers/vaca_db.dart';
import 'package:gerenciamento_rural/models/novilha.dart';
import 'package:gerenciamento_rural/models/vaca.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/cadastro_novilha.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino/second_screen/tree_screen/pdf_screen/pdfViwerPage.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

import 'package:toast/toast.dart';

enum OrderOptions { orderaz, orderza }

class ListaNovilhas extends StatefulWidget {
  @override
  _ListaNovilhasState createState() => _ListaNovilhasState();
}

class _ListaNovilhasState extends State<ListaNovilhas> {
  TextEditingController editingController = TextEditingController();
  NovilhaDB helper = NovilhaDB();
  VacaDB helperVaca = VacaDB();
  List<Novilha> totalNovilhas = [];
  List<Novilha> items = [];
  List<Novilha> novilhas = [];
  List<Novilha> tnovilhas = [];
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
                  "Nome / Nº Brinco: " + totalNovilhas[index].nome,
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
                            helper.delete(totalNovilhas[index].idNovilha);
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

  void _showTotalNovilhasPage({Novilha totalNovilhas}) async {
    final recTotalNovilhas = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CadastroNovilha(
            novilha: totalNovilhas,
          ),
        ));
    if (recTotalNovilhas != null) {
      if (totalNovilhas != null) {
        await helper.updateItem(recTotalNovilhas);
      } else {
        await helper.insert(recTotalNovilhas);
      }
      _getAllNovilhas();
    }
  }

  void _getAllNovilhas() {
    items = [];
    totalNovilhas = [];
    List<Novilha> verificaNovilha = [];
    List<Novilha> verificaNv = [];
    Vaca vaca = Vaca();

    helper.getAllItems().then((list) {
      setState(() {
        verificaNovilha = list;
        verificaNovilha.forEach((element) {
          if (element.diagnosticoGestacao == "Gestante" ||
              element.diagnosticoGestacao == "Aborto") {
            String num = element.dataCobertura.split('-').reversed.join();
            DateTime dates = DateTime.parse(num);
            DateTime dateParto = dates.add(new Duration(days: 284));
            DateTime dateSecagem = dates.add(new Duration(days: 222));
            var format = new DateFormat("dd-MM-yyyy");
            String dataParto = format.format(dateParto);
            String dataSecagem = format.format(dateSecagem);
            //Criando vaca se a novilha for inseminada
            vaca.nome = element.nome;
            vaca.diagnosticoGestacao = element.diagnosticoGestacao;
            vaca.idLote = element.idLote;
            vaca.raca = element.raca;
            vaca.dataNascimento = element.dataNascimento;
            vaca.partoPrevisto = dataParto;
            vaca.secagemPrevista = dataSecagem;
            vaca.avoFMaterno = element.avoFMaterno;
            vaca.avoFPaterno = element.avoFPaterno;
            vaca.avoMMaterno = element.avoMMaterno;
            vaca.avoMPaterno = element.avoMPaterno;
            helperVaca.insert(vaca);
            element.virouVaca = 1;
            helper.updateItem(element);
          }
        });
        verificaNv = verificaNovilha;
        verificaNv.forEach((element) {
          if (element.virouVaca == 0) {
            totalNovilhas.add(element);
          }
        });

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
                  'Peso Desmama',
                  'Data Desmama',
                  'Data Cobertura',
                  'Peso 1º Cobertura',
                  'Idade 1º Cobertura',
                  'Idade 1º Parto',
                  'Diagnostico Gestação'
                      'Pai',
                  'Mãe',
                  'Avó Materno',
                  'Avô Materno',
                  'Avó Paterno',
                  'Avô Paterno',
                  'Raça',
                  'Estado',
                  "Lote"
                ],
                ...tnovilhas.map((item) => [
                      item.nome,
                      item.dataNascimento,
                      item.pesoDesmama.toString(),
                      item.dataDesmama,
                      item.dataCobertura,
                      item.pesoPrimeiraCobertura.toString(),
                      item.idadePrimeiraCobertura.toString(),
                      item.idadePrimeiraCobertura.toString(),
                      item.diagnosticoGestacao,
                      item.pai,
                      item.mae,
                      item.avoFMaterno,
                      item.avoMMaterno,
                      item.avoFPaterno,
                      item.avoMPaterno,
                      item.raca,
                      item.estado,
                      item.idLote.toString()
                    ])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfNovilhas.pdf';
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
    List<Novilha> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<Novilha> dummyListData = [];
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
                      pdfLib.Text('Control IF Goiano',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white)),
                      pdfLib.Text('control@institutofederal.com.br',
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

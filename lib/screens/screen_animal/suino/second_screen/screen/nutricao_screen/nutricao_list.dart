import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/nutricao_suina_db.dart';
import 'package:gerenciamento_rural/models/nutricao_suina.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/nutricao_screen/registers/cadastro_nutricao_suino.dart';
import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPage.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class ListaNutricaoSuina extends StatefulWidget {
  @override
  _ListaNutricaoSuinaState createState() => _ListaNutricaoSuinaState();
}

class _ListaNutricaoSuinaState extends State<ListaNutricaoSuina> {
  TextEditingController editingController = TextEditingController();
  NutricaoSuinaDB helper = NutricaoSuinaDB();
  List<NutricaoSuina> items = [];
  List<NutricaoSuina> nutricoes = [];
  List<NutricaoSuina> tNutricoes = [];

  @override
  void initState() {
    super.initState();
    _getAllNutricao();
    items = [];
    tNutricoes = [];
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
                _showNutricaoPage();
              }),
        ],
        centerTitle: true,
        title: Text("Nutrição"),
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
                    labelText: "Buscar Nutrição Por Fase",
                    hintText: "Buscar Nutrição Por Fase",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: nutricoes.length,
                  itemBuilder: (context, index) {
                    return _medicamentoCard(context, index);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _medicamentoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Text(
                "Lote: " + nutricoes[index].nomeLote ?? "",
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
                "Fase: " + nutricoes[index].fase ?? "",
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

  void _getAllNutricao() {
    items = [];
    helper.getAllItems().then((value) {
      setState(() {
        nutricoes = value;
        items.addAll(nutricoes);
      });
    });
  }

  void _showNutricaoPage({NutricaoSuina nutricao}) async {
    final recMedicamento = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroNutricaoSuino(
                  nutricaoSuina: nutricao,
                )));
    if (recMedicamento != null) {
      if (nutricao != null) {
        await helper.updateItem(recMedicamento);
      } else {
        await helper.insert(recMedicamento);
      }
      _getAllNutricao();
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
                          _showNutricaoPage(nutricao: nutricoes[index]);
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
                          helper.delete(nutricoes[index].id);
                          setState(() {
                            nutricoes.removeAt(index);
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
    tNutricoes = nutricoes;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Lote',
                  'Fase',
                  'Ingredientes',
                  'Baia',
                  'Quant. Individual',
                  'Quant. Total',
                  'PB',
                  'NDT',
                  'ED',
                  'Quantidade de Animais',
                  'Data'
                ],
                ...tNutricoes.map((item) => [
                      item.nomeLote,
                      item.fase,
                      item.ingredientes,
                      item.baia,
                      item.quantidadeInd.toString(),
                      item.quantidadeTotal.toString(),
                      item.pb.toString(),
                      item.ndt.toString(),
                      item.ed.toString(),
                      item.quantidadeAnimais.toString(),
                      item.data,
                    ])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfLotes.pdf';
    final File file = File(path);
    file.writeAsBytesSync(await pdf.save());
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPage(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        nutricoes.sort((a, b) {
          return a.fase.toLowerCase().compareTo(b.fase.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        nutricoes.sort((a, b) {
          return b.fase.toLowerCase().compareTo(a.fase.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<NutricaoSuina> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<NutricaoSuina> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.fase.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        nutricoes.clear();
        nutricoes.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        nutricoes.clear();
        nutricoes.addAll(items);
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
                      pdfLib.Text('Control IF Goiano',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white)),
                      pdfLib.Text('control@institutofederal.com.br',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('(64) 3465-1900',
                          style: pdfLib.TextStyle(color: PdfColors.white)),
                      pdfLib.Text('Nutrição Suína',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

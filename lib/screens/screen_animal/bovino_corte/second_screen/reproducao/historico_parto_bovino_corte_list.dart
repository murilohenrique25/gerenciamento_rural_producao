import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/registro_parto_caprino_db.dart';
import 'package:gerenciamento_rural/models/registro_partos_caprinos.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/second_screen/reproducao/registers/cadastro_historico_parto.dart';
import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPage.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class ListaHistoricoPartoBovinoCorte extends StatefulWidget {
  @override
  _ListaHistoricoPartoBovinoCorteState createState() =>
      _ListaHistoricoPartoBovinoCorteState();
}

class _ListaHistoricoPartoBovinoCorteState
    extends State<ListaHistoricoPartoBovinoCorte> {
  TextEditingController editingController = TextEditingController();
  RegistroPartoCaprinoDB helper = RegistroPartoCaprinoDB();
  List<RegistroPartoCaprino> items = [];
  List<RegistroPartoCaprino> historicos = [];
  List<RegistroPartoCaprino> tHistoricos = [];

  @override
  void initState() {
    super.initState();
    _getAllHistorico();
    items = [];
    tHistoricos = [];
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
        title: Text("Histórico de Partos"),
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
                    labelText: "Buscar por Matriz",
                    hintText: "Buscar por Matriz",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: historicos.length,
                  itemBuilder: (context, index) {
                    return _historicoCard(context, index);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _historicoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "Matriz: " + historicos[index].nomeMatriz ?? "",
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
                  "Pai: " + historicos[index].nomeReprodutor ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Quantidade: " + historicos[index].quantidade.toString() ??
                      "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Data: " + historicos[index].data ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Quantidade Machos: " +
                          historicos[index].quantMachos.toString() ??
                      "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Quantidade Fêmeas: " +
                          historicos[index].quantFemeas.toString() ??
                      "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Problemas: " + historicos[index].problema.toString() ?? "",
                  style: TextStyle(fontSize: 14.0),
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Tipo: " + historicos[index].tipoInseminacao ?? "",
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

  void _getAllHistorico() {
    items = [];
    helper.getAllItems().then((value) {
      setState(() {
        historicos = value;
        items.addAll(historicos);
      });
    });
  }

  void _showPage({RegistroPartoCaprino registroPartoCaprino}) async {
    final recRegistro = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroHistoricoPartoBovinoCorte(
                  registroPartoCaprino: registroPartoCaprino,
                )));
    if (recRegistro != null) {
      if (registroPartoCaprino != null) {
        await helper.updateItem(recRegistro);
      } else {
        await helper.insert(recRegistro);
      }
      _getAllRegistros();
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
                          _showPage(registroPartoCaprino: historicos[index]);
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
                          helper.delete(historicos[index].id);
                          setState(() {
                            historicos.removeAt(index);
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

  void _getAllRegistros() {
    items = [];
    helper.getAllItems().then((value) {
      setState(() {
        historicos = value;
        items.addAll(historicos);
      });
    });
  }

  _creatPdf(context) async {
    tHistoricos = historicos;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Matriz',
                  'Reprodutor',
                  'Data',
                  'Quantidade',
                  'Quantidade Machos',
                  'Quantidade Fêmeas',
                  'Problemas',
                  'Tipo'
                ],
                ...tHistoricos.map((item) => [
                      item.nomeMatriz,
                      item.nomeReprodutor,
                      item.data,
                      item.quantidade.toString(),
                      item.quantMachos.toString(),
                      item.quantFemeas.toString(),
                      item.problema,
                      item.tipoInseminacao
                    ])
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
        historicos.sort((a, b) {
          return a.nomeMatriz
              .toLowerCase()
              .compareTo(b.nomeMatriz.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        historicos.sort((a, b) {
          return b.nomeMatriz
              .toLowerCase()
              .compareTo(a.nomeMatriz.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<RegistroPartoCaprino> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<RegistroPartoCaprino> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nomeMatriz.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        historicos.clear();
        historicos.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        historicos.clear();
        historicos.addAll(items);
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
                      pdfLib.Text('Histórico Parto Caprinos',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

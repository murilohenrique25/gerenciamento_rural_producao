import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/tratamento_db.dart';
import 'package:gerenciamento_rural/models/tratamento.dart';
import 'package:gerenciamento_rural/screens/screen_animal/touros/second_screen/medicamentos/cadastrar_tratamento.dart';
import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPage.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class TratamentoList extends StatefulWidget {
  @override
  _TratamentoListState createState() => _TratamentoListState();
}

class _TratamentoListState extends State<TratamentoList> {
  TextEditingController editingController = TextEditingController();
  TratamentoDB helper = TratamentoDB();
  List<Tratamento> items = List();
  List<Tratamento> tratamentos = List();
  List<Tratamento> tTratamentos = List();

  @override
  void initState() {
    super.initState();
    _getAllTratamentos();
    items = List();
    tTratamentos = List();
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
                _showTratamentoPage();
              }),
        ],
        centerTitle: true,
        title: Text("Tratamentos"),
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
                    labelText: "Buscar Tratamento",
                    hintText: "Buscar Tratamento",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: tratamentos.length,
                  itemBuilder: (context, index) {
                    return _tratamentoCard(context, index);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _tratamentoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Text(
                "Nome: " + tratamentos[index].nomeMedicamento ?? "",
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
                "Animal: " + tratamentos[index].nomeAnimal ?? "",
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

  void _getAllTratamentos() {
    items = List();
    helper.getAllItems().then((value) {
      setState(() {
        tratamentos = value;
        items.addAll(tratamentos);
      });
    });
  }

  void _showTratamentoPage({Tratamento tratamento}) async {
    final recTratamento = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroTratamento(
                  tratamento: tratamento,
                )));
    if (recTratamento != null) {
      if (tratamento != null) {
        await helper.updateItem(recTratamento);
      } else {
        await helper.insert(recTratamento);
      }
      _getAllTratamentos();
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
                      child: FlatButton(
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showTratamentoPage(tratamento: tratamentos[index]);
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
                          helper.delete(tratamentos[index].id);
                          setState(() {
                            tratamentos.removeAt(index);
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
    tTratamentos = tratamentos;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>['Nome', 'Animal'],
                ...tTratamentos
                    .map((item) => [item.nomeMedicamento, item.nomeAnimal])
              ])
            ]));

    final String dir = (await getApplicationDocumentsDirectory()).path;

    final String path = '$dir/pdfTratamento.pdf';
    final File file = File(path);
    file.writeAsBytesSync(pdf.save());
    print("$file");
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PdfViwerPage(path: path)));
  }

  void _orderList(OrderOptions result) {
    switch (result) {
      case OrderOptions.orderaz:
        tratamentos.sort((a, b) {
          return a.nomeMedicamento
              .toLowerCase()
              .compareTo(b.nomeMedicamento.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        tratamentos.sort((a, b) {
          return b.nomeMedicamento
              .toLowerCase()
              .compareTo(a.nomeMedicamento.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<Tratamento> dummySearchList = List();
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<Tratamento> dummyListData = List();
      dummySearchList.forEach((item) {
        if (item.nomeMedicamento.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        tratamentos.clear();
        tratamentos.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        tratamentos.clear();
        tratamentos.addAll(items);
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
                      pdfLib.Text('Tratamentos',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

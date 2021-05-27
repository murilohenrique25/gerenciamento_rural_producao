import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/helpers/medicamento_caprino_db.dart';
import 'package:gerenciamento_rural/models/medicamento.dart';
import 'package:gerenciamento_rural/screens/screen_animal/caprinos/second_screen/medicamento/registers/cadastrar_medicamentos.dart';
import 'package:gerenciamento_rural/screens/utilitarios/pdfViwerPage.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:path_provider/path_provider.dart';

enum OrderOptions { orderaz, orderza }

class MedicamentosCaprinoList extends StatefulWidget {
  @override
  _MedicamentosCaprinoListState createState() =>
      _MedicamentosCaprinoListState();
}

class _MedicamentosCaprinoListState extends State<MedicamentosCaprinoList> {
  TextEditingController editingController = TextEditingController();
  MedicamentoCaprinoDB helper = MedicamentoCaprinoDB();
  List<Medicamento> items = [];
  List<Medicamento> medicamentos = [];
  List<Medicamento> tMedicamentos = [];

  @override
  void initState() {
    super.initState();
    _getAllMedicamentos();
    items = [];
    tMedicamentos = [];
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
                _showMedicamentoPage();
              }),
        ],
        centerTitle: true,
        title: Text("Medicamentos"),
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
                    labelText: "Buscar Medicamento",
                    hintText: "Buscar Medicamento",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: medicamentos.length,
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
                "Nome: " + medicamentos[index].nomeMedicamento ?? "",
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
                "Quantidade: " + medicamentos[index].quantidade.toString() ??
                    "",
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

  void _getAllMedicamentos() {
    items = [];
    helper.getAllItems().then((value) {
      setState(() {
        medicamentos = value;
        items.addAll(medicamentos);
      });
    });
  }

  void _showMedicamentoPage({Medicamento medicamento}) async {
    final recMedicamento = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CadastroMedicamentoCaprino(
                  medicamento: medicamento,
                )));
    if (recMedicamento != null) {
      if (medicamento != null) {
        await helper.updateItem(recMedicamento);
      } else {
        await helper.insert(recMedicamento);
      }
      _getAllMedicamentos();
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
                          _showMedicamentoPage(
                              medicamento: medicamentos[index]);
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
                          helper.delete(medicamentos[index].id);
                          setState(() {
                            medicamentos.removeAt(index);
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
    tMedicamentos = medicamentos;
    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);
    pdf.addPage(pdfLib.MultiPage(
        header: _buildHeade,
        build: (context) => [
              pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
                <String>[
                  'Nome',
                  'Quantidade',
                  'Preço Unit.',
                  'Preço Total',
                  'Tempo Descarte',
                  'Tipo Dosagem',
                  'Carência Medicamento',
                  'Data Vencimento',
                  'Fornecedor',
                  'Data Compra',
                  'Data Abertura',
                  'Princípio Ativo',
                  'Observação'
                ],
                ...tMedicamentos.map((item) => [
                      item.nomeMedicamento,
                      item.quantidade.toString(),
                      item.precoUnitario.toString(),
                      item.precoTotal.toString(),
                      item.tempoDescarteLeite,
                      item.carenciaMedicamento,
                      item.tipoDosagem,
                      item.dataVencimento,
                      item.fornecedor,
                      item.dataCompra,
                      item.dataAbertura,
                      item.principioAtivo,
                      item.observacao
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
        medicamentos.sort((a, b) {
          return a.nomeMedicamento
              .toLowerCase()
              .compareTo(b.nomeMedicamento.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        medicamentos.sort((a, b) {
          return b.nomeMedicamento
              .toLowerCase()
              .compareTo(a.nomeMedicamento.toLowerCase());
        });
        break;
    }
    setState(() {});
  }

  void filterSearchResults(String query) {
    List<Medicamento> dummySearchList = [];
    dummySearchList.addAll(items);
    if (query.isNotEmpty) {
      List<Medicamento> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.nomeMedicamento.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        medicamentos.clear();
        medicamentos.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        medicamentos.clear();
        medicamentos.addAll(items);
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
                      pdfLib.Text('Medicamentos',
                          style: pdfLib.TextStyle(
                              fontSize: 22, color: PdfColors.white))
                    ],
                  )
                ])));
  }
}

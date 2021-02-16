import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/gasto_db.dart';
import 'package:gerenciamento_rural/models/gasto.dart';
import 'package:toast/toast.dart';
import 'gastos_data.dart';

class RelatorioGastoData extends StatefulWidget {
  @override
  _RelatorioGastoDataState createState() => _RelatorioGastoDataState();
}

class _RelatorioGastoDataState extends State<RelatorioGastoData> {
  var _dataInicial = MaskedTextController(mask: '00-00-0000');
  var _dataFinal = MaskedTextController(mask: '00-00-0000');
  GastoDB helper = GastoDB();
  List<Gasto> totalGasto = List();
  List<Gasto> totalGastoData = List();
  var datainicial;
  var datafinal;

  @override
  void initState() {
    super.initState();
    getAllGastos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatório Entre Datas - Custos"),
      ),
      body: Center(
        child: Card(
          elevation: 50,
          shadowColor: Colors.black,
          color: Colors.blueGrey[800],
          child: SizedBox(
            width: 300,
            height: 200,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                children: [
                  TextField(
                    controller: _dataInicial,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        labelText: "Data Inicial",
                        labelStyle: TextStyle(color: Colors.white)),
                    onChanged: (text) {
                      setState(() {
                        datainicial = text;
                      });
                    },
                  ),
                  TextField(
                    cursorColor: Colors.white,
                    controller: _dataFinal,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        labelText: "Data Final",
                        labelStyle: TextStyle(color: Colors.white)),
                    onChanged: (text) {
                      setState(() {
                        datafinal = text;
                      });
                    },
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: verificaDatas,
                      child: Text(
                        "Gerar Relatório",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.green[900],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void verificaDatas() {
    totalGastoData = List();
    var dataini = datainicial;
    var datafim = datafinal;
    if ((dataini != null && datafim != null)) {
      String datainicial = "";
      String datafinal = "";
      datainicial = dataini.split('-').reversed.join();
      datafinal = datafim.split('-').reversed.join();

      DateTime dateIni = DateTime.parse(datainicial);
      DateTime dateFim = DateTime.parse(datafinal);

      if (dateIni.isAfter(dateFim)) {
        Toast.show("Data inválida! ${dateIni.isAfter(dateFim)}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      } else {
        totalGasto.forEach((element) {
          String stringDataServer = element.data.split('-').reversed.join();
          DateTime dateServer = DateTime.parse(stringDataServer);
          if (dateServer.compareTo(dateIni) >= 0 &&
              dateFim.compareTo(dateServer) >= 0) {
            totalGastoData.add(element);
          }
        });
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GastosData(
                    gasto: totalGastoData,
                    datainicial: dataini,
                    datafinal: datafim)));
      }
    } else {
      Toast.show("Informe os dois campos!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

  void getAllGastos() {
    helper.getAllItems().then((value) {
      setState(() {
        totalGasto = value;
      });
    });
  }
}

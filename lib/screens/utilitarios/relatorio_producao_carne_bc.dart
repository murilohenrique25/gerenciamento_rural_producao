import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/corte_abatidos_db.dart';
import 'package:gerenciamento_rural/models/corte_abatidos.dart';
import 'package:gerenciamento_rural/screens/utilitarios/producao_carne_bc_list.dart';
import 'package:toast/toast.dart';

class RelatorioProducaoCarneBC extends StatefulWidget {
  @override
  _RelatorioProducaoCarneBCState createState() =>
      _RelatorioProducaoCarneBCState();
}

class _RelatorioProducaoCarneBCState extends State<RelatorioProducaoCarneBC> {
  var _dataInicial = MaskedTextController(mask: '0000');
  CorteAbatidosDB helper = CorteAbatidosDB();

  List<CortesAbatidos> totalAbatidos = [];

  List<CortesAbatidos> totalAbatidosVerificados = [];

  var datainicial;

  @override
  void initState() {
    super.initState();
    getAllAbatidos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatório Produção Carne Bovino Corte"),
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
                        labelText: "Informe o ano",
                        labelStyle: TextStyle(color: Colors.white)),
                    onChanged: (text) {
                      setState(() {
                        datainicial = text;
                      });
                    },
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: verificaDatas,
                      child: Text(
                        "Gerar Relatório",
                        style: TextStyle(color: Colors.white),
                      ),
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
    var dataini = datainicial;
    if ((dataini != null)) {
      totalAbatidos.forEach((element) {
        var dataCompara = element.data.split("-");
        if (dataCompara[2] == dataini) {
          totalAbatidosVerificados.add(element);
        }
      });
      print(totalAbatidosVerificados.length);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProducaoCarneBcLista(
                  cortes: totalAbatidosVerificados, data: dataini)));
    } else {
      Toast.show("Informe o campo ano!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

  void getAllAbatidos() {
    helper.getAllItemsAbates().then((value) {
      setState(() {
        totalAbatidos = value;
      });
    });
  }
}

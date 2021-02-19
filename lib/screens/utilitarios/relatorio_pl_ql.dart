import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:gerenciamento_rural/helpers/preco_leite_db.dart';
import 'package:gerenciamento_rural/helpers/producao_leite_db.dart';
import 'package:gerenciamento_rural/models/leite.dart';
import 'package:gerenciamento_rural/models/preco_leite.dart';
import 'package:gerenciamento_rural/screens/utilitarios/preco_leite_quant_litros.dart';
import 'package:toast/toast.dart';

class RelatorioPrecoLeiteQuantLitro extends StatefulWidget {
  @override
  _RelatorioPrecoLeiteQuantLitroState createState() =>
      _RelatorioPrecoLeiteQuantLitroState();
}

class _RelatorioPrecoLeiteQuantLitroState
    extends State<RelatorioPrecoLeiteQuantLitro> {
  var _dataInicial = MaskedTextController(mask: '00-0000');
  PrecoLeiteDB helperleite = PrecoLeiteDB();
  LeiteDB helper = LeiteDB();

  List<Leite> totalLeite = List();
  List<Leite> totalLeiteData = List();

  List<PrecoLeite> totalPrecoLeite = List();
  double _precoCadastradoSistema = 0.0;
  String mes;
  var datainicial;

  @override
  void initState() {
    super.initState();
    getAllGastos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatório Preço do Leite x Quant. litros"),
      ),
      body: Center(
        child: Card(
          elevation: 50,
          shadowColor: Colors.black,
          color: Colors.blueGrey[800],
          child: SizedBox(
            width: 300,
            height: 150,
            child: Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                children: [
                  TextField(
                    controller: _dataInicial,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        labelText: "Informe o mês e o ano",
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
    totalLeiteData = List();
    var dataini = datainicial;
    if ((dataini != null)) {
      var datainicial = dataini.split('-');
      switch (datainicial[0]) {
        case "01":
          mes = "Janeiro";
          break;
        case "02":
          mes = "Fevereiro";
          break;
        case "03":
          mes = "Março";
          break;
        case "04":
          mes = "Abril";
          break;
        case "05":
          mes = "Maio";
          break;
        case "06":
          mes = "Junho";
          break;
        case "07":
          mes = "Julho";
          break;
        case "08":
          mes = "Agosto";
          break;
        case "09":
          mes = "Setembro";
          break;
        case "10":
          mes = "Outubro";
          break;
        case "11":
          mes = "Novembro";
          break;
        case "12":
          mes = "Dezembro";
          break;
        default:
          mes = "Inexistente";
      }
      totalLeite.forEach((element) {
        var stringDataServer = element.dataColeta.split('-');
        if ((stringDataServer[1] == datainicial[0]) &&
            (stringDataServer[2] == datainicial[1])) {
          totalLeiteData.add(element);
        }
      });
      totalPrecoLeite.forEach((element) {
        var stringDataServer = element.data.split('-');
        if ((stringDataServer[0] == datainicial[0]) &&
            (stringDataServer[1] == datainicial[1])) {
          _precoCadastradoSistema = element.preco;
        }
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrecoLeiteQuantLitros(
              leites: totalLeiteData,
              precoMes: _precoCadastradoSistema,
              mes: mes),
        ),
      );
    } else {
      Toast.show("Informe os dois campos!", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

  void getAllGastos() {
    helper.getAllItems().then((value) {
      setState(() {
        totalLeite = value;
      });
    });
    helperleite.getAllItems().then((value) {
      setState(() {
        totalPrecoLeite = value;
      });
    });
  }
}

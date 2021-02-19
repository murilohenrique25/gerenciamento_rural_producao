import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/utilitarios/relatorio_gasto_data.dart';
import 'package:gerenciamento_rural/screens/utilitarios/relatorio_pl_ql.dart';

class Relatorios extends StatefulWidget {
  @override
  _RelatoriosState createState() => _RelatoriosState();
}

class _RelatoriosState extends State<Relatorios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relatórios"),
        centerTitle: true,
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: RaisedButton(
                        color: Colors.green[900],
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RelatorioGastoData()));
                        },
                        child: Text(
                          "Relatório Balanço Geral",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      child: RaisedButton(
                        color: Colors.green[900],
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RelatorioPrecoLeiteQuantLitro()));
                        },
                        child: Text(
                          "Relatório Quant. leite x Preço leite",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}

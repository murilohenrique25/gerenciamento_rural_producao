import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/second_screen/reproducao/estoque_semen_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/second_screen/reproducao/historico_partos_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/bovino_corte/second_screen/reproducao/inseminacao_bovino_corte_screen.dart';

class DescriptionReproducaoBovinoCorte extends StatefulWidget {
  @override
  _DescriptionReproducaoBovinoCorteState createState() =>
      _DescriptionReproducaoBovinoCorteState();
}

class _DescriptionReproducaoBovinoCorteState
    extends State<DescriptionReproducaoBovinoCorte> {
  double _height = 130.0;
  double _width = 130.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gestão"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Image.asset(
              "images/telainicial.png",
              fit: BoxFit.cover,
              height: 1000.0,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: _width,
                          height: _height,
                          color: Colors.grey[50],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: EstoqueSemenBovinoCorteScreen(),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: _width,
                          height: _height,
                          color: Colors.grey[50],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: InseminacaoBovinoCorteScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: _width,
                          height: _height,
                          color: Colors.grey[50],
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: HistoricoPartoBovinoCorteScreen(),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

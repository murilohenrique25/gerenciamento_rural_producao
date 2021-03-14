import 'package:flutter/material.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/reproducao_screen/estoque_semen_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/reproducao_screen/historico_partos_screen.dart';
import 'package:gerenciamento_rural/screens/screen_animal/suino/second_screen/screen/reproducao_screen/inseminacao_monta_screen.dart';

class DescriptionReproducaoSuinos extends StatefulWidget {
  @override
  _DescriptionReproducaoSuinosState createState() =>
      _DescriptionReproducaoSuinosState();
}

class _DescriptionReproducaoSuinosState
    extends State<DescriptionReproducaoSuinos> {
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
                          child: EstoqueSemenScreen(),
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
                          child: InseminacaoMontaScreen(),
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
                          child: HistoricoPartoScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
